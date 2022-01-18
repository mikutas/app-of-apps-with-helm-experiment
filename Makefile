cluster:
	kind create cluster || true

argocd: cluster
	kubectl create namespace argocd || true
	kustomize build . | kubectl apply -n argocd -f -

password:
	@kubectl view-secret argocd-initial-admin-secret -n argocd --quiet

argocd-uninstall:
	kubectl delete namespace argocd

clean:
	kind delete cluster
