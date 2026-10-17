# Requisitos — MedFlow

Prioridade no modelo MoSCoW: **MUST** (obrigatório) · **SHOULD** (importante) · **COULD** (desejável).

## Requisitos Funcionais (RF)

| ID | Descrição | Prioridade | Status |
|---|---|---|---|
| RF-001 | Cadastro de Usuários (pacientes, médicos, gestores) | MUST | Não Iniciado |
| RF-002 | Consulta de Histórico completo do paciente | MUST | Não Iniciado |
| RF-003 | Gestão de Permissões de Acesso (aprovação / QR Code) | MUST | Não Iniciado |
| RF-004 | Upload e Leitura Inteligente de Exames (OCR) | MUST | Não Iniciado |
| RF-005 | Pesquisa de Pacientes (nome, CPF, etc.) | SHOULD | Não Iniciado |
| RF-006 | Perfil de Paciente | MUST | Não Iniciado |
| RF-007 | Conta de Menores (vínculo com tutores) | MUST | Não Iniciado |
| RF-008 | Tradução e Interpretação de Laudos (IA) | SHOULD | Não Iniciado |
| RF-009 | Notificações Empáticas Push | SHOULD | Não Iniciado |
| RF-010 | Alertas de Cuidado Preditivo (conflito alergia × medicamento) | SHOULD | Não Iniciado |
| RF-011 | Gestão de Contas Vinculadas (tutores) | COULD | Não Iniciado |
| RF-012 | Exportação de Dossiê Médico (PDF) | COULD | Não Iniciado |
| RF-013 | Registro de Histórico Clínico | MUST | Não Iniciado |
| RF-014 | Registro e Consulta de Consultas Médicas | MUST | Não Iniciado |
| RF-015 | Gestão de Comorbidades e Vícios | SHOULD | Não Iniciado |
| RF-016 | Agendamento de Consultas | COULD | Não Iniciado |
| RF-017 | Calendário Vacinal Inteligente | COULD | Não Iniciado |
| RF-018 | Auditoria de Acesso ao Prontuário | MUST | Não Iniciado |
| RF-019 | Sincronização Offline Bidirecional (perfil Paciente) | SHOULD | Não Iniciado |
| RF-020 | Resumo Inteligente Contextualizado por Queixa (IA) | SHOULD | Não Iniciado |
| RF-021 | Termo de Uso e Escopo da Revisão para Profissionais | MUST | Não Iniciado |
| RF-022 | Zero-Cache no Perfil Profissional | MUST | Não Iniciado |

## Requisitos Não Funcionais (RNF)

| ID | Descrição | Prioridade | Status |
|---|---|---|---|
| RNF-001 | Tempo de resposta ≤ 1,5s nas operações principais | MUST | Não Iniciado |
| RNF-002 | Segurança e conformidade com a LGPD | MUST | Não Iniciado |
| RNF-003 | Disponibilidade 24/7 com redundância | SHOULD | Não Iniciado |
| RNF-004 | Acessibilidade móvel (WCAG 2.1 AA) | MUST | Em progresso |
| RNF-005 | Arquitetura escalável em nuvem, banco ACID | MUST | Em progresso |
| RNF-006 | Precisão — validação de campos e rastreabilidade de edições | MUST | Em progresso |
| RNF-007 | Backup periódico com restauração testada | COULD | Em progresso |
| RNF-008 | Testes automatizados — cobertura mínima de 80% | COULD | Em progresso |
| RNF-009 | Tempo de resposta da IA ≤ 3s | SHOULD | Não Iniciado |
| RNF-010 | Interoperabilidade — padrão FHIR (JSON/XML) | COULD | Em progresso |
| RNF-011 | Auditabilidade e rastreabilidade imutável | MUST | Não Iniciado |
| RNF-012 | Autenticação multifator (MFA) e controle de sessão | MUST | Não Iniciado |
| RNF-013 | Privacidade por design | MUST | Não Iniciado |
| RNF-014 | Compatibilidade com dispositivos de entrada (Android 10+/iOS 14+) | SHOULD | Não Iniciado |
| RNF-015 | Modo offline parcial (perfil Paciente) | COULD | Não Iniciado |
| RNF-016 | Disponibilidade e governança do serviço de IA (SLA 99,5%) | MUST | Não Iniciado |
| RNF-017 | Política de retenção e exclusão de dados (20 anos prontuário) | MUST | Não Iniciado |

> Detalhamento completo de cada requisito está no documento de especificação da Fase 1 (`Entregas/Quarto Periodo/Fase 1/MedFlow_Requisitos.docx`), fora deste repositório.
