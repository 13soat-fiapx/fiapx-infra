# Infraestrutura

A infraestrutura do projeto é definida em scripts [Terraform](https://developer.hashicorp.com/terraform).
Os arquivos foram separados por camadas (pastas), com cada camada sendo responsável por um conjunto de recursos relacionados.

A implementação pode ser replicada para mais de um ambiente (desenvolvimento, homologação e produção), com recursos e credenciais totalmente isolados.

Este repositório é uma ramificação do [mechanics-infra](https://github.com/FIAP-POS-TECH-13SOAT-MECHANICS/mechanics-infra), adaptado para o projeto FIAP X.

## Camadas do projeto

O sistema possui as seguintes camadas:

- [shared](./shared/README.md): recursos compartilhados, como configurações de rede e variáveis comuns.
- [database](./database/README.md): tabela DynamoDB para persistência dos dados de processamento.
- [cr](./cr/README.md): repositórios ECR para as imagens dos serviços.
- [storage](./storage/README.md): bucket S3 para armazenamento dos arquivos `.zip` gerados.
- [messaging](./messaging/README.md): filas SQS para comunicação assíncrona entre os serviços.
- [k8s](./k8s/README.md): cluster Kubernetes, KEDA e load balancer.
- [notifications](./notifications/README.md): serviço de e-mail, ScaledJob KEDA vinculado à fila de notificações e credenciais.
- [gateway](./gateway/README.md): API Gateway com autorizador JWT e rotas para os serviços.

Cada camada possui o próprio README com a definição dos recursos criados.

## Execução local

Configure as credenciais da AWS e execute o script de inicialização:

```powershell
aws configure
./scripts/initialize-infrastructure.ps1 dev
```

Após o ambiente inicializar, faça o deploy dos serviços seguindo as instruções de cada repositório:

- [fiapx-api](https://github.com/13soat-fiapx/fiapx-api)
- [fiapx-notifier](https://github.com/13soat-fiapx/fiapx-notifier)
- [fiapx-processor](https://github.com/13soat-fiapx/fiapx-processor)

## Instalação das ferramentas

Instale o [Terraform](https://developer.hashicorp.com/terraform/install) e o [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
No Windows, é possível instalar via [WinGet](https://learn.microsoft.com/pt-br/windows/package-manager/winget/):

```cmd
winget install --id Hashicorp.Terraform
winget install --id Amazon.AWSCLI
```

Reinicie o terminal após a instalação para atualizar a variável PATH.

### Configuração do AWS CLI

Acesse a [página de cursos na AWS Academy](https://awsacademy.instructure.com/courses),
inicie o laboratório e clique em "AWS Details" para copiar as credenciais de acesso.

```powershell
aws configure
```

As credenciais expiram periodicamente. Atualize os secrets do repositório sempre que reiniciar o laboratório para que a pipeline continue funcionando.

## Pipeline de CI/CD

Ao fazer alterações nas branches `main`, `release` ou `develop`, a pipeline de CI/CD é disparada automaticamente.

A pipeline executa os seguintes passos:

1. Identifica o ambiente a partir da branch:
   - `main` => `prod`
   - `release` => `stg`
   - `develop` => `dev`
2. Aplica as camadas Terraform na ordem definida em `config.psd1`.

### Reuso de testes com SonarQube

O workflow reutilizável de testes suporta análise SonarQube opcional para os repositórios de serviços.

Documentação: [fiapx-docs](https://github.com/13soat-fiapx/fiapx-docs).

## Comandos úteis

Buscar a URL de um repositório ECR:

```powershell
$repositoryUrl = aws ecr describe-repositories --repository-names fiapx-dev/api --query "repositories[0].repositoryUri" --output text
```

Remover secrets da AWS:

```powershell
aws secretsmanager delete-secret --secret-id fiapx-dev-email --force-delete-without-recovery

# Remover todos os secrets do ambiente
aws secretsmanager list-secrets --query "SecretList[].Name" | ConvertFrom-Json | ForEach-Object { aws secretsmanager delete-secret --secret-id $_ --force-delete-without-recovery }
```

Forçar sincronização de uma secret:

```powershell
kubectl annotate externalsecret fiapx-email force-sync="$(New-Guid)" --overwrite
```

Liberar lock travado no Terraform:

```powershell
# Copie o lock-id da mensagem de erro
terraform force-unlock LOCK_ID
```

Excluir imagens do ECR antes de destruir a infraestrutura:

```powershell
aws ecr batch-delete-image `
  --repository-name fiapx-dev/api `
  --image-ids (aws ecr list-images --repository-name fiapx-dev/api --query "imageIds[].imageDigest" --no-paginate | ConvertFrom-Json | ForEach-Object { "imageDigest=$_" })
```
