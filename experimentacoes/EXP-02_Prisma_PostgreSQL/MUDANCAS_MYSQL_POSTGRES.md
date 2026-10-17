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

## Outras inconsistências achadas no sql.txt
1. A tabela `documento` não existe no sql.txt (26 tabelas sem ela), mas a Seção 18.3
   a descreve como tabela-ponte para o MongoDB, e a lista de domínios da 18.1 soma 27.
2. `log_auditoria.operacao` não tem valor de LEITURA, mas o RF-018 exige registrar leituras.
3. `log_inferencia_ia.tipo_inferencia` tem `DIAGNOSTICO`, que conflita com a RN-009
   (a IA é proibida de emitir diagnósticos).
4. `permissao_acesso.status` tem `EXPIRADO`, mas a RN-014 atual diz que a permissão
   tem duração indefinida.
