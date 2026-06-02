# Notificações (notifications)

Provisiona o serviço de e-mail, as credenciais e o ScaledJob responsável pelo envio de notificações.

## Mailpit ([`chart.tf`](./chart.tf))

Instala o chart do Mailpit no namespace `notifications`.

Como não há um serviço de disparo de e-mail na AWS Academy (SES não está disponível), o projeto utiliza [Mailpit](https://mailpit.axllent.org) para simular o envio de mensagens.
É executado utilizando um script Helm, com usuário e senha gerados pelo Terraform e armazenados em uma secret no EKS.

A interface web fica acessível via `kubectl port-forward service/mailpit-http -n notifications 8025:80`.

## Credenciais ([`secrets.tf`](./secrets.tf))

Cria um secret Kubernetes com as credenciais de acesso ao Mailpit.
O secret é consumido diretamente pelo ScaledJob, sem passar pelo Secrets Manager ou ESO.

## ScaledJob ([`job.tf`](./job.tf))

Define um ScaledJob do KEDA vinculado à fila `fiapx-{env}-video-status-changed`.
Para cada mensagem na fila, o KEDA instancia um Job com a imagem `fiapx-notifier:latest`, que processa a notificação e encerra.

## Autenticação KEDA ([`trigger_auth.tf`](./trigger_auth.tf))

Define o `TriggerAuthentication` utilizado pelo KEDA para acessar o SQS com as credenciais da AWS.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states das camadas `shared`, `k8s`, `cr` e `messaging`.
- [`outputs.tf`](./outputs.tf): expõe variáveis para uso em outras camadas.
- [`providers.tf`](./providers.tf): configura os providers oficiais da AWS, Helm e Kubernetes.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
