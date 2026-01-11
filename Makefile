init:
	brew install terraform; \
	terraform init;

plan:
	terraform plan -out=terraform-plan.txt; \
	terraform show terraform-plan.txt;

apply:
	terraform apply --auto-approve; \

destroy:
	terraform destroy --auto-approve; \