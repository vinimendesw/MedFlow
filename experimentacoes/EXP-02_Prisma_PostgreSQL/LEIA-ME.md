# EXP-02: Prisma + PostgreSQL (MedFlow)

## Rodar (PowerShell, dentro da pasta)
1. `docker compose up -d`
2. `npm install`
3. `npx prisma migrate dev --name init`   (cria as 26 tabelas e 15 enums)
4. `npx prisma db seed`                   (dados de teste + prova do UNIQUE(crm, uf_crm))
5. `npm run conflito`                     (consulta alergia x medicamento, 3 casos)

## Antes de rodar
Copie `.env.example` para `.env` e ajuste o DATABASE_URL (a senha local de teste é a do
`docker-compose.yml`: usuário `medflow`, senha `medflow123`, banco `medflow`).
Nunca suba o `.env` no GitHub.

## Evidências (Seção 19.2 da documentação)
Pasta `PRINTS/`:
- `print_dt_tabelas.png`: `\dt` no psql, com as 26 tabelas do modelo e a tabela interna `_prisma_migrations`.
- `print_seed_crm.png`: saída do seed, com o mesmo CRM aceito em GO e SP e rejeitado na mesma UF (erro P2002).
- `print_conflito.png`: saída de `npm run conflito` (Amoxil e Clavulin com conflito; Tylenol sem conflito).

## Resultado resumido
- 26 tabelas e 15 enums criados em PostgreSQL 16 via Prisma 6.
- `UNIQUE(crm, uf_crm)` validado; chaves estrangeiras com `onDelete: Restrict`.
- Conflito alergia × medicamento (RF-010, RN-011) detectado também em medicamento composto, via tabela `substancia`.

## Ajustes do modelo na Fase 3
- `permissao_acesso.status`: apenas `ATIVO` e `REVOGADO` (a permissão só termina por revogação do paciente, RN-014).
- `operacao` (log_auditoria): incluído o valor `LEITURA` (RF-018).
- `tipo_inferencia` (log_inferencia_ia): removido `DIAGNOSTICO` (RN-009).
- Se você já criou o banco antes desses ajustes, rode `npx prisma migrate reset`.

## Limitações conhecidas
- `@updatedAt` é aplicado pelo Prisma Client; UPDATE por SQL puro não atualiza `data_atualizacao` (pode exigir trigger).
- O Prisma não garante `log_auditoria` append-only (exigiria trigger ou permissões no banco).
- Não testados: interação entre medicamentos e comorbidades (RN-015) e desempenho (RNF-001).
- NestJS não usado neste experimento (Node puro).

## Refazer do zero
`npx prisma migrate reset`
