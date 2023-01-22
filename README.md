# Terraform example for IDCF Cloud

```
$ export TF_VAR_api_url=<your-api-url>
$ export TF_VAR_api_key=<your-api-key>
$ export TF_VAR_secret_key=<your-secret-key>
```

```
$ vi dev.tfvars
network_id = "<your-network-id>"
zone       = "<your-zone>"
cidr_list  = ["<your-ip-1>/32", "<your-ip-2>/32"]
```

```
$ terraform plan -var-file dev.tfvars
$ terraform apply -var-file dev.tfvars
$ terraform destroy
```
