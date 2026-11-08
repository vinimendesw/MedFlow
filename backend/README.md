# Backend — MedFlow

Código da API real do projeto (ainda não iniciado).

**Stack planejada** (ver [`docs/solucao-tecnologica.md`](../docs/solucao-tecnologica.md)):
- PostgreSQL + Prisma ORM — dados relacionais
- MongoDB — documentos clínicos (laudos, exames)
- MinIO — armazenamento de arquivos

Base do schema: `experimentacoes/EXP-02_Prisma_PostgreSQL/prisma/schema.prisma` (26 tabelas, 15 enums, validado na EXP-02). Pendências para a implementação: integrar o Prisma ao NestJS, incluir o MinIO no Docker Compose, tratar falhas parciais entre PostgreSQL e MongoDB e avaliar triggers para `data_atualizacao` e para o log append-only.

Validações técnicas já feitas em [`experimentacoes/`](../experimentacoes/) (EXP-01 e EXP-02).
