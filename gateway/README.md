# API Gateway (gateway)

Expõe os endpoints da aplicação e controla o acesso via autenticação JWT.

## Tipos de rotas

As rotas podem ser públicas ou autenticadas.

Nas rotas públicas, o gateway encaminha a requisição para o cluster EKS sem validar o token JWT. Utilizado em endpoints acessíveis sem autenticação, como o cadastro de usuários via Auth0.

Nas rotas autenticadas, o token JWT é validado pelo autorizador nativo antes de encaminhar a requisição.
Se o header `Authorization` estiver ausente, o gateway retorna **HTTP 401** automaticamente.
Se o token for inválido ou estiver expirado, o gateway retorna **HTTP 403**.

## Gateway ([`gateway.tf`](./gateway.tf))

Cria o gateway e configura logs de chamadas realizadas e resultados de autenticação.

## Arquivos de rotas

- [`routes-cluster.tf`](./routes-cluster.tf): encaminhamento de requisições para o cluster Kubernetes.
- [`routes-swagger.tf`](./routes-swagger.tf): acesso ao Swagger UI (somente em ambientes não-`prod`).

Rotas disponíveis:

- `ANY /{service}/{proxy+}`: rota coringa para encaminhar requisições ao cluster.
- `ANY /{service}/swagger/{proxy+}`: acesso ao Swagger da aplicação.

## Controle de acesso ([`authorizer.tf`](./authorizer.tf))

Configura um autorizador JWT nativo do API Gateway apontando para o endpoint JWKS do Auth0.
Nenhuma Lambda Function é necessária para validação de tokens.

O domínio e o audience do Auth0 são configurados via `vars.tf`.

## Arquivos de configuração

- [`backend.tf`](./backend.tf): referencia o Bucket S3 para persistência dos states.
- [`data.tf`](./data.tf): busca states de outras camadas.
- [`outputs.tf`](./outputs.tf): expõe a URL pública do gateway.
- [`providers.tf`](./providers.tf): configura o provider oficial da AWS.
- [`vars.tf`](./vars.tf): define valores utilizados na camada.
  - `environment` pode ser `dev`, `stg` ou `prod`.
  - `auth_domain` e `auth_audience` configuram o autorizador JWT.
