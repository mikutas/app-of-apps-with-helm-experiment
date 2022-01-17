cluster:
	kind create cluster || true

argocd: cluster
	kubectl create namespace argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl patch -n argocd cm argocd-cm -p '{"data": {"resource.customizations.health.argoproj.io_Application": "hs = {}\nhs.status = \"Progressing\"\nhs.message = \"\"\nif obj.status ~= nil then\n  if obj.status.health ~= nil then\n    hs.status = obj.status.health.status\n    if obj.status.health.message ~= nil then\n      hs.message = obj.status.health.message\n    end\n  end\nend\nreturn hs\n"}}'

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
