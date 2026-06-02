# Armazenamento de artefatos (storage)

Aramzena os arquivos Zip produzidos pela aplicação.

## Artifacts ([`artifacts.tf`](./artifacts.tf))

Bucket S3 para armazenar os artefatos produzidos no processamento.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe o nome do bucket criado.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
