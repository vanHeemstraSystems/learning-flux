.PHONY: help bootstrap check reconcile status logs suspend resume uninstall port-forward

help: ## Display this help
@awk ’BEGIN {FS = “:.*##”; printf “\nUsage:\n  make \033[36m<target>\033[0m\n”} /^[a-zA-Z_-]+:.*?##/ { printf “  \033[36m%-15s\033[0m %s\n”, $$1, $$2 } /^##@/ { printf “\n\033[1m%s\033[0m\n”, substr($$0, 5) } ’ $(MAKEFILE_LIST)

##@ Flux Setup

bootstrap: ## Bootstrap Flux on the cluster
@echo “Bootstrapping Flux…”
flux bootstrap github   
–owner=$(GITHUB_USER)   
–repository=learning-flux   
–branch=main   
–path=./clusters/my-cluster   
–personal

check: ## Run Flux pre-flight checks
flux check –pre

##@ Flux Operations

reconcile: ## Force reconciliation of all Flux resources
flux reconcile source git flux-system
flux reconcile kustomization demo-app

status: ## Show status of all Flux resources
@echo “=== Git Sources ===”
flux get sources git
@echo “\n=== Kustomizations ===”
flux get kustomizations
@echo “\n=== All Resources ===”
flux get all

logs: ## Follow Flux controller logs
flux logs –all-namespaces –follow –tail=10

suspend: ## Suspend the demo app Kustomization
flux suspend kustomization demo-app

resume: ## Resume the demo app Kustomization
flux resume kustomization demo-app

##@ Application

port-forward: ## Port-forward to the demo app
kubectl port-forward svc/demo-app 9898:9898 -n default

get-pods: ## Get pods for the demo app
kubectl get pods -n default -l app=demo-app

get-deployments: ## Get deployments
kubectl get deployments -n default

describe-deployment: ## Describe the demo app deployment
kubectl describe deployment demo-app -n default

##@ Cleanup

uninstall: ## Uninstall Flux from the cluster
flux uninstall –silent
