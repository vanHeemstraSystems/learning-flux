#!/bin/bash

# Flux Quick Start Script

# This script helps you quickly set up Flux and deploy the demo application

set -e

# Colors for output

RED=’\033[0;31m’
GREEN=’\033[0;32m’
YELLOW=’\033[1;33m’
NC=’\033[0m’ # No Color

# Configuration

GITHUB_USER=”${GITHUB_USER:-vanHeemstraSystems}”
REPO_NAME=“learning-flux”
CLUSTER_PATH=”./clusters/my-cluster”

echo -e “${GREEN}=== Flux Quick Start ===${NC}\n”

# Function to print status

print_status() {
echo -e “${GREEN}✓${NC} $1”
}

print_warning() {
echo -e “${YELLOW}⚠${NC} $1”
}

print_error() {
echo -e “${RED}✗${NC} $1”
}

# Check prerequisites

echo “Checking prerequisites…”

# Check kubectl

if ! command -v kubectl &> /dev/null; then
print_error “kubectl not found. Please install kubectl first.”
exit 1
fi
print_status “kubectl found”

# Check flux CLI

if ! command -v flux &> /dev/null; then
print_error “flux CLI not found. Please install it first:”
echo “  macOS: brew install fluxcd/tap/flux”
echo “  Linux: curl -s https://fluxcd.io/install.sh | sudo bash”
exit 1
fi
print_status “flux CLI found”

# Check cluster access

if ! kubectl cluster-info &> /dev/null; then
print_error “Cannot connect to Kubernetes cluster. Please check your kubeconfig.”
exit 1
fi
print_status “Kubernetes cluster accessible”

# Check GitHub token

if [ -z “$GITHUB_TOKEN” ]; then
print_error “GITHUB_TOKEN environment variable not set.”
echo “Please set it with: export GITHUB_TOKEN=<your-token>”
exit 1
fi
print_status “GitHub token found”

# Run Flux pre-flight checks

echo -e “\nRunning Flux pre-flight checks…”
if flux check –pre; then
print_status “Cluster is ready for Flux”
else
print_error “Cluster failed pre-flight checks”
exit 1
fi

# Ask for confirmation

echo -e “\n${YELLOW}This will bootstrap Flux on your cluster.${NC}”
echo “Repository: $GITHUB_USER/$REPO_NAME”
echo “Cluster path: $CLUSTER_PATH”
read -p “Continue? (y/n) “ -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
echo “Aborted.”
exit 1
fi

# Bootstrap Flux

echo -e “\n${GREEN}Bootstrapping Flux…${NC}”
flux bootstrap github   
–owner=”$GITHUB_USER”   
–repository=”$REPO_NAME”   
–branch=main   
–path=”$CLUSTER_PATH”   
–personal   
–token-auth

print_status “Flux bootstrapped successfully”

# Wait for Flux to be ready

echo -e “\n${GREEN}Waiting for Flux controllers to be ready…${NC}”
kubectl wait –for=condition=ready pod -l app.kubernetes.io/part-of=flux -n flux-system –timeout=5m

print_status “Flux controllers are ready”

# Check Flux status

echo -e “\n${GREEN}Checking Flux status…${NC}”
flux get all

# Instructions for next steps

echo -e “\n${GREEN}=== Setup Complete! ===${NC}\n”
echo “Next steps:”
echo “  1. Add your application manifests to the apps/ directory”
echo “  2. Commit and push your changes”
echo “  3. Watch Flux reconcile: flux get all -w”
echo “  4. Check the demo app: kubectl get pods -n default”
echo “”
echo “Useful commands:”
echo “  - View Flux logs: flux logs –all-namespaces –follow”
echo “  - Force reconciliation: flux reconcile source git flux-system”
echo “  - Check status: flux get all”
echo “”
echo “For more information, see FLUX-SETUP.md”
