-- ==============================================================================
-- 1. TABELAS BASE (Sem dependências de chaves estrangeiras)
-- ==============================================================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    primeiro_nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('PACIENTE', 'MEDICO', 'ADMIN') NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    ultimo_login TIMESTAMP NULL
);

CREATE TABLE especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(100) NOT NULL UNIQUE,
    codigo_cbo VARCHAR(20),
    descricao TEXT
);

CREATE TABLE comorbidade (
    id_comorbidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo_cid10 VARCHAR(10) UNIQUE,
    categoria VARCHAR(100)
);

CREATE TABLE vicio (
    id_vicio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    categoria VARCHAR(100),
    relevancia_clinica VARCHAR(50)
);

CREATE TABLE substancia (
    id_substancia INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    classe_quimica VARCHAR(100),
    codigo_dcb VARCHAR(20) UNIQUE
);

CREATE TABLE medicamento (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_comercial VARCHAR(150) NOT NULL,
    principio_ativo VARCHAR(150) NOT NULL,
    classe_terapeutica VARCHAR(100),
    codigo_anvisa VARCHAR(20) UNIQUE,
    via_administracao VARCHAR(50),
    forma_farmaceutica VARCHAR(50)
);

CREATE TABLE categoria_dado (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    sensibilidade ENUM('BAIXA', 'MEDIA', 'ALTA', 'CRITICA') NOT NULL
);

-- ==============================================================================
-- 2. TABELAS DERIVADAS DE USUÁRIO (Perfis, Contatos e Aceites)
-- ==============================================================================

CREATE TABLE paciente (
    id_paciente INT PRIMARY KEY,
    data_nascimento DATE NOT NULL,
    sexo VARCHAR(20) NOT NULL,
    tipo_sanguineo VARCHAR(5),
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_paciente) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE medico (
    id_medico INT PRIMARY KEY,
    crm VARCHAR(20) NOT NULL UNIQUE,
    uf_crm CHAR(2) NOT NULL UNIQUE,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_medico) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE telefone (
    id_telefone INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    tipo_telefone ENUM('CELULAR', 'RESIDENCIAL', 'TRABALHO') NOT NULL,
    telefone_principal BOOLEAN NOT NULL DEFAULT FALSE,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    complemento VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    tipo_endereco ENUM('CASA', 'TRABALHO', 'OUTRO') NOT NULL,
    endereco_principal BOOLEAN NOT NULL DEFAULT FALSE,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE termo_aceite (
    id_aceite INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    versao_termo VARCHAR(50) NOT NULL,
    texto_termo TEXT NOT NULL,
    data_aceite TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_aceite VARCHAR(45) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- ==============================================================================
-- 3. TABELAS DE RELACIONAMENTO CLÍNICO E PERMISSÕES (N:M)
-- ==============================================================================

CREATE TABLE medico_especialidade (
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_obtencao DATE,
    PRIMARY KEY (id_medico, id_especialidade),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE,
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade) ON DELETE CASCADE
);

CREATE TABLE paciente_tutela (
    id_paciente_responsavel INT NOT NULL,
    id_paciente_tutelado INT NOT NULL,
    tipo_relacao ENUM('PAI', 'MAE', 'TUTOR', 'OUTRO') NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    PRIMARY KEY (id_paciente_responsavel, id_paciente_tutelado, tipo_relacao, data_inicio),
    FOREIGN KEY (id_paciente_responsavel) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_paciente_tutelado) REFERENCES paciente(id_paciente) ON DELETE CASCADE
);

CREATE TABLE permissao_acesso (
    id_permissao INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_concessao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_revogacao TIMESTAMP NULL,
    metodo_concessao ENUM('MANUAL', 'SISTEMA', 'QR_CODE') NOT NULL,
    status ENUM('ATIVO', 'REVOGADO', 'EXPIRADO') NOT NULL,
    token_hash VARCHAR(255),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE
);

CREATE TABLE permissao_categoria (
    id_permissao INT NOT NULL,
    id_categoria INT NOT NULL,
    PRIMARY KEY (id_permissao, id_categoria),
    FOREIGN KEY (id_permissao) REFERENCES permissao_acesso(id_permissao) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria_dado(id_categoria) ON DELETE CASCADE
);

CREATE TABLE medicamento_substancia (
    id_medicamento INT NOT NULL,
    id_substancia INT NOT NULL,
    concentracao VARCHAR(50),
    PRIMARY KEY (id_medicamento, id_substancia),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento) ON DELETE CASCADE,
    FOREIGN KEY (id_substancia) REFERENCES substancia(id_substancia) ON DELETE CASCADE
);

