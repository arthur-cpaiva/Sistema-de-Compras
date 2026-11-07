
-- 1. USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    perfil ENUM(
        'Solicitante',
        'Gerente',
        'Compras'
    ) NOT NULL,
    setor VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;


-- 2. REQUISICOES
CREATE TABLE requisicoes (
    id_requisicao INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitante INT NOT NULL,
    data_requisicao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,
    justificativa TEXT NOT NULL,
    prioridade ENUM(
        'Normal',
        'Urgente'
    ) NOT NULL DEFAULT 'Normal',
    status ENUM(
        'Pendente',
        'Aguardando aprovacao',
        'Aprovada',
        'Reprovada',
        'Finalizada'
    ) NOT NULL DEFAULT 'Pendente',

    CONSTRAINT fk_requisicoes_usuarios
    FOREIGN KEY (id_solicitante)
    REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;


-- 3. ITENS DA REQUISICAO
CREATE TABLE itens_requisicao (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_requisicao INT NOT NULL,
    produto VARCHAR(150) NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    unidade ENUM(
        'Unidade',
        'Metro',
        'Quilograma',
        'Litro',
        'Caixa',
        'Par',
        'Pacote',
        'Rolo',
        'Jogo'
    ) NOT NULL DEFAULT 'Unidade',
    observacao TEXT,

    CONSTRAINT fk_itens_requisicoes
    FOREIGN KEY (id_requisicao)
    REFERENCES requisicoes(id_requisicao),

    CONSTRAINT verificar_quantidade
    CHECK (quantidade > 0)
) ENGINE=InnoDB;


-- 4. COTACOES
CREATE TABLE cotacoes (
    id_cotacao INT AUTO_INCREMENT PRIMARY KEY,
    id_requisicao INT NOT NULL,
    id_comprador INT NOT NULL,
    fornecedor VARCHAR(150) NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    forma_pagamento ENUM(
        'Credito',
        'A vista',
        'Faturado'
    ) NOT NULL,
    prazo_entrega VARCHAR(100),
    arquivo_orcamento VARCHAR(255),
    observacao TEXT,
    data_cotacao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cotacoes_requisicoes
    FOREIGN KEY (id_requisicao)
    REFERENCES requisicoes(id_requisicao),

    CONSTRAINT fk_cotacoes_comprador
    FOREIGN KEY (id_comprador)
    REFERENCES usuarios(id_usuario),

    CONSTRAINT verificar_valor
    CHECK (valor_total >= 0)
) ENGINE=InnoDB;


-- 5. APROVACOES
CREATE TABLE aprovacoes (
    id_aprovacao INT AUTO_INCREMENT PRIMARY KEY,
    id_requisicao INT NOT NULL,
    id_cotacao INT,
    id_gerente INT NOT NULL,
    decisao ENUM(
        'Aprovada',
        'Reprovada'
    ) NOT NULL,
    observacao TEXT,
    data_aprovacao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_aprovacoes_requisicoes
    FOREIGN KEY (id_requisicao)
    REFERENCES requisicoes(id_requisicao),

    CONSTRAINT fk_aprovacoes_cotacoes
    FOREIGN KEY (id_cotacao)
    REFERENCES cotacoes(id_cotacao),

    CONSTRAINT fk_aprovacoes_gerente
    FOREIGN KEY (id_gerente)
    REFERENCES usuarios(id_usuario)
) ENGINE=InnoDB;


-- 6. COMPRAS
CREATE TABLE compras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_aprovacao INT NOT NULL UNIQUE,
    id_comprador INT NOT NULL,
    data_compra DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,
    observacao TEXT,

    CONSTRAINT fk_compras_aprovacoes
    FOREIGN KEY (id_aprovacao)
    REFERENCES aprovacoes(id_aprovacao),

    CONSTRAINT fk_compras_comprador
    FOREIGN KEY (id_comprador)
    REFERENCES usuarios(id_usuario)
) ENGINE=INNODB;
usuarios
INSERT INTO usuarios (nome, senha_hash,perfil, setor, ativo, email)
VALUES ('Andrew', '$2y$10$v2CDvUqdzWlzN3qroLo1SOub8P.IddxpYRZgPLWEJrc/Y6tM9rszq', 'gerente', 'gerência', '1', 'andrew28@hotmail.com')

