-- INSERIR CURSOS INICIAIS
INSERT INTO university.curso (codigo, nome, vagas)
VALUES 
  ('ADS01', 'Análise e Desenvolvimento de Sistemas', 50),
  ('ENG01', 'Engenharia', 40),
  ('ADM01', 'Administração', 30),
  ('DIR01', 'Direito', 60);

----------------------------------------------------------
-- EXEMPLO DE PESSOA FÍSICA + ALUNO
----------------------------------------------------------

WITH p AS (
  INSERT INTO university.pessoa (tipo, nome, email, telefone)
  VALUES ('FISICA', 'João da Silva', 'joao@exemplo.com', '(11)99999-0001')
  RETURNING id
)
INSERT INTO university.pessoa_fisica (pessoa_id, cpf, data_nascimento, sexo)
SELECT id, '12345678900', '1998-05-10', 'M' FROM p;

WITH p2 AS (
  SELECT id FROM university.pessoa WHERE nome = 'João da Silva'
)
INSERT INTO university.aluno (pessoa_id, matricula, curso_id, periodo, contato_emergencia)
SELECT id, '2025-0001', 1, 'matutino', 'Maria - (11)98888-0000' FROM p2;

----------------------------------------------------------
-- PROFESSOR EXEMPLO
----------------------------------------------------------

WITH pf AS (
  INSERT INTO university.pessoa (tipo, nome, email)
  VALUES ('FISICA', 'Ana Professora', 'ana@exemplo.com')
  RETURNING id
)
INSERT INTO university.pessoa_fisica (pessoa_id, cpf, sexo)
SELECT id, '98765432100', 'F' FROM pf;

WITH idp AS (SELECT id FROM pf)
INSERT INTO university.professor (pessoa_id, titulacao, area_atuacao, vinculo, matricula_funcional)
SELECT id, 'Mestre', 'Tecnologia da Informação', 'EFETIVO', 'PROF-1001' FROM idp;

----------------------------------------------------------
-- PESSOA JURÍDICA + FORNECEDOR
----------------------------------------------------------

WITH pj AS (
  INSERT INTO university.pessoa (tipo, nome, email)
  VALUES ('JURIDICA', 'Tech Solutions LTDA', 'contato@tech.com')
  RETURNING id
)
INSERT INTO university.pessoa_juridica (pessoa_id, cnpj, razao_social, nome_fantasia)
SELECT id, '11222333000199', 'Tech Solutions LTDA', 'TechSol' FROM pj;

WITH idpj AS (SELECT id FROM pj)
INSERT INTO university.fornecedor (pessoa_id, dados_bancarios, status)
SELECT id, '{"banco":"Itaú","agencia":"1234","conta":"56789-0"}'::jsonb, 'EM_ANALISE' FROM idpj;