CREATE TABLE alergia (
    id_alergia INT AUTO_INCREMENT PRIMARY KEY,
    id_substancia INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    nivel_risco ENUM('BAIXO', 'MEDIO', 'ALTO') NOT NULL,
    FOREIGN KEY (id_substancia) REFERENCES substancia(id_substancia)
);

CREATE TABLE paciente_comorbidade (
    id_paciente INT NOT NULL,
    id_comorbidade INT NOT NULL,
    data_diagnostico DATE,
    severidade ENUM('LEVE', 'MODERADA', 'GRAVE') NOT NULL,
    status VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    PRIMARY KEY (id_paciente, id_comorbidade),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_comorbidade) REFERENCES comorbidade(id_comorbidade) ON DELETE CASCADE
);

CREATE TABLE paciente_vicio (
    id_paciente INT NOT NULL,
    id_vicio INT NOT NULL,
    data_inicio DATE,
    frequencia VARCHAR(50),
    status VARCHAR(50) NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    PRIMARY KEY (id_paciente, id_vicio),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_vicio) REFERENCES vicio(id_vicio) ON DELETE CASCADE
);

CREATE TABLE paciente_possui_alergia (
    id_paciente INT NOT NULL,
    id_alergia INT NOT NULL,
    data_diagnostico DATE,
    severidade_reacao ENUM('LEVE', 'MODERADA', 'GRAVE', 'ANAFLAXIA') NOT NULL,
    observacao_clinica TEXT,
    identificado_por_id_usuario INT,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    PRIMARY KEY (id_paciente, id_alergia),
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_alergia) REFERENCES alergia(id_alergia) ON DELETE CASCADE,
    FOREIGN KEY (identificado_por_id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
);

CREATE TABLE paciente_utiliza_medicamento (
    id_paciente_utiliza INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    frequencia_uso VARCHAR(50) NOT NULL,
    via_administracao VARCHAR(50),
    data_inicio_uso DATE NOT NULL,
    data_fim_uso DATE,
    prescrito_por_id_medico INT,
    motivo_prescricao TEXT,
    status VARCHAR(50) NOT NULL,
    client_operation_id VARCHAR(100) UNIQUE,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento),
    FOREIGN KEY (prescrito_por_id_medico) REFERENCES medico(id_medico) ON DELETE SET NULL
);

-- ==============================================================================
-- 4. CONSULTAS, HISTÓRICO E LOGS
-- ==============================================================================

CREATE TABLE consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    data_hora_inicio TIMESTAMP NOT NULL,
    data_hora_fim TIMESTAMP NULL,
    motivo_consulta TEXT NOT NULL,
    diagnostico TEXT,
    observacoes TEXT,
    status ENUM('AGENDADA', 'EM_ANDAMENTO', 'FINALIZADA', 'CANCELADA') NOT NULL,
    tipo_consulta ENUM('PRESENCIAL', 'TELEMEDICINA', 'RETORNO') NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    status_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE
);

CREATE TABLE historico (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_consulta INT,
    tipo_evento ENUM('CRIACAO', 'ATUALIZACAO', 'EXCLUSAO', 'VISUALIZACAO') NOT NULL,
    descricao TEXT NOT NULL,
    instituicao_origem VARCHAR(150),
    data_evento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    alterado_por_id_usuario INT,
    motivo_alteracao TEXT,
    data_atualizacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    data_exclusao TIMESTAMP NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta) ON DELETE SET NULL,
    FOREIGN KEY (alterado_por_id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
);

CREATE TABLE log_auditoria (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    operacao ENUM('INSERT', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT') NOT NULL,
    entidade_afetada VARCHAR(100) NOT NULL,
    id_registro_afetado VARCHAR(50) NOT NULL,
    valor_anterior TEXT,
    valor_posterior TEXT,
    ip_origem VARCHAR(45),
    user_agent VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE log_inferencia_ia (
    id_inferencia BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    solicitado_por_id_usuario INT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modelo_utilizado VARCHAR(100) NOT NULL,
    provedor VARCHAR(50) NOT NULL,
    tipo_inferencia ENUM('DIAGNOSTICO', 'RESUMO_PRONTUARIO', 'ANALISE_EXAME') NOT NULL,
    input_hash VARCHAR(64) NOT NULL,
    output_texto TEXT NOT NULL,
    tokens_consumidos INT NOT NULL,
    custo_estimado DECIMAL(10,4),
    tempo_resposta_ms INT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    FOREIGN KEY (solicitado_por_id_usuario) REFERENCES usuario(id_usuario)
);