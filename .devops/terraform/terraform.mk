tf-init-prod	tf-plan-prod	tf-apply-prod	tf-state-prod	tf-destroy-prod: TERRAFORMWORKDIR=terraform/environments/production

TERRAFORM_IMAGE := hashicorp/terraform@sha256:691e2f368183a1886b50fd7da16b4511f5ac914ff6b7c748a87a37e84b898c50

TERRAFORM = docker run --rm \
      	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
      	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
      	-e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
		-v "${CURDIR}/.devops:/src" \
		-w /src/$(TERRAFORMWORKDIR) \
		${TERRAFORM_IMAGE}

RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(args) $(RUN_ARGS):;@:)

.PHONY: tf-fmt
tf-fmt: ## Invokes terraform fmt command
	${TERRAFORM} fmt -recursive

.PHONY: tf-validate
tf-validate: ## Invokes terraform validate command
	${TERRAFORM} init -backend=false
	${TERRAFORM} validate
	${TERRAFORM} fmt -check

.PHONY: tf-init-%
tf-init-%: ## Invokes terraform plan command
	${TERRAFORM} init

.PHONY: tf-plan-%
tf-plan-%: ## Invokes terraform plan command
	${TERRAFORM} plan

.PHONY: tf-apply-%
tf-apply-%: ## Invokes terraform apply command
	${TERRAFORM} apply -auto-approve

.PHONY: tf-state-%
tf-state-%: ## Invokes terraform state command
	${TERRAFORM} state $(args) $(RUN_ARGS)

.PHONY: tf-destroy-%
tf-destroy-%:  ## Invokes terraform destroy command
	${TERRAFORM}  destroy -auto-approve
