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

## Evidências para a 19.2
- Print da saída do T1 (psql + npm start)
- Print do mongosh ou MongoDB Compass mostrando os 2 documentos
- Trecho de código: a função main() de junta-paciente-documentos.js
- Commit no GitHub, link na Seção 4

## Reset completo
docker compose down -v
