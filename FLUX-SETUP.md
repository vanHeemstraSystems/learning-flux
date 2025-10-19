# Flux Setup Guide

This guide will help you set up Flux to manage your Kubernetes demo application using GitOps principles.

## Prerequisites

- A Kubernetes cluster (minikube, kind, k3s, or cloud-based)
- kubectl configured to access your cluster
- GitHub personal access token with repo permissions
- flux CLI installed

## Installing Flux CLI

### macOS

```bash
brew install fluxcd/tap/flux
```

### Linux

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```

### Windows

```powershell
choco install flux
```

## Pre-flight Check

Verify your cluster is ready for Flux:

```bash
flux check --pre
```

## Bootstrap Flux

Bootstrap Flux to your cluster and connect it to your GitHub repository:

```bash
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=vanHeemstraSystems

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=learning-flux \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal
```

This will:

- Install Flux components in the `flux-system` namespace
- Create a deploy key in your GitHub repository
- Create Flux configuration files in `./clusters/my-cluster/`
- Commit and push the changes to your repository

## Repository Structure

```
learning-flux/
├── apps/
│   └── demo/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── namespace.yaml
│       └── kustomization.yaml
├── infrastructure/
│   └── (infrastructure components)
├── clusters/
│   └── my-cluster/
│       └── flux-system/
│           ├── gotk-components.yaml
│           ├── gotk-sync.yaml
│           └── kustomization.yaml
└── flux-system/
    ├── gitrepository.yaml
    └── kustomization.yaml
```

## Deploying the Demo Application

1. **Add Flux resources to your repository:**

Copy the files from this repository:

- `flux-system/gitrepository.yaml` → Root of your repo
- `flux-system/kustomization.yaml` → Root of your repo
- `apps/demo/*` → Your apps directory

1. **Commit and push to GitHub:**

```bash
git add .
git commit -m "Add Flux configuration and demo app"
git push
```

1. **Watch Flux reconcile:**

```bash
# Watch GitRepository
flux get sources git

# Watch Kustomization
flux get kustomizations

# Watch all
watch flux get all
```

1. **Check the demo app deployment:**

```bash
kubectl get deployments -n default
kubectl get pods -n default
kubectl get services -n default
```

1. **Access the demo application:**

```bash
# Port-forward to access locally
kubectl port-forward svc/demo-app 9898:9898 -n default

# Visit http://localhost:9898
```

## Flux Commands Cheat Sheet

### Check Status

```bash
flux get all
flux get sources git
flux get kustomizations
```

### Force Reconciliation

```bash
flux reconcile source git learning-flux
flux reconcile kustomization demo-app
```

### Suspend/Resume

```bash
flux suspend kustomization demo-app
flux resume kustomization demo-app
```

### Logs

```bash
flux logs --all-namespaces --follow --tail=10
```

### Uninstall Flux

```bash
flux uninstall
```

## GitOps Workflow

1. **Make changes to your manifests** in the repository
1. **Commit and push** to GitHub
1. **Flux automatically detects** changes (default: every 1 minute)
1. **Flux applies** changes to your cluster
1. **Monitor** the reconciliation process

## Image Automation (Optional)

To enable automatic image updates:

1. **Create ImageRepository:**

```yaml
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImageRepository
metadata:
  name: demo-app
  namespace: flux-system
spec:
  image: ghcr.io/stefanprodan/podinfo
  interval: 1m0s
```

1. **Create ImagePolicy:**

```yaml
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImagePolicy
metadata:
  name: demo-app
  namespace: flux-system
spec:
  imageRepositoryRef:
    name: demo-app
  policy:
    semver:
      range: 6.x.x
```

1. **Add image automation marker to deployment:**

```yaml
spec:
  containers:
  - name: demo-app
    image: ghcr.io/stefanprodan/podinfo:6.5.4 # {"$imagepolicy": "flux-system:demo-app"}
```

## Troubleshooting

### Check Flux component health

```bash
flux check
```

### View reconciliation errors

```bash
flux get kustomizations
kubectl describe kustomization -n flux-system demo-app
```

### View controller logs

```bash
kubectl logs -n flux-system deployment/source-controller
kubectl logs -n flux-system deployment/kustomize-controller
```

## Next Steps

- Explore multi-environment deployments (dev, staging, prod)
- Add Helm releases
- Implement progressive delivery with Flagger
- Set up notifications (Slack, Discord, etc.)
- Add secrets management with SOPS or Sealed Secrets

## Resources

- [Flux Documentation](https://fluxcd.io/docs/)
- [Flux Best Practices](https://fluxcd.io/docs/guides/)
- [GitOps Toolkit](https://toolkit.fluxcd.io/)
