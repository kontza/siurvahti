# tags = $(shell ansible-playbook --list-tags install.yaml 2>&1|awk -F'[\]\[]' '/TASK TAGS/{gsub(/,/,"",$$2);print $$2}')
# .PHONY: $(tags)

# $(tags):
# 	echo ansible-playbook -i hosts -t $@ --vault-password-file=.vault-password.txt site.yml
TAGS=all
DEFAULT_PASS=scripts/become-pass

.PHONY: target-%
target-%: ## Generic target called by all other targets
	echo ansible-playbook -i ${INVENTORY} --vault-password-file scripts/vault-pass --become-password-file ${BECOME_PASS} install.yaml -t${TAGS}

.PHONY: kaivoskarhu
kaivoskarhu: export INVENTORY=$@
kaivoskarhu: export BECOME_PASS=scripts/$@-pass
kaivoskarhu: ## Home Pi-hole
	$(MAKE) target-$@

.PHONY: siurvahti
siurvahti: export INVENTORY=$@
siurvahti: export BECOME_PASS=${DEFAULT_PASS}
siurvahti: ## Countryside Pi-hole
	$(MAKE) target-$@

.PHONY: siurvahti-micro-os
siurvahti-micro-os: export INVENTORY=$@
siurvahti-micro-os: export BECOME_PASS=${DEFAULT_PASS}
siurvahti-micro-os: ## VMware instance for developing purposes
	$(MAKE) target-$@

.PHONY: uusikarhu
uusikarhu: export INVENTORY=$@
uusikarhu: export BECOME_PASS=scripts/$@-pass
uusikarhu: ## Home development host
	$(MAKE) target-$@

.PHONY: collections
collections: ## Required collections
	ansible-galaxy collection install -r requirements.yml -U

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help