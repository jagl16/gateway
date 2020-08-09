.PHONY: tf-init
tf-init:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform init

.PHONY: tf-fmt
tf-fmt:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform fmt -recursive

.PHONY: tf-validate
tf-validate:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform validate

.PHONY: tf-refresh
tf-refresh:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform refresh

.PHONY: tf-plan
tf-plan:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform plan

.PHONY: tf-apply
tf-apply:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform apply

.PHONY: tf-approved-apply
tf-approved-apply:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform apply -auto-approve

.PHONY: tf-destroy
tf-destroy:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform destroy

.PHONY: tf-approved-apply
tf-approved-destroy:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform destroy -auto-approve

.PHONY: tf-destroy
tf-current-workspace:
	docker-compose -f .devops/terraform/docker-compose.yml run --rm terraform workspace show
