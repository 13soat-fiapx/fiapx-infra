# Container Registry (cr)

Provisiona os repositórios ECR do projeto.

## Repositórios ([`cr.tf`](./cr.tf))

Cria um repositório ECR para cada serviço listado na variável `service_names`.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe a URL e o nome de cada repositório criado.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`. `service_names` lista os serviços para os quais os repositórios serão criados.
