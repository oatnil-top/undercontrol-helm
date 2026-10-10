#!/usr/bin/env bash
# Bump the chart to the newest UnDercontrol release whose backend AND frontend
# images are both on Docker Hub. The chart version tracks the app version.
#
# Why this exists: the chart was released once by hand (0.65.2, 2026-04-09) and
# nothing in the UnDercontrol release pipeline knows this repo, so it sat at
# 0.65.2 while the app shipped ~100 releases. Release Charts now runs this on a
# schedule; a bump commit is released by chart-releaser in the same job.
#
# Usage: scripts/follow-release.sh [--dry-run]
# Prints "bumped=<version>" or "bumped=" to $GITHUB_OUTPUT when set.
set -euo pipefail

CHART=charts/undercontrol/Chart.yaml
REPOS=(lintao0o0/undercontrol-backend lintao0o0/undercontrol-vite-app)
DRY_RUN=${1:-}

tags() {
  # Plain X.Y.Z tags only (no latest, no pre-releases), first 100 by recency.
  curl -fsSL "https://hub.docker.com/v2/repositories/$1/tags?page_size=100&ordering=last_updated" |
    python3 -c 'import sys,json,re
for t in json.load(sys.stdin)["results"]:
    if re.fullmatch(r"\d+\.\d+\.\d+", t["name"]): print(t["name"])' | sort -u
}

common=$(comm -12 <(tags "${REPOS[0]}") <(tags "${REPOS[1]}"))
latest=$(printf '%s\n' "$common" | sort -V | tail -1)
current=$(sed -n 's/^appVersion: *"\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$CHART")

if [ -z "$latest" ] || [ -z "$current" ]; then
  echo "could not read versions (latest='$latest' current='$current')" >&2
  exit 1
fi

newest=$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1)
echo "chart appVersion=$current, newest release with both images=$latest"

bumped=
if [ "$newest" != "$current" ]; then
  if [ "$DRY_RUN" = "--dry-run" ]; then
    echo "would bump to $latest"
  else
    sed -i.bak -e "s/^version: .*/version: $latest/" -e "s/^appVersion: .*/appVersion: \"$latest\"/" "$CHART"
    rm -f "$CHART.bak"
    git add "$CHART"
    git commit -m "release: undercontrol chart v$latest (follows UnDercontrol $latest)"
    git push origin HEAD:main
    bumped=$latest
  fi
fi

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "bumped=$bumped" >> "$GITHUB_OUTPUT"
fi
