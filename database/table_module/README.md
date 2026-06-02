# Banco de dados NoSQL (no-sql)

Sobe uma tabela DynamoDB.

## Banco de dados ([`db.tf`](./db.tf))

Define a tabela e os índices e atributos.\
O nome da tabela seguirá o padrão `fiapx-ENV-NOME-db`.

## Arquivos de configuração do ambiente

Os demais arquivos definem variáveis, outputs e geração de senhas.

- [`data.tf`](./data.tf)
  - Busca states de outras camadas.
- [`outputs.tf`](./outputs.tf)
  - Sempre exibe o ambiente.
- [`vars.tf`](./vars.tf)
  - Define valores utilizados em todo o projeto.
  - `environment`: define o ambiente, que pode ser `dev`, `stg` ou `prod`.
  - `table_name`: nome da tabela no DynamoDB.
- [`providers.tf`](./providers.tf)
  - O projeto utiliza o pacote de AWS oficial da HashiCorp.
