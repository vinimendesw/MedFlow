# Arquitetura de Persistência Poliglota — MedFlow

## Resumo da decisão

O MedFlow adota **persistência poliglota**: cada tecnologia resolve um problema específico do domínio, em vez de forçar tudo em um único banco.

- **PostgreSQL** continua gerenciando o núcleo relacional do sistema, garantindo integridade e relacionamentos de entidades essenciais como `usuario`, `consulta`, `medicamento` e `log_auditoria`.
- A tabela `documento`, que no modelo SQL original tinha colunas rígidas (`tamanho_bytes`, `mime_type`, `hash`) e muitas chaves estrangeiras, teve sua responsabilidade transferida para o **MongoDB**.

Bancos NoSQL são ideais para essa função porque documentos médicos (laudos de raio-X, exames de sangue, atestados) têm metadados muito variados entre si. O MongoDB permite guardar essas informações em formato flexível, eliminando a necessidade de tabelas auxiliares complexas ou colunas vazias no banco relacional.

## Integração no backend

PostgreSQL e MongoDB não conversam entre si de forma autônoma — não existe `JOIN` entre bancos diferentes. O **backend é o orquestrador** dessa integração.

Fluxo de upload de um laudo, por exemplo:

1. O backend salva o arquivo físico em um serviço de armazenamento (MinIO / S3).
2. Insere os metadados flexíveis no MongoDB, contendo as referências aos IDs do PostgreSQL.
3. Atualiza o status da consulta no banco relacional, quando aplicável.

Na leitura, a API busca os dados estruturados do paciente no PostgreSQL e faz uma consulta separada no MongoDB para trazer os documentos associados — a "junção" acontece na camada de aplicação, não no banco.

> Essa junção na aplicação (sem transação entre os dois bancos) foi validada no experimento **EXP-01**, em `experimentacoes/EXP-01_PostgreSQL_MongoDB/`.

## Conteinerização (Docker)

Para orquestrar múltiplos bancos, a conteinerização é essencial:

- Docker cria uma rede interna privada onde a API, o PostgreSQL e o MongoDB se comunicam de forma isolada, sem expor portas diretamente para a internet.
- Padroniza o ambiente entre os integrantes da equipe — qualquer desenvolvedor sobe a infraestrutura completa com um único comando (`docker compose up`).
- Permite escalar os serviços de banco de forma independente conforme a demanda cresce.
