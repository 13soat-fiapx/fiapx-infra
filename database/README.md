# Banco de dados (database)

Provisiona as tabelas DynamoDB do projeto.

## Tabelas ([`table_videos.tf`](./table_videos.tf))

Define as tabelas e seus índices secundários globais (GSIs).
O nome de cada tabela segue o padrão `fiapx-ENV-NOME-db` (ex: `fiapx-dev-videos-db`).

| Tabela   | GSI            | Chave do GSI |
|----------|----------------|--------------|
| `videos` | `userId-index` | `userId`     |

## Arquivos de configuração

- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe os nomes finais das tabelas criadas.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
