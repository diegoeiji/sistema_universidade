-- SCHEMA PRINCIPAL
CREATE SCHEMA IF NOT EXISTS university;

-------------------------------------------------------
-- TABELA BASE: PESSOA
-------------------------------------------------------
CREATE TABLE university.pessoa (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tipo VARCHAR(20) NOT NULL,    -- FISICA | JURIDICA
  nome VARCHAR(255),
  email VARCHAR(255),
  telefone VARCHAR(50),
  criado_em TIMESTAMP DEFAULT now()
);


-------------------------------------------------------
-- PESSOA FÍSICA
-------------------------------------------------------
CREATE TABLE university.pessoa_fisica (
  pessoa_id UUID PRIMARY KEY REFERENCES university.pessoa(id),
  cpf VARCHAR(20) UNIQUE NOT NULL,
  data_nascimento DATE,
  sexo VARCHAR(10)
);

-------------------------------------------------------
-- PESSOA JURÍDICA
-------------------------------------------------------
CREATE TABLE university.pessoa_juridica (
  pessoa_id UUID PRIMARY KEY REFERENCES university.pessoa(id),
  cnpj VARCHAR(20) UNIQUE NOT NULL,
  razao_social VARCHAR(255),
  nome_fantasia VARCHAR(255),
  inscricao_estadual VARCHAR(100),
  inscricao_municipal VARCHAR(100),
  contato_fiscal VARCHAR(255),
  status_fiscal VARCHAR(30) DEFAULT 'ATIVO' -- ATIVO, PENDENTE, SUSPENSO
);

-------------------------------------------------------
-- ENDEREÇO
-------------------------------------------------------
CREATE TABLE university.endereco (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pessoa_id UUID REFERENCES university.pessoa(id),
  logradouro VARCHAR(255),
  numero VARCHAR(20),
  complemento VARCHAR(255),
  cidade VARCHAR(100),
  estado VARCHAR(50),
  cep VARCHAR(20)
);

-------------------------------------------------------
-- DOCUMENTOS (upload)
-------------------------------------------------------
CREATE TABLE university.documento (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pessoa_id UUID REFERENCES university.pessoa(id),
  tipo VARCHAR(50),        -- CONTRATO, RG, CPF, DIPLOMA, CERTIFICADO
  url TEXT NOT NULL,       -- link do arquivo armazenado
  enviado_em TIMESTAMP DEFAULT now()
);

-------------------------------------------------------
-- CURSOS
-------------------------------------------------------
CREATE TABLE university.curso (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50) UNIQUE,
  nome VARCHAR(255),
  vagas INTEGER NOT NULL,
  vagas_ocupadas INTEGER DEFAULT 0
);

-------------------------------------------------------
-- ALUNO
-------------------------------------------------------
CREATE TABLE university.aluno (
  pessoa_id UUID PRIMARY KEY REFERENCES university.pessoa(id),
  matricula VARCHAR(50) UNIQUE NOT NULL,
  curso_id INTEGER REFERENCES university.curso(id),
  periodo VARCHAR(30),
  contato_emergencia VARCHAR(255),
  status VARCHAR(30) DEFAULT 'ATIVO',  -- ATIVO, PENDENTE, LISTA_ESPERA
  documentos_ok BOOLEAN DEFAULT FALSE
);

-------------------------------------------------------
-- MATRÍCULA (histórico de matrículas)
-------------------------------------------------------
CREATE TABLE university.matricula (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aluno_id UUID REFERENCES university.aluno(pessoa_id),
  curso_id INTEGER REFERENCES university.curso(id),
  semestre VARCHAR(20),
  situacao VARCHAR(20) DEFAULT 'ATIVO',   -- ATIVO, TRANCADO, CONCLUÍDO, LISTA_ESPERA
  data_matricula TIMESTAMP DEFAULT now()
);

-------------------------------------------------------
-- PROFESSOR
-------------------------------------------------------
CREATE TABLE university.professor (
  pessoa_id UUID PRIMARY KEY REFERENCES university.pessoa(id),
  titulacao VARCHAR(100),
  area_atuacao VARCHAR(255),
  vinculo VARCHAR(50),        -- EFETIVO | CONTRATO
  matricula_funcional VARCHAR(50) UNIQUE,
  horarios_disponiveis TEXT,
  status VARCHAR(20) DEFAULT 'ATIVO'  -- ATIVO | PENDENTE
);

-------------------------------------------------------
-- FORNECEDOR
-------------------------------------------------------
CREATE TABLE university.fornecedor (
  pessoa_id UUID PRIMARY KEY REFERENCES university.pessoa(id),
  dados_bancarios JSONB,
  status VARCHAR(20) DEFAULT 'EM_ANALISE',   -- EM_ANALISE | ATIVO | BLOQUEADO
  contrato_url TEXT
);

-------------------------------------------------------
-- ÍNDICES
-------------------------------------------------------

CREATE INDEX idx_pessoa_nome ON university.pessoa (lower(nome));
CREATE INDEX idx_pf_cpf ON university.pessoa_fisica (cpf);
CREATE INDEX idx_pj_cnpj ON university.pessoa_juridica (cnpj);
CREATE INDEX idx_professor_matricula ON university.professor (matricula_funcional);
CREATE INDEX idx_aluno_matricula ON university.aluno (matricula);
CREATE INDEX idx_fornecedor_status ON university.fornecedor (status);
