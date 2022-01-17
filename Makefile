cluster:
	kind create cluster || true

argocd: cluster
	kubectl create namespace argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl patch -n argocd cm argocd-cm -p '{"data": {"resource.customizations": "argoproj.io/Application:\n  health.lua: |\n    hs = {}\n    hs.status = \"Progressing\"\n    hs.message = \"\"\n    if obj.status ~= nil then\n      if obj.status.health ~= nil then\n        if obj.status.health == \"Progressing\" then\n          hs.status = \"Progressing\"\n          hs.message = \"\"\n        elseif obj.status.health == \"Missing\" then\n          hs.status = \"Degraded\"\n          hs.message = obj.status.health.message\n        else\n          hs.status = obj.status.health.status\n          hs.message = obj.status.health.message\n        end\n      end\n    end\n    return hs\n"}}'

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