INSERT INTO usuarios (nome, senha_hash,perfil, setor, email)
VALUES ('Gustavo', '$2y$10$v2CDvUqdzWlzN3qroLo1SOub8P.IddxpYRZgPLWEJrc/Y6tM9rszq', 'gerente', 'gerência', 'gustavo58@hotmail.com');

INSERT INTO usuarios (nome, senha_hash,perfil, setor, email)
VALUES ('Henrique', '$2y$10$v2CDvUqdzWlzN3qroLo1SOub8P.IddxpYRZgPLWEJrc/Y6tM9rszq', 'Solicitante', 'Encarregado', 'rabiola28@hotmail.com');

INSERT INTO usuarios (nome, senha_hash,perfil, setor, email)
VALUES ('Arthur', '$2y$10$v2CDvUqdzWlzN3qroLo1SOub8P.IddxpYRZgPLWEJrc/Y6tM9rszq', 'Compras', 'Compras', 'compras28@hotmail.com');

SELECT * FROM usuarios

INSERT INTO requisicoes (id_solicitante,justificativa, prioridade)
VALUES ('2', 'Peça quebrou e precisamos para continuidade das operações', 'Urgente');

INSERT INTO itens_requisicao (id_requisicao, produto, quantidade, observacao)
VALUES ('1', 'bomba sappo', '2', 'Comprar a de 1 cavalo');

INSERT INTO cotacoes (id_requisicao, id_comprador, fornecedor, valor_total, forma_pagamento)
VALUES ('1', '3', 'Locaminas', '1150,00', 'Faturado');

INSERT INTO cotacoes (id_requisicao, id_comprador, fornecedor, valor_total, forma_pagamento)
VALUES ('1', '3', 'Loja do Mecânico', '1250.00', 'Faturado');

INSERT INTO cotacoes (id_requisicao, id_comprador, fornecedor, valor_total, forma_pagamento)
VALUES ('1', '3', 'Portal das Bombas', '1159.69', 'Faturado');

INSERT INTO aprovacoes (id_requisicao, id_cotacao, id_gerente, decisao)
VALUES (1, 1, 1, 'Aprovada');

INSERT INTO compras (id_aprovacao, id_comprador)
VALUES (1, 3);

SELECT
    c.id_compra,
    u.nome AS comprador,
    g.nome AS gerente,
    co.fornecedor,
    co.valor_total,
    a.decisao
FROM compras c
INNER JOIN aprovacoes a
    ON c.id_aprovacao = a.id_aprovacao
INNER JOIN cotacoes co
    ON a.id_cotacao = co.id_cotacao
INNER JOIN usuarios u
    ON c.id_comprador = u.id_usuario
INNER JOIN usuarios g
    ON a.id_gerente = g.id_usuario;


SELECT
    c.id_compra,
    u.nome AS comprador,
    g.nome AS gerente,
    co.fornecedor,
    co.valor_total,
    a.decisao,
    r.status AS status_requisicao
FROM compras c

INNER JOIN aprovacoes a
    ON c.id_aprovacao = a.id_aprovacao

INNER JOIN cotacoes co
    ON a.id_cotacao = co.id_cotacao

INNER JOIN requisicoes r
    ON a.id_requisicao = r.id_requisicao

INNER JOIN usuarios u
    ON c.id_comprador = u.id_usuario

INNER JOIN usuarios g
    ON a.id_gerente = g.id_usuario;
    
    
    
SELECT * FROM aprovacoes;  
   

START TRANSACTION
INSERT INTO aprovacoes (id_requisicao, id_cotacao, id_gerente, decisao)
VALUES (1,2,4,'Aprovada');

UPDATE requisicoes 	
SET STATUS = 'Aprovada'		'
WHERE id_requisicao = 1;


