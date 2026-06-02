# Scripts para deploy

1. Certifique-se de ter instalado as ferramentas necessárias:
   - AWS CLI
   - Helm
   - Terraform
2. Configure suas credenciais na AWS:
   - Usando AWS CLI: `aws configure`; ou,
   - Colando no arquivo de configuração (se já existir): `notepad $ENV:USERPROFILE\.aws\credentials`;
3. Utilize o script `initialize-infrastructure.ps1` para subir o ambiente na AWS.
4. Utilize o script `remove-environment.ps1` para destruir o ambiente.
   - Para evitar conflitos, o bucket S3 com os states do Terraform não é apagado.

O comando abaixo sobe a infraestrutura no ambiente DEV.
Execute na raiz do projeto.

```powershell
.\scripts\initialize-infrastructure.ps1 dev
```

Para alternar entre ambientes, use o script `set-environment.ps1`.

Para aplicar os scripts de uma única camada, utilize `.\scripts\initialize-layer.ps1 NOME_DA_CAMADA`.
Os scripts são idempotentes, isto é, podem ser executados múltiplas vezes.

## SonarQube (bootstrap de projetos)

O bootstrap de projetos via API (catálogo `projectKey` por repositório) fica no repositório dedicado `mechanics-sonar-plataform`.

Use o script `scripts/bootstrap-sonarqube-projects.ps1` do repositório `mechanics-sonar-plataform` com os parâmetros:

- `-sonarHostUrl`
- `-sonarToken`
- `-qualityGateName` (opcional)

## Permissão de execução de scripts

No Windows, a execução de scripts do Powershell vem desabilitada por padrão.

Para habilitar, abra um terminal como administrador e utilize o comando [Set-ExecutionPolicy](https://learn.microsoft.com/pt-br/powershell/module/microsoft.powershell.security/set-executionpolicy):

```powershell
Set-ExecutionPolicy Unrestricted
```

