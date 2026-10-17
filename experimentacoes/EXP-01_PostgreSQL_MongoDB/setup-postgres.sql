CREATE TYPE tipo_usuario AS ENUM ('PACIENTE','MEDICO','ADMIN');

CREATE TABLE usuario (
  id_usuario SERIAL PRIMARY KEY,
  primeiro_nome VARCHAR(100) NOT NULL,
  sobrenome VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  tipo_usuario tipo_usuario NOT NULL,
  data_criacao TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE paciente (
  id_paciente INT PRIMARY KEY REFERENCES usuario(id_usuario) ON DELETE RESTRICT,
  data_nascimento DATE NOT NULL,
  sexo VARCHAR(20) NOT NULL,
  data_exclusao TIMESTAMPTZ NULL
);

INSERT INTO usuario (id_usuario, primeiro_nome, sobrenome, email, tipo_usuario)
  VALUES (1054, 'Maria', 'Silva', 'maria.teste@exemplo.com', 'PACIENTE');

INSERT INTO paciente (id_paciente, data_nascimento, sexo)
  VALUES (1054, '1985-03-10', 'F');
