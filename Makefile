cluster:
	kind create cluster || true

argocd: cluster
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd-uninstall:
	kubectl delete namespace argocd

clean:
	kind delete cluster
