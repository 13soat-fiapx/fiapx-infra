# Mensageria (messaging)

Cria as filas SQS e suas Dead Letter Queues (DLQ).

## Filas SQS ([`queues.tf`](./queues.tf))

Gera uma fila principal e uma DLQ para cada nome informado na variável `queue_names`.

As filas seguem a nomenclatura `fiapx-{environment}-{name}` e as DLQs `fiapx-{environment}-{name}-dlq`.
Nomes das filas devem referenciar eventos de domínio no formato `{aggregate}-{event}`, como `user-created` ou `order-completed`.

### Configuração padrão

A DLQ retém mensagens por 14 dias para permitir reprocessamento manual ou investigação.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe variáveis para uso em outras camadas.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada.
  - `environment` pode ser `dev`, `stg` ou `prod`.
  - `queue_names`: lista de filas a serem criadas.
