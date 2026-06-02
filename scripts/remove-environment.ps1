param ([string]$environment)
. "$PSScriptRoot/get-environment.ps1"
$environment = Get-Environment $environment

$accountId = aws sts get-access-key-info --access-key-id $(aws configure get aws_access_key_id) --query Account --output text
$projectName = "fiapx"
$bucketName = "$projectName-tf-$accountId"

Write-Host -ForegroundColor Yellow "Destroying environment: $environment"

function DestroyLayer {
  param (
    [Parameter(Mandatory)][string]$name
  )
  
  Write-Host
  Write-Host -ForegroundColor Yellow "Processing layer '$name'..."

  terraform -chdir="./$name" init -backend-config="bucket=$bucketName" -backend-config="key=$name-$environment.tfstate" -reconfigure
  if ($LASTEXITCODE -ne 0) { throw "Terraform init failed for $name" } 

  terraform -chdir="./$name" destroy -var="environment=$environment" -auto-approve
  if ($LASTEXITCODE -ne 0) { throw "Terraform destroy failed for $name" } 
}


Write-Host -ForegroundColor Yellow "Removing Kubernetes addons..."
terraform -chdir="./k8s" init -backend-config="bucket=$bucketName" -backend-config="key=k8s-$environment.tfstate" -reconfigure
if ($LASTEXITCODE -ne 0) { throw "Terraform init failed for k8s" } 
terraform -chdir="./k8s" destroy -var="environment=$environment" -target="helm_release.metrics_server" -target="helm_release.external_secrets" -auto-approve
if ($LASTEXITCODE -ne 0) { throw "Terraform destroy failed for k8s addons" }

Write-Host -ForegroundColor Yellow "Destroying resources..."
$config = Import-PowerShellDataFile -Path "$PSScriptRoot/config.psd1"
[array]::Reverse($config.Layers)
foreach ($layer in $config.Layers) {
  DestroyLayer $layer.Name
}

Write-Host -ForegroundColor Green "Infrastructure for environment '$environment' has been destroyed."
Write-Host "The S3 bucket may be deleted manually."
