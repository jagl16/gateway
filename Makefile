include .devops/terraform/terraform.mk

install-git-hooks:
	scripts/hooks/install.sh
