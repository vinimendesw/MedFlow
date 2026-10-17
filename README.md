<p align="center">
  <img src="docs/logo-medflow.png" alt="MedFlow" width="140">
</p>

<h1 align="center">🩺 MedFlow</h1>
<p align="center"><strong>Saúde conectada, acessível e eficiente.</strong></p>

<p align="center">
  Plataforma digital para unificar o histórico de saúde de pacientes entre rede pública e privada.
</p>

---

## 📌 Problema que resolvemos

Hoje, informações de saúde estão espalhadas por diferentes sistemas, clínicas e hospitais, dificultando o acesso rápido e completo ao histórico do paciente. Isso causa:

- **Falta de acesso rápido a dados críticos** em emergências.
- **Retrabalho e repetição de exames**, elevando custos.
- **Dificuldade na continuidade de tratamento** entre diferentes profissionais.
- **Risco à saúde** devido à desorganização ou perda de documentos físicos.

O MedFlow surge como resposta a essa realidade, promovendo um **ecossistema de saúde integrado e inteligente**.

## 🧑‍⚕️ Público-alvo

- **Pacientes**, especialmente idosos, crianças e pessoas com doenças crônicas.
- **Profissionais de saúde**, como médicos, enfermeiros e terapeutas.
- **Instituições de saúde**, como clínicas, laboratórios e hospitais.
- **Planos de saúde e seguradoras**, para reduzir burocracias e custos operacionais.

## 💡 Nossa solução

Uma plataforma **web e mobile** de acesso rápido, seguro e completo ao histórico de saúde do paciente, com integração ao **SUS**, laboratórios particulares parceiros e planos de saúde/clínicas privadas.

### Funcionalidades principais

- 📄 **Cadastro detalhado do histórico de saúde** — tipo sanguíneo, comorbidades, vícios, doenças hereditárias, cirurgias, etc.
- 🧪 **Histórico completo de exames** — públicos e privados, com dados do médico solicitante e local de realização.
- 💉 **Carteira vacinal digital** — histórico completo (SUS e privado), calendário atualizado e agendamento.
- 💊 **Controle de medicamentos** — atual e histórico, pelo SUS ou particular.
- ⚠️ **Registro de alergias** — lista pré-definida e campo aberto para personalização.
- 📆 **Agenda de consultas** — visualização e marcação de consultas médicas.
- ⛔ **Controle de substâncias** — temporizador de abstinência e apoio a tratamentos de desmame.
- 🔒 **Acesso autorizado e controlado** — compartilhamento de dados com profissionais apenas com consentimento do paciente.

Lista completa de requisitos funcionais e não funcionais em [`docs/requisitos.md`](docs/requisitos.md).

## 🏗️ Arquitetura e stack técnica

Persistência poliglota: cada tecnologia resolve um problema específico do domínio.

| Camada | Tecnologia | Por quê |
|---|---|---|
| Dados relacionais (pacientes, consultas, permissões) | **PostgreSQL + Prisma ORM** | ACID, enums nativos, migrations versionadas a partir de um schema já com 3 refatorações documentadas |
| Documentos clínicos (laudos, exames, metadados variáveis) | **MongoDB** | Schema flexível — cada tipo de documento tem campos diferentes (atestado × raio-X × receita) |
| Arquivos e imagens | **MinIO** (S3-compatible, self-hosted) | Equivalente open-source a um bucket cloud, roda local sem custo |
| Ambiente de desenvolvimento | **Docker** | Padroniza o ambiente entre os integrantes do grupo |
| App mobile | **Expo / React Native** | Protótipo de telas testável em dispositivo real via Expo Go |
| Testes unitários | **Jest** | Regras de negócio (ex.: conflito alergia × medicamento) |

Justificativa completa em [`docs/solucao-tecnologica.md`](docs/solucao-tecnologica.md) e a decisão de persistência poliglota (Postgres + Mongo) em [`docs/arquitetura-persistencia-poliglota.md`](docs/arquitetura-persistencia-poliglota.md).

## 📂 Estrutura do repositório

```
Medflow/
├── docs/                              → modelo lógico, requisitos, decisões técnicas
├── backend/                           → API real (ainda não iniciado)
├── mobile/                            → app real (ainda não iniciado)
└── experimentacoes/                   → validações técnicas (4º período)
    ├── EXP-01_PostgreSQL_MongoDB/     → junção paciente (Postgres) + documentos (Mongo)
    ├── EXP-02_Prisma_PostgreSQL/      → migrations Prisma + consulta de conflito alergia×medicamento
    ├── EXP-03_App_Expo/               → tela de login do protótipo
    └── EXP-04_Jest_Alergia/           → testes automatizados da regra de alergia
```

Cada pasta de `experimentacoes/` tem seu próprio `LEIA-ME.md` com passo a passo para rodar o experimento.

## 📚 Documentação

- [`docs/requisitos.md`](docs/requisitos.md) — 22 requisitos funcionais e 17 não funcionais, com prioridade e status
- [`docs/modelo-logico-medflow.png`](docs/modelo-logico-medflow.png) — diagrama do modelo lógico (26 tabelas)
- [`docs/modelo-logico-medflow.dbml`](docs/modelo-logico-medflow.dbml) — mesmo modelo em formato [dbdiagram.io](https://dbdiagram.io)
- [`docs/schema-postgresql-referencia.sql`](docs/schema-postgresql-referencia.sql) — schema original (nota: ainda em sintaxe MySQL; a versão corrigida para PostgreSQL está em `experimentacoes/EXP-01` e `EXP-02`)
- [`docs/solucao-tecnologica.md`](docs/solucao-tecnologica.md) — justificativa de cada escolha tecnológica
- [`docs/arquitetura-persistencia-poliglota.md`](docs/arquitetura-persistencia-poliglota.md) — como PostgreSQL e MongoDB se integram no backend

## 👥 Equipe

| Integrante | Papel |
|---|---|
| Vinicius | PO e Back-End |
| Renato | Back-End |
| Gabrielly | Tester |
| Arthur | Front-End e UI/UX |

---

Projeto Integrador — UniEvangélica
