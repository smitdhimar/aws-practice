app-name-%-init:
	cd environments/$* && terraform	 init
app-name-%-plan:
	cd environments/$* && terraform plan
app-name-%-apply:
	cd environments/$* && terraform apply --auto-approve
app-name-%-destroy:
	cd environments/$* && terraform destroy