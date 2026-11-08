# O que mudou de MySQL (sql.txt) para PostgreSQL + Prisma

| # | MySQL (sql.txt) | PostgreSQL / Prisma |
|---|---|---|
| 1 | `INT AUTO_INCREMENT` | `@default(autoincrement())` (vira `SERIAL`) |
| 2 | `BIGINT AUTO_INCREMENT` | `BigInt @default(autoincrement())` (vira `BIGSERIAL`) |
| 3 | `ENUM('A','B')` inline na coluna | tipo próprio: `CREATE TYPE ... AS ENUM` (`enum` no Prisma, 15 tipos) |
| 4 | `TIMESTAMP ... ON UPDATE CURRENT_TIMESTAMP` | não existe no PostgreSQL; usa `@updatedAt` do Prisma |
| 5 | `TIMESTAMP` | `TIMESTAMP(3)` |
| 6 | `BOOLEAN` | `BOOLEAN` (igual) |
| 7 | `FOREIGN KEY` dentro do `CREATE TABLE` | relações declaradas com `@relation` |
| 8 | `ON DELETE CASCADE` (26x) e `SET NULL` (4x) | `onDelete: Restrict` em todas |
| 9 | `crm UNIQUE` + `uf_crm UNIQUE` | `@@unique([crm, uf_crm])` |
| 10 | tabelas em snake_case | mantido (nomes de model iguais às tabelas) |

## Limitação encontrada
`@updatedAt` é aplicado pelo Prisma Client (na aplicação), não pelo banco. UPDATE feito
por SQL puro não atualiza `data_atualizacao`. Se isso importar (RNF-006/RNF-011),
é preciso um trigger no PostgreSQL.

## Inconsistências do sql.txt e decisões (Fase 3)
1. A tabela `documento` não existe no sql.txt (26 tabelas sem ela). Decisão: manter as 26 tabelas do DDL;
   `documento` fica descrita na Seção 18.3 como tabela-ponte prevista.
2. `log_auditoria.operacao` não tinha LEITURA, mas o RF-018 exige registrar leituras. Corrigido: valor `LEITURA` incluído.
3. `log_inferencia_ia.tipo_inferencia` tinha `DIAGNOSTICO`, que conflita com a RN-009. Corrigido: valor removido.
4. `permissao_acesso.status` tinha `EXPIRADO`, mas a RN-014 define duração indefinida (só termina por revogação do
   paciente). Corrigido: valor removido; restam `ATIVO` e `REVOGADO`.
