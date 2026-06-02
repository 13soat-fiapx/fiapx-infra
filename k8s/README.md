# Kubernetes (k8s)

Define o cluster e outros recursos necessários.

## Cluster e nodes ([`cluster.tf`](./cluster.tf))

Define um cluster EKS usando um node group de instâncias `medium`, iniciado com dois nodes.
O cluster utiliza uma sub-rede privada e as permissões disponíveis para AWS Academy.

## Network Load Balancer ([`nlb.tf`](./nlb.tf))

Expõe o cluster para a internet através de uma rota pública, redirecionando chamadas da porta 80 para os nodes.

Em ambientes de não-desenvolvimento (STG ou PROD), o acesso externo fica limitado ao API Gateway.

## Dependências externas ([`addons.tf`](./addons.tf))

Instala via Helm as dependências do projeto no cluster EKS.

- **Metrics Server**: fornece métricas de CPU e memória para o HPA dos serviços.
- **Nginx Ingress Controller**: encaminha as requisições recebidas pelo NLB para os serviços internos do cluster.
- **External Secrets Operator (ESO)**: importa credenciais do Secrets Manager da AWS como secrets do Kubernetes.
- **Kubernetes Reflector**: replica secrets e configMaps entre namespaces.
- **KEDA**: gerencia o ciclo de vida dos ScaledJobs com base no comprimento das filas SQS.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe a rota pública e outras informações do load balancer.
- [`providers.tf`](./providers.tf): configura os providers oficiais da AWS e Helm.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`.
