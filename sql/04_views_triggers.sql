USE gymtracker;

-- =============================================================
-- 4.2 VIEWS
-- =============================================================

-- -------------------------------------------------------------
-- View 1 Segurança: vw_usuario_publico
-- Expõe dados do usuário ocultando o campo senha
-- -------------------------------------------------------------

CREATE OR REPLACE VIEW vw_usuario_publico AS
SELECT
    id_usuario,
    nome,
    email,
    objetivo,
    altura,
    peso
FROM usuario;

-- -------------------------------------------------------------
-- View 2 Relatório: vw_painel_usuario
-- Consolida por usuário: nome, objetivo, peso atual,
-- total de sessões realizadas e total de exercícios executados
-- -------------------------------------------------------------

CREATE OR REPLACE VIEW vw_painel_usuario AS
SELECT
    u.nome,
    u.objetivo,
    u.peso,
    COUNT(DISTINCT s.idsessao)                      AS total_sessoes,
    COUNT(ee.idexercicio_executado)                 AS total_exercicios_executados
FROM usuario u
LEFT JOIN sessao s
    ON s.usuario_id_usuario = u.id_usuario
LEFT JOIN exercicio_executado ee
    ON ee.sessao_idsessao = s.idsessao
GROUP BY
    u.id_usuario,
    u.nome,
    u.objetivo,
    u.peso;

-- =============================================================
-- 4.3 TRIGGERS
-- =============================================================

-- -------------------------------------------------------------
-- Pré-requisito Tabela de log para Trigger 2
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS log_peso_usuario (
    id                INT             NOT NULL AUTO_INCREMENT,
    usuario_id        INT             NOT NULL,
    peso_anterior     DECIMAL(5,2)    NOT NULL,
    peso_novo         DECIMAL(5,2)    NOT NULL,
    data_alteracao    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_log_peso PRIMARY KEY (id)
);

-- -------------------------------------------------------------
-- Trigger 1 BEFORE INSERT: trg_validar_sessao_aberta
-- Impede inserção de exercício em sessão já finalizada
-- -------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_validar_sessao_aberta;

DELIMITER $$

CREATE TRIGGER trg_validar_sessao_aberta
BEFORE INSERT ON exercicio_executado
FOR EACH ROW
BEGIN
    DECLARE v_hora_fim TIME;

    SELECT hora_fim
    INTO   v_hora_fim
    FROM   sessao
    WHERE  idsessao = NEW.sessao_idsessao;

    IF v_hora_fim IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível registrar exercício em uma sessão já finalizada.';
    END IF;
END$$

DELIMITER ;

-- -------------------------------------------------------------
-- Trigger 2 AFTER UPDATE: trg_historico_peso
-- Registra alteração de peso em historico_peso_usuario
-- e audita na tabela log_peso_usuario
-- -------------------------------------------------------------

DROP TRIGGER IF EXISTS trg_historico_peso;

DELIMITER $$

CREATE TRIGGER trg_historico_peso
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    IF OLD.peso <> NEW.peso THEN
        -- 1. Insere o peso anterior no histórico
        INSERT INTO historico_peso_usuario (peso, data_registro, usuario_id_usuario)
        VALUES (OLD.peso, CURDATE(), OLD.id_usuario);

        -- 2. Registra a alteração na tabela de log
        INSERT INTO log_peso_usuario (usuario_id, peso_anterior, peso_novo)
        VALUES (OLD.id_usuario, OLD.peso, NEW.peso);
    END IF;
END$$

DELIMITER ;