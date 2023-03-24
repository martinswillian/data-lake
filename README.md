# Datalake

## O que faz?

Os scripts Terraform neste projeto criam os seguintes recursos na AWS:

- Um bucket S3 para armazenamento de dados, com redundância, persistência de 5 anos, e armazenados no Glacier.
- Um banco de dados do AWS Glue Catalog para gerenciamento de metadados.
- Um crawler do AWS Glue para coletar dados do bucket S3 e atualizar o catálogo do AWS Glue.
- Um grupo de trabalho do Amazon Athena para consultas SQL em dados armazenados no S3.

## Como utilizar:

- Certifique-se de que as credenciais para a AWS estejam configuradas no ambiente responsável por executar o código, seja ele local, ou através de alguma ferramenta de CI/CD.
- Edite o arquivo `datalake.tfvars`, e acrescente as informações necessárias, como por exemplo, região, ID da conta, nome do projeto, tipos de instâncias, etc.
- Certifique-se de que o Terraform esteja instalado.
- Clone o projeto, acesse o diretório, e inicie o terraform com o comando `terraform init`.
- Verifique os recursos que serão criados com o comando `terraform plan --var-file=datalake.tfvars`.
- Crie os recursos com o comando `terraform apply --var-file=datalake.tfvars`, e confirme com `yes`.
- Para destruir o ambiente, execute `terraform destroy --var-file=datalake.tfvars`.

## Criando os recursos utilizando o Jenkins:

- Certifique-se de que o Jenkins e/ou os executores de build do Jenkins possuam acesso a AWS, com as permissões necessárias para criar recursos utlizando o Terraform.
- Crie um job do tipo "Pipeline".
- Em Pipeline, escolha a opção "Pipeline script from SCM", informe o endereço e branch do repositório desejado.
- Em "Script Path", informe o caminho do Jenkinsfile, "ci/Jenkinsfile".
