19 SOLUÇÃO TECNOLÓGICA

A solução tecnológica do MedFlow foi definida a partir de três eixos que emergiram tanto dos requisitos formais (RF/RNF/RN) quanto da validação qualitativa com especialistas: (1) a necessidade de rodar em dispositivos de baixo custo, comuns ao público idoso (RNF-014); (2) a exigência de segurança, auditabilidade e conformidade com a LGPD e a Resolução CFM 1.821/2007, reforçada pela entrevista jurídica com o Dr. Yan Silva Carneiro; e (3) a necessidade de consistência transacional para dados clínicos sensíveis, já refletida na decisão de usar um banco relacional normalizado em 3FN (Seção 18).

A arquitetura proposta segue o modelo cliente-servidor com API REST, dividida em três camadas: um aplicativo mobile mobile-first (cliente), uma API backend responsável pelas regras de negócio e pela orquestração da IA, e uma camada de persistência híbrida (banco relacional + armazenamento de objetos), já prevista na Seção 18.2. Essa separação permite que o time de 4 integrantes trabalhe em paralelo — dois desenvolvedores back-end, um front-end/UI-UX e uma tester — sem acoplamento excessivo entre as camadas, e é compatível com o cronograma de sprints de 4 semanas adotado pela equipe (Seção 17.1).

A escolha das tecnologias priorizou três critérios, nessa ordem: (a) aderência direta a um requisito já formalizado (RF/RNF/RN); (b) maturidade e documentação suficientes para uma equipe de 4º período sem experiência prévia em produção; (c) compatibilidade com o ecossistema JavaScript/TypeScript já validado no protótipo web (HTML/CSS/JS, v2.2), reduzindo a curva de aprendizado e reaproveitando conhecimento acumulado pela equipe.

19.1 Escolhas Tecnológicas

Frontend Mobile — React Native (com Expo)
Escolhido por ser cross-platform (Android/iOS a partir de uma única base de código), o que é essencial dado o RNF-014 (compatibilidade com Android 10+/iOS 14+ e 2GB de RAM) — o Expo permite builds leves e testes rápidos em dispositivos reais de baixo desempenho. Também oferece suporte nativo a leitores de tela (TalkBack/VoiceOver), atendendo diretamente ao RNF-004 (WCAG 2.1 AA), prioridade elevada pela Dra. Amanda como “pilar inegociável” na pergunta 14 da entrevista. Por fim, o React Native reaproveita a familiaridade da equipe com JavaScript, já demonstrada na primeira versão web do sistema.

Backend/API — Node.js com NestJS (TypeScript)
O NestJS foi escolhido por impor uma arquitetura modular baseada em domínios, o que se alinha diretamente à organização em 6 domínios funcionais já definida no Modelo Lógico (Identidade e Acesso, Catálogos Clínicos, Vínculos Paciente-Clínicos, Atendimento, Permissões e Termos, Auditoria e IA). O uso de TypeScript reduz erros de tipagem em um domínio onde falhas podem ter consequência clínica e jurídica direta (RNF-006 — Precisão), e facilita a validação de contratos de API entre back-end e o app mobile.

Banco de Dados — PostgreSQL + Prisma ORM
PostgreSQL é a escolha natural para sustentar o Modelo Lógico já construído (26 tabelas, 3FN, soft delete, chaves estrangeiras): é um SGBD relacional com garantias ACID (RNF-005), suporte nativo a tipos enumerados (usados nos 13 enums do modelo) e extensões maduras para criptografia em repouso (RNF-002). O Prisma foi adotado como ORM por gerar migrations versionadas a partir do schema — importante porque o modelo já passou por três refatorações documentadas (v3.0 a v3.2) — e por facilitar a implementação padronizada de soft delete e timestamps de auditoria em todas as tabelas operacionais.

Armazenamento de Objetos — MinIO (S3-compatível)
Já previsto na Seção 18.2 como parte da estratégia de armazenamento híbrido, o MinIO foi escolhido em vez de um provedor cloud pago por ser open-source e permitir que a equipe rode um ambiente local idêntico ao de produção durante o desenvolvimento acadêmico, sem custo. Armazena laudos e imagens de exames (RF-004), enquanto o PostgreSQL guarda apenas metadados, hash SHA-256 e URL — mantendo o banco relacional leve, conforme RNF-001 (tempo de resposta < 1,5s).

Cache — Redis
Sustenta o RNF-001 (performance) e a “camada de cache” já mencionada na Seção 18.2, garantindo que o dashboard adaptativo carregue rapidamente dados de acesso frequente, como alergias e medicamentos ativos — informações que a Dra. Amanda destacou como as mais consultadas em situações de urgência (pergunta 4 da entrevista).

Autenticação — JWT + MFA (TOTP)
Atende diretamente ao RNF-012 (Autenticação Multifator para médicos e gestores) e à RN-002 (controle de acesso vinculado a atendimento). O uso de JSON Web Tokens de curta duração, combinado com controle de sessão (expiração após 15 min de inatividade), reduz o risco jurídico de acesso indevido apontado pelo Dr. Yan — especialmente relevante diante da decisão de tornar as permissões de paciente de duração indefinida (RN-014), o que exige controles de sessão do lado profissional ainda mais rígidos como contrapeso.

Módulo de IA — API de LLM externa via camada de abstração
Em vez de treinar um modelo próprio (inviável para o escopo e o prazo do curso), o MedFlow consome uma API de linguagem natural externa por trás de uma camada de abstração de provedor, com fallback configurado — exigência explícita do RNF-016. Essa camada é responsável por três funcionalidades: resumo simplificado de laudos (RF-008), resumo contextualizado por queixa (RF-020) e apoio à redação de notificações empáticas (RF-009). Os alertas clínicos críticos (RF-010, RN-011, RN-015), no entanto, não dependem da IA externa — são implementados como regras determinísticas locais no backend, decisão tomada justamente para não colocar a segurança do paciente refém da disponibilidade de um serviço terceirizado, e para reduzir o risco jurídico de “vigilância incompleta” identificado pelo Dr. Yan.

Sincronização Offline — SQLite local + filas de idempotência
Implementa o RF-019 (Sincronização Offline Bidirecional), restrito ao perfil paciente. O app mobile mantém uma base local (via expo-sqlite) para leitura e escrita quando sem conectividade; cada operação carrega um client_operation_id, replicado nas colunas de idempotência já definidas no Modelo Lógico, evitando duplicação quando a fila é sincronizada ao servidor. O perfil médico é explicitamente excluído dessa camada, em coerência com o RF-022 (Zero-Cache no Perfil Profissional).

Testes — Jest (unitário/integração) e Maestro (E2E mobile)
Escolhidos por cobrirem, respectivamente, a lógica de negócio no backend (cruzamento de alergias e medicamentos, regras de auditoria) e os fluxos críticos de interface no app (login, upload de exame, geração de QR Code de permissão), suportando a meta de cobertura mínima de 80% do RNF-008.

Infraestrutura e Versionamento — Docker + GitHub Actions
Contêineres Docker padronizam o ambiente entre os 4 integrantes (evitando o clássico “na minha máquina funciona”), e o GitHub Actions automatiza lint e testes a cada push — apoio direto à contramedida definida na Seção 7 para o problema de gestão de tempo do 3º período (revisões semanais com entregas mínimas viáveis por sprint).