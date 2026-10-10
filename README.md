# UnDercontrol Helm Charts

Helm charts for deploying [UnDercontrol](https://github.com/oatnil-top/undercontrol) on Kubernetes.

## Usage

### Add the Helm repository

```bash
helm repo add undercontrol https://oatnil-top.github.io/undercontrol-helm
helm repo update
```

### Install with default values (SQLite, ClusterIP)

```bash
helm install undercontrol undercontrol/undercontrol \
  --create-namespace --namespace undercontrol \
  --set backend.jwt.secret=change-me-to-a-random-string \
  --set backend.admin.email=admin@example.com \
  --set backend.admin.password=changeme \
  --set backend.licenseToken=<license token> \
  --set backend.licenseHostSecret=<license host secret>
kubectl -n undercontrol port-forward svc/undercontrol-frontend 3000:80
```

Then open http://localhost:3000 and log in with the admin account. A free Pro
trial license (token + host secret) is on https://udctl.com/self-hosting.
With a license set, `backend.admin.email` is required: a Pro/Max server does
not start without an admin account, so the chart refuses to render without it.

### Install with PostgreSQL

```bash
helm install undercontrol undercontrol/undercontrol \
  --set backend.jwt.secret=my-secret-key \
  --set backend.licenseToken=my-license \
  --set backend.database.type=postgres \
  --set backend.database.postgres.host=my-postgres \
  --set backend.database.postgres.password=my-password
```

### Install with NodePort access

```bash
helm install undercontrol undercontrol/undercontrol \
  --set backend.jwt.secret=my-secret-key \
  --set backend.service.type=NodePort \
  --set backend.service.nodePort=30880 \
  --set frontend.service.type=NodePort \
  --set frontend.service.nodePort=30800
```

### Install via OCI registry

```bash
helm install undercontrol oci://ghcr.io/oatnil-top/undercontrol \
  --set backend.jwt.secret=my-secret-key
```

## Configuration

See [values.yaml](charts/undercontrol/values.yaml) for the full list of configurable parameters.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.enabled` | Deploy backend | `true` |
| `backend.database.type` | `sqlite` or `postgres` | `sqlite` |
| `backend.jwt.secret` | JWT signing secret | `""` |
| `backend.licenseToken` | License token (`LICENSE_TOKEN`) | `""` |
| `backend.licenseHostSecret` | Host secret the token was issued for (`LICENSE_HOST_SECRET`) | `""` |
| `backend.admin.email` / `backend.admin.password` | Admin account created on first start | `""` |
| `backend.registrationEnabled` | Let others sign up | `false` |
| `backend.hostDomain` | Public URL (`HOST_DOMAIN`) | first ingress host, else `http://localhost:3000` |
| `backend.s3.enabled` | Enable S3 storage | `false` |
| `backend.persistence.enabled` | Enable PVC for data | `true` |
| `frontend.enabled` | Deploy frontend | `true` |
| `ingress.enabled` | Enable Ingress | `false` |

## Versioning

The chart version equals the UnDercontrol version it deploys, and the default
images are `docker.io/lintao0o0/undercontrol-backend` and
`docker.io/lintao0o0/undercontrol-vite-app` at that tag. The Release Charts
workflow runs hourly: when a newer release has both images on Docker Hub,
`scripts/follow-release.sh` bumps `Chart.yaml` and the same job publishes it.
A change to the templates alone is published with the next UnDercontrol
release; to ship it sooner, run the workflow after the next release, or bump
`version` by hand.

## Development

```bash
# Lint
helm lint charts/undercontrol

# Template render
helm template my-release charts/undercontrol

# Template with custom values
helm template my-release charts/undercontrol -f my-values.yaml
```
