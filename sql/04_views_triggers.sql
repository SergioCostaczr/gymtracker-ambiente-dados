-- =============================================================
-- GymTracker - Views | Triggers
-- =============================================================
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

-- =============================================================
-- Pré-requisito: Tabela de log para auditoria de peso
-- =============================================================
 
CREATE TABLE IF NOT EXISTS log_peso_usuario (
    id                INT             NOT NULL AUTO_INCREMENT,
    usuario_id        INT             NOT NULL,
    peso_anterior     DECIMAL(5,2)    NOT NULL,
    peso_novo         DECIMAL(5,2)    NOT NULL,
    data_alteracao    TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_log_peso PRIMARY KEY (id)
);
 
-- =============================================================
-- Trigger 1 BEFORE INSERT: trg_validar_sessao_aberta
-- Impede inserção de exercício em sessão já finalizada
-- =============================================================
 
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
 
-- =============================================================
-- Trigger 2 AFTER UPDATE: trg_historico_peso
-- Salva peso anterior em historico_peso_usuario
-- e registra a alteração em log_peso_usuario
-- =============================================================
 
DROP TRIGGER IF EXISTS trg_historico_peso;
DELIMITER $$
CREATE TRIGGER trg_historico_peso
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
    IF OLD.peso <> NEW.peso THEN
        INSERT INTO historico_peso_usuario (peso, data_registro, usuario_id_usuario)
        VALUES (OLD.peso, CURDATE(), OLD.id_usuario);
 
        INSERT INTO log_peso_usuario (usuario_id, peso_anterior, peso_novo)
        VALUES (OLD.id_usuario, OLD.peso, NEW.peso);
    END IF;
END$$
DELIMITER ;
 
-- =============================================================
-- Trigger 3 AFTER UPDATE: trg_duracao_sessao
-- Calcula e persiste duracao_minutos ao preencher hora_fim
-- =============================================================
 
DROP TRIGGER IF EXISTS trg_duracao_sessao;
DELIMITER $$
CREATE TRIGGER trg_duracao_sessao
AFTER UPDATE ON sessao
FOR EACH ROW
BEGIN
    IF NEW.hora_fim IS NOT NULL AND OLD.hora_fim IS NULL THEN
        UPDATE sessao
        SET duracao_minutos = TIMESTAMPDIFF(MINUTE,
            CONCAT(NEW.data, ' ', NEW.hora_inicio),
            CONCAT(NEW.data, ' ', NEW.hora_fim))
        WHERE idsessao = NEW.idsessao;
    END IF;
END$$
DELIMITER ;
 
-- =============================================================
-- Trigger 4 AFTER INSERT: trg_peso_atual_exercicio
-- Atualiza peso_atual em dia_exercicio com o peso
-- utilizado na execução mais recente
-- =============================================================
 
DROP TRIGGER IF EXISTS trg_peso_atual_exercicio;
DELIMITER $$
CREATE TRIGGER trg_peso_atual_exercicio
AFTER INSERT ON exercicio_executado
FOR EACH ROW
BEGIN
    UPDATE dia_exercicio
    SET peso_atual = NEW.peso_utilizado
    WHERE iddia_exercicio = NEW.dia_exercicio_iddia_exercicio;
END$$
DELIMITER ;