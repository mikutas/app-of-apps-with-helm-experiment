cluster:
	kind create cluster || true

argocd: cluster
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

print-passwd:
	@kubectl view-secret argocd-initial-admin-secret -n argocd --quiet

argocd-uninstall:
	kubectl delete namespace argocd

.PHONY: parent1
parent1:
	helmfile -f helmfile1.yaml apply

.PHONY: parent2
parent2:
	helmfile -f helmfile2.yaml apply

clean:
	kind delete cluster
