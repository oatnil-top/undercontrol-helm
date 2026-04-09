# UnDercontrol Helm Charts

Helm charts for deploying [UnDercontrol](https://github.com/lintaoamons/undercontrol) on Kubernetes.

## Usage

### Add the Helm repository

```bash
helm repo add undercontrol https://lintaoamons.github.io/undercontrol-helm
helm repo update
```

### Install with default values (SQLite, ClusterIP)

```bash
helm install undercontrol undercontrol/undercontrol \
  --set backend.jwt.secret=my-secret-key \
  --set backend.licenseToken=my-license
```

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
helm install undercontrol oci://ghcr.io/lintaoamons/undercontrol \
  --set backend.jwt.secret=my-secret-key
```

## Configuration

See [values.yaml](charts/undercontrol/values.yaml) for the full list of configurable parameters.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.enabled` | Deploy backend | `true` |
| `backend.database.type` | `sqlite` or `postgres` | `sqlite` |
| `backend.jwt.secret` | JWT signing secret | `""` |
| `backend.s3.enabled` | Enable S3 storage | `false` |
| `backend.persistence.enabled` | Enable PVC for data | `true` |
| `frontend.enabled` | Deploy frontend | `true` |
| `ingress.enabled` | Enable Ingress | `false` |

## Development

```bash
# Lint
helm lint charts/undercontrol

# Template render
helm template my-release charts/undercontrol

# Template with custom values
helm template my-release charts/undercontrol -f my-values.yaml
```
