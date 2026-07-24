param ([string]$environment)
. "$PSScriptRoot/get-environment.ps1"
$environment = Get-Environment $environment

# back-end do Terraform
$projectName = "fiapx"
$bucketName = "$projectName-tf-$(aws sts get-access-key-info --access-key-id $(aws configure get aws_access_key_id) --query Account --output text)"
Write-Host -ForegroundColor Yellow "Creating bucket '$bucketName'..."
aws s3 mb s3://$bucketName --region us-east-1 | Out-Null

# subir infraestrutura pelo Terraform
Write-Host
Write-Host -ForegroundColor Yellow "Updating infrastructure for environment '$environment'..."

helm repo update

function InitializeLayer {
  param([Parameter(Mandatory)][string]$name)

  Write-Host
  Write-Host -ForegroundColor Yellow "Processing layer '$name'..."

  terraform -chdir="./$name" init -backend-config="bucket=$bucketName" -backend-config="key=$name-$environment.tfstate" -reconfigure
  if ($LASTEXITCODE -ne 0) { throw "Terraform init failed for $name" } 

  terraform -chdir="./$name" apply -var="environment=$environment" -auto-approve
  if ($LASTEXITCODE -ne 0) { throw "Terraform apply failed for $name" } 
}

$config = Import-PowerShellDataFile -Path "$PSScriptRoot/config.psd1"
foreach ($layer in $config.Layers) {
  InitializeLayer $layer.Name
}

Write-Host
Write-Host -ForegroundColor Yellow "Configuring cluster..."

aws eks update-kubeconfig --name "$projectName-$environment-cluster" --region us-east-1
kubectl create secret generic aws-credentials `
  --namespace external-secrets `
  --from-literal=access-key-id="$(aws configure get aws_access_key_id)" `
  --from-literal=secret-access-key="$(aws configure get aws_secret_access_key)" `
  --from-literal=session-token="$(aws configure get aws_session_token)" `
  --dry-run=client `
  --output yaml `
| kubectl annotate --local -f - `
    "reflector.v1.k8s.emberstack.com/reflection-allowed=true" `
    --overwrite -o yaml `
| kubectl apply -f -
kubectl wait --for=condition=Ready pod --all -n external-secrets --timeout=120s

@"
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: $projectName-aws-secrets
spec:
  provider:
    aws:
      service: SecretsManager
      region: us-east-1
      auth:
        secretRef:
          accessKeyIDSecretRef:
            name: aws-credentials
            namespace: external-secrets
            key: access-key-id
          secretAccessKeySecretRef:
            name: aws-credentials
            namespace: external-secrets
            key: secret-access-key
          sessionTokenSecretRef:
            name: aws-credentials
            namespace: external-secrets
            key: session-token
"@ | kubectl apply -f -

Write-Host
Write-Host -ForegroundColor Green "Infrastructure for environment '$environment' has been applied."
