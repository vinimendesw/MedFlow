# EXP-01: PostgreSQL + MongoDB (MedFlow)

## Objetivo
Testar se documentos clínicos com metadados variáveis (atestado x raio-X) cabem
no MongoDB, ligados a um paciente do PostgreSQL, com leitura conjunta feita
pela aplicação (RF-004).

## Passo a passo (PowerShell, dentro desta pasta)

1. Subir os bancos:
   docker compose up -d

2. Criar a tabela paciente no PostgreSQL (usa o cliente psql dentro do container):
   docker exec -i medflow-exp01-pg psql -U medflow -d medflow < setup-postgres.sql

3. Instalar dependências Node:
   npm install

4. Rodar o script principal (grava no Mongo, lê do Postgres, junta e imprime):
   npm start

## Testes (T1 a T3)

- T1: rodar `npm start`. A saída deve trazer o paciente e os 2 documentos.
  -> Print desta saída.
- T2: adicionar um 3º documento no `documentos_exp01.json` (ex.: receita com
  posologia) sem mudar nenhuma tabela nem o script, e rodar `npm start` de novo.
  -> Mostra que o campo metadados_especificos é flexível.
- T3: parar o Mongo (`docker stop medflow-exp01-mongo`) e rodar `npm start`
  outra vez. Anotar o erro de conexão. Isso evidencia que não há transação
  entre os dois bancos (o Postgres pode gravar e o Mongo falhar, deixando
  documento "órfão").
  Depois: docker start medflow-exp01-mongo

## Evidências (Seção 19.2 da documentação)
Pasta `PRINTS/`:
- `print_docker_compose_ps.png`: contêineres `medflow-exp01-pg` (postgres:16, porta 5433) e `medflow-exp01-mongo` (mongo:7, porta 27017) em execução (`docker compose ps`).
- `print_saida_do_t1.png`: saída do T1 (paciente + 2 documentos).
- `print_saida_T2.png`: saída do T2 (3º documento, receita, sem alterar tabela nem script).
- `print_saida_t3.png`: saída do T3 (erro ECONNREFUSED com o Mongo parado).

## Resultado resumido
- T1: a junção feita na aplicação retornou o paciente (PostgreSQL) e seus 2 documentos (MongoDB).
- T2: o documento de receita, com campos próprios, foi aceito sem mudar tabela nem código.
- T3: sem o Mongo, o script falha com erro de conexão; não há transação entre os dois bancos.

## Observações
- O `documentos_exp01.json` usa uma estrutura aninhada (`referencias_relacionais`, `classificacao`, `arquivo_fisico`, `metadados_especificos`, `dados_extraidos_ia`, `auditoria`). Ela é uma variação experimental; o formato definitivo da coleção será consolidado no backend (ver `docs/arquitetura-persistencia-poliglota.md`).
- O MinIO não faz parte deste experimento (apenas PostgreSQL e MongoDB). O teste de armazenamento de arquivos fica para a próxima etapa.
- As portas 5433 e 27017 são publicadas só na máquina local, para testes.

## Reset completo
docker compose down -v
