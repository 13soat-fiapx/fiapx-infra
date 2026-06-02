param ([Parameter(Mandatory)][string]$name, [string]$environment, [string]$path)
. "$PSScriptRoot/get-environment.ps1"
$environment = Get-Environment $environment

if ([string]::IsNullOrWhiteSpace($path)) {
    $path = $name
}

# back-end do Terraform
$projectName = "fiapx"
$bucketName = "$projectName-tf-$(aws sts get-access-key-info --access-key-id $(aws configure get aws_access_key_id) --query Account --output text)"
Write-Host -ForegroundColor Yellow "Creating bucket '$bucketName'..."
aws s3 mb s3://$bucketName --region us-east-1 | Out-Null

# subir infraestrutura pelo Terraform
Write-Host
Write-Host -ForegroundColor Yellow "Updating infrastructure for layer '$name' in environment '$environment'..."
  
terraform -chdir="./$path" init -backend-config="bucket=$bucketName" -backend-config="key=$name-$environment.tfstate" -reconfigure
if ($LASTEXITCODE -ne 0) { throw "Terraform init failed for $name" } 

terraform -chdir="./$path" apply -var="environment=$environment" -auto-approve
if ($LASTEXITCODE -ne 0) { throw "Terraform apply failed for $name" } 

Write-Host
Write-Host -ForegroundColor Green "Infrastructure for environment '$environment' has been applied."
