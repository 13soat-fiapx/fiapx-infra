# Exemplo (example)

Camada de referência para criação de novas camadas.

## Recurso ([`recurso.tf`](./recurso.tf))

Exemplo de recurso a ser provisionado.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe variáveis para uso em outras camadas.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
