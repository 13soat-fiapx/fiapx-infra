# Recursos compartilhados (shared)

Configura o backend (usando Bucket S3), cria os recursos de rede e declara as variáveis compartilhadas.

## Back-end ([`backend.tf`](./backend.tf))

Armazena os states do Terraform utilizando S3.
Cada ambiente - dev, stg ou prod - possui seu próprio arquivo de state no bucket S3, que é versionado e criptografado.

O nome do bucket deve ser único na região `us-east-1` e deve ser passado por parâmetro.
Utilize o prefixo `fiapx-tf-` e o ID da conta AWS.
O script configura controle de concorrência (state locking) para permitir a execução segura dos scripts em pipelines de CI/CD.

## Configuração de rede ([`network.tf`](./network.tf))

Define a estrutura de rede para o ambiente.
Cada ambiente roda na sua própria VPC, nomeada seguindo o padrão `fiapx-ENV-vpc`.

Alguns recursos requerem pelo menos duas zonas de disponibilidade, sendo criadas duas sub-redes públicas e duas privadas.
Uma sub-rede pública possui um internet gateway associado, com as rotas devidamente configuradas, tornando-a acessível a partir da internet.

Para as sub-redes privadas, é utilizado um NAT Gateway para que os recursos internos possam acessar a internet - por exemplo, para baixar imagens do ECR - sem ficarem expostos a conexões externas.

## Arquivos de configuração

- [`data.tf`](./data.tf): busca as informações do Bucket S3 para configuração do backend.
- [`outputs.tf`](./outputs.tf): expõe variáveis de uso comum e configurações de rede para as demais camadas.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados em todo o projeto. `environment` pode ser `dev`, `stg` ou `prod`.
