# tags = $(shell ansible-playbook --list-tags install.yaml 2>&1|awk -F'[\]\[]' '/TASK TAGS/{gsub(/,/,"",$$2);print $$2}')
# .PHONY: $(tags)

# $(tags):
# 	echo ansible-playbook -i hosts -t $@ --vault-password-file=.vault-password.txt site.yml
TAGS=all
BECOME_PASS=scripts/become-pass
PLAYBOOK=install.yaml

define run-ansible
	ansible-playbook -i $(INVENTORY) --vault-password-file scripts/vault-pass --become-password-file $(BECOME_PASS) $(PLAYBOOK) -t$(TAGS)
endef

define debian-ansible
	ansible-playbook -i $(INVENTORY) --vault-password-file scripts/vault-pass --become-password-file $(BECOME_PASS) $(PLAYBOOK) --become-method=su -t$(TAGS)
endef

define prepare-combustion
	ansible-playbook $(PLAYBOOK) -t$(TAGS) -ecombustion=$(TARGET)
endef

.PHONY: kaivoskarhu
kaivoskarhu: INVENTORY=$@
kaivoskarhu: BECOME_PASS=scripts/debian-pass
kaivoskarhu: ## Home Pi-hole
	$(debian-ansible)

.PHONY: siurvahti
siurvahti: INVENTORY=$@
siurvahti: BECOME_PASS=scripts/debian-pass
siurvahti: ## Countryside Pi-hole
	$(debian-ansible)

.PHONY: viurvahti
viurvahti: INVENTORY=$@
viurvahti: BECOME_PASS=scripts/debian-pass
viurvahti: ## Mimic the countryside Pi-hole with VMware
	$(debian-ansible)

.PHONY: uusikarhu
uusikarhu: INVENTORY=$@
uusikarhu: BECOME_PASS=scripts/home-server-pass
uusikarhu: ## Home development host
	$(run-ansible)

.PHONY: otsonkolo
otsonkolo: INVENTORY=$@
otsonkolo: BECOME_PASS=scripts/debian-pass
otsonkolo: PLAYBOOK=otsonkolo.yaml
otsonkolo: ## Main home server
	$(debian-ansible)

.PHONY: votsonkolo
votsonkolo: INVENTORY=$@
votsonkolo: BECOME_PASS=scripts/new-home-pass
votsonkolo: PLAYBOOK=otsonkolo.yaml
votsonkolo: ## Main home server replicant in VMware
	$(run-ansible)

.PHONY: butane-config
butane-config:
	@butane config.bu|gzip -9|base64 -|pbcopy
	@echo "Config copied to the clipboard."

.PHONY: prepare
prepare: ## Install required collections
	ansible-galaxy collection install -r requirements.yml -U

.PHONE: combustion-otsonkolo
combustion-otsonkolo: PLAYBOOK=$@.yaml
combustion-otsonkolo: TARGET=
combustion-otsonkolo: ## Setup combustion folder for otsonkolo (pass TARGET on command line to specify the target directory)
	$(prepare-combustion)

# This nifty trick is from https://github.com/paulRbr/ansible-makefile/blob/master/Makefile
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
