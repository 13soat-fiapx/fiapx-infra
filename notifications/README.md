# Notificações (notifications)

Provisiona o serviço de e-mail e as credenciais SMTP utilizadas pelo serviço de notificações.

> Os recursos Kubernetes (ScaledJob, Kubernetes Secret, ConfigMap) são gerenciados pelo Helm Chart do próprio repositório do serviço notifier.

## Mailpit ([`chart.tf`](./chart.tf))

Instala o chart do Mailpit no namespace `notifications`.

Como não há um serviço de disparo de e-mail na AWS Academy (SES não está disponível), o projeto utiliza [Mailpit](https://mailpit.axllent.org) para simular o envio de mensagens.
A interface web fica acessível via `kubectl port-forward service/mailpit-http -n notifications 8025:80`.

## Credenciais ([`secrets.tf`](./secrets.tf))

Cria um secret no AWS Secrets Manager (`{prefix}-email`) com as credenciais SMTP geradas pelo Terraform:

| Campo | Descrição |
|-------|-----------|
| `userName` | Usuário SMTP gerado aleatoriamente |
| `password` | Senha SMTP gerada aleatoriamente |

O secret é lido pelo serviço notifier via ESO (External Secrets Operator), configurado na camada `k8s`.

## Autenticação KEDA ([`trigger_auth.tf`](./trigger_auth.tf))

Define o `TriggerAuthentication` utilizado pelo KEDA para acessar o SQS com as credenciais da AWS.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states das camadas `shared` e `k8s`.
- [`outputs.tf`](./outputs.tf): expõe variáveis para uso em outras camadas.
- [`providers.tf`](./providers.tf): configura os providers oficiais da AWS e Helm.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
