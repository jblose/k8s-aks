
# AKS Specifics

## Service Principle Creation

```bash
az login
az ad sp create-for-rbac --skip-assignment
```

## Export variables from created Service Principle

```bash
export TF_VAR_az_client_id='<appId>'
export TF_VAR_az_client_secret='<password>'
```

## Export any specific variables

```bash
export TF_VAR_az_suffix='<unique suffix to use>'
```

## Execute Terraform plan

```bash
az login
terraform apply # Review plan for expected executions
```

## Configure AKS Credentials into local .kube

```bash
az aks get-credentials --resource-group <AKS Resource Group> --name <AKS Cluster Name>
```
