tf-plan-prod	tf-apply-prod	tf-destroy-prod: TERRAFORMWORKDIR=terraform/environments/production

TERRAFORM_IMAGE := hashicorp/terraform@sha256:691e2f368183a1886b50fd7da16b4511f5ac914ff6b7c748a87a37e84b898c50

TERRAFORM = docker run --rm \
      	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
      	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
      	-e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
		-v "${CURDIR}/.devops:/src" \
		-w /src/$(TERRAFORMWORKDIR) \
		${TERRAFORM_IMAGE}

.PHONY: tf-fmt
tf-fmt: ## Invokes terraform fmt command
	${TERRAFORM} fmt -recursive

.PHONY: tf-validate
tf-validate: ## Invokes terraform validate command
	${TERRAFORM} init -backend=false
	${TERRAFORM} validate
	${TERRAFORM} fmt -check

.PHONY: tf-plan-%
tf-plan-%: ## Invokes terraform plan command
	${TERRAFORM} init
	${TERRAFORM} plan

.PHONY: tf-apply-%
tf-apply-%: ## Invokes terraform apply command
	${TERRAFORM} init
	${TERRAFORM} apply -auto-approve

.PHONY: tf-destroy-%
tf-destroy-%:  ## Invokes terraform destroy command
	${TERRAFORM}  destroy
