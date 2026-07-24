# Observabilidade (observability)

Integra o cluster EKS com o [Datadog](https://www.datadoghq.com) para telemetria de **infraestrutura** (nodes, pods, Kubernetes Overview).

> Esta camada **não** trata telemetria de aplicação: logs, métricas e traces dos serviços vão direto para o Datadog via OTLP, sem passar pelo Agent. Por isso o Agent é instalado enxuto, com logs, APM e process collection desligados.

Todos os recursos são condicionais à presença da API key do Datadog (`datadog_api_key`). Sem a key, o apply conclui limpo criando **zero recursos** — a observabilidade de cluster fica desligada.

## Namespace e secret ([`namespace.tf`](./namespace.tf))

Cria o namespace `observability` com a secret `datadog-api-key` (chave `api-key`), anotada para espelhamento pelo [Reflector](https://github.com/emberstack/kubernetes-reflector):

- `reflector.v1.k8s.emberstack.com/reflection-allowed: "true"`
- Sem lista de namespaces permitidos: qualquer namespace pode espelhar a secret.

Este é o contrato com os Helm Charts dos serviços: os charts consumidores espelham a secret `observability/datadog-api-key` via annotation `reflects` e leem a key no campo `api-key`.

## Datadog Agent ([`chart.tf`](./chart.tf))

Instala o chart oficial [`datadog/datadog`](https://github.com/DataDog/helm-charts/tree/main/charts/datadog) no namespace `observability`, apontando para o site `us5.datadoghq.com` e lendo a API key da secret `datadog-api-key`. Configuração enxuta:

| Valor | Configuração | Motivo |
| ----- | ------------ | ------ |
| `datadog.kubeStateMetricsCore.enabled` | `true` | Métricas de estado do cluster (Kubernetes Overview) |
| `datadog.logs.enabled` | `false` | Logs das aplicações vão direto via OTLP; evita duplicação |
| `datadog.apm.portEnabled` | `false` | Traces das aplicações vão direto via OTLP |
| `datadog.processAgent.processCollection` | `false` | Coleta de processos não é necessária |

## API key

A key fica em: Datadog / **Organization Settings** / **API Keys**.

### Execução local

Copie o [`terraform.tfvars.example`](./terraform.tfvars.example) para `terraform.tfvars` (ignorado pelo git) e informe a key:

```hcl
datadog_api_key = "<datadog-api-key>"
```

O Terraform carrega o `terraform.tfvars` automaticamente — os scripts em [`scripts`](../scripts) não precisam de parâmetro adicional. Sem o arquivo, o apply roda com o default vazio e nenhum recurso é criado.

### Pipeline

A pipeline exige o secret `DD_API_KEY` no repositório: um step anterior ao apply gera o `terraform.tfvars` da camada a partir dele. Sem o secret configurado, o valor fica vazio e a camada não cria recursos.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca o state da camada `k8s` e os dados de autenticação do cluster.
- [`providers.tf`](./providers.tf): configura os providers oficiais da AWS, Kubernetes e Helm.
- [`vars.tf`](./vars.tf): define valores utilizados na camada. `environment` pode ser `dev`, `stg` ou `prod`; `datadog_api_key` é sensível e opcional; `datadog_site` define o site do Datadog (padrão `us5.datadoghq.com`).
