# EXP-02: Prisma + PostgreSQL (MedFlow)

## Rodar (PowerShell, dentro da pasta)
1. `docker compose up -d`
2. `npm install`
3. `npx prisma migrate dev --name init`   (cria as 26 tabelas e 15 enums)
4. `npx prisma db seed`                   (dados de teste + prova do UNIQUE(crm, uf_crm))
5. `npm run conflito`                     (consulta alergia x medicamento, 3 casos)

## Prints para a evidência
- migrate dev terminando sem erro
- saída do `db seed` (mensagens OK)
- saída do `npm run conflito`
- (opcional) `npx prisma studio` mostrando as tabelas

## Refazer do zero
`npx prisma migrate reset`
