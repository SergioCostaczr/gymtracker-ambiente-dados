-- =============================================================
-- GymTracker - Script DDL
-- Autor: Manoel Sérgio Costa Lima Filho
-- =============================================================

CREATE DATABASE IF NOT EXISTS gymtracker;
USE gymtracker;

-- =============================================================
-- TABELAS DE CATÁLOGO (sem dependências)
-- =============================================================

CREATE TABLE grupo_muscular (
    idgrupo_muscular    INT             NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(45)     NOT NULL,
    CONSTRAINT pk_grupo_muscular    PRIMARY KEY (idgrupo_muscular),
    CONSTRAINT uq_grupo_muscular    UNIQUE (nome)
);

CREATE TABLE equipamento (
    idequipamento       INT             NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(45)     NOT NULL,
    CONSTRAINT pk_equipamento       PRIMARY KEY (idequipamento),
    CONSTRAINT uq_equipamento       UNIQUE (nome)
);

-- =============================================================
-- USUÁRIO
-- =============================================================

CREATE TABLE usuario (
    id_usuario          INT             NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(100)    NOT NULL,
    email               VARCHAR(100)    NOT NULL,
    senha               VARCHAR(255)    NOT NULL,
    objetivo            ENUM('HIPERTROFIA', 'EMAGRECIMENTO', 'CONDICIONAMENTO') NOT NULL,
    altura              DECIMAL(3,2)    NOT NULL,
    peso                DECIMAL(5,2)    NOT NULL,
    data_cadastro       DATE            NOT NULL,
    CONSTRAINT pk_usuario           PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuario_email     UNIQUE (email),
    CONSTRAINT ck_usuario_altura    CHECK (altura > 0),
    CONSTRAINT ck_usuario_peso      CHECK (peso > 0)
);

-- =============================================================
-- HISTÓRICO DE PESO CORPORAL
-- =============================================================

CREATE TABLE historico_peso_usuario (
    idhistorico_peso_usuario    INT             NOT NULL AUTO_INCREMENT,
    peso                        DECIMAL(5,2)    NOT NULL,
    data_registro               DATE            NOT NULL,
    usuario_id_usuario          INT             NOT NULL,
    CONSTRAINT pk_historico_peso        PRIMARY KEY (idhistorico_peso_usuario),
    CONSTRAINT fk_historico_usuario     FOREIGN KEY (usuario_id_usuario)
        REFERENCES usuario (id_usuario),
    CONSTRAINT ck_historico_peso        CHECK (peso > 0)
);

-- =============================================================
-- EXERCÍCIO
-- =============================================================

CREATE TABLE exercicio (
    idexercicio                     INT             NOT NULL AUTO_INCREMENT,
    nome                            VARCHAR(100)    NOT NULL,
    descricao                       TEXT,
    grupo_muscular_idgrupo_muscular INT             NOT NULL,
    equipamento_idequipamento       INT             NOT NULL,
    CONSTRAINT pk_exercicio             PRIMARY KEY (idexercicio),
    CONSTRAINT fk_exercicio_grupo       FOREIGN KEY (grupo_muscular_idgrupo_muscular)
        REFERENCES grupo_muscular (idgrupo_muscular),
    CONSTRAINT fk_exercicio_equipamento FOREIGN KEY (equipamento_idequipamento)
        REFERENCES equipamento (idequipamento)
);

-- =============================================================
-- PLANO DE TREINO
-- =============================================================

CREATE TABLE plano_treino (
    idplano_treino      INT             NOT NULL AUTO_INCREMENT,
    nome                VARCHAR(100)    NOT NULL,
    data_criacao        DATE            NOT NULL,
    ativo               TINYINT(1)      NOT NULL DEFAULT 1,
    usuario_id_usuario  INT             NOT NULL,
    CONSTRAINT pk_plano_treino          PRIMARY KEY (idplano_treino),
    CONSTRAINT fk_plano_usuario         FOREIGN KEY (usuario_id_usuario)
        REFERENCES usuario (id_usuario),
    CONSTRAINT ck_plano_ativo           CHECK (ativo IN (0, 1))
);

-- =============================================================
-- DIA DE TREINO
-- =============================================================

CREATE TABLE dia_treino (
    iddia_treino                INT         NOT NULL AUTO_INCREMENT,
    dia_da_semana               ENUM('SEGUNDA','TERCA','QUARTA','QUINTA','SEXTA','SABADO','DOMINGO') NOT NULL,
    plano_treino_idplano_treino INT         NOT NULL,
    CONSTRAINT pk_dia_treino            PRIMARY KEY (iddia_treino),
    CONSTRAINT fk_dia_plano             FOREIGN KEY (plano_treino_idplano_treino)
        REFERENCES plano_treino (idplano_treino),
    CONSTRAINT uq_plano_dia             UNIQUE (plano_treino_idplano_treino, dia_da_semana)
);

-- =============================================================
-- DIA EXERCÍCIO (entidade associativa dia_treino x exercicio)
-- =============================================================

CREATE TABLE dia_exercicio (
    iddia_exercicio             INT             NOT NULL AUTO_INCREMENT,
    repeticoes_planejadas       INT             NOT NULL,
    series_planejadas           INT             NOT NULL,
    peso_atual                  DECIMAL(5,2)    NOT NULL DEFAULT 0,
    ordem                       INT             NOT NULL,
    dia_treino_iddia_treino     INT             NOT NULL,
    exercicio_idexercicio       INT             NOT NULL,
    CONSTRAINT pk_dia_exercicio         PRIMARY KEY (iddia_exercicio),
    CONSTRAINT fk_dia_exercicio_dia     FOREIGN KEY (dia_treino_iddia_treino)
        REFERENCES dia_treino (iddia_treino),
    CONSTRAINT fk_dia_exercicio_ex      FOREIGN KEY (exercicio_idexercicio)
        REFERENCES exercicio (idexercicio),
    CONSTRAINT ck_series_planejadas     CHECK (series_planejadas > 0),
    CONSTRAINT ck_repeticoes_planejadas CHECK (repeticoes_planejadas > 0),
    CONSTRAINT ck_peso_atual            CHECK (peso_atual >= 0)
);

-- =============================================================
-- SESSÃO
-- =============================================================

CREATE TABLE sessao (
    idsessao                    INT         NOT NULL AUTO_INCREMENT,
    hora_inicio                 TIME        NOT NULL,
    hora_fim                    TIME,
    data                        DATE        NOT NULL,
    duracao_minutos             INT,
    usuario_id_usuario          INT         NOT NULL,
    dia_treino_iddia_treino     INT         NOT NULL,
    CONSTRAINT pk_sessao                PRIMARY KEY (idsessao),
    CONSTRAINT fk_sessao_usuario        FOREIGN KEY (usuario_id_usuario)
        REFERENCES usuario (id_usuario),
    CONSTRAINT fk_sessao_dia_treino     FOREIGN KEY (dia_treino_iddia_treino)
        REFERENCES dia_treino (iddia_treino),
    CONSTRAINT ck_duracao_minutos       CHECK (duracao_minutos IS NULL OR duracao_minutos > 0)
);

-- =============================================================
-- EXERCÍCIO EXECUTADO
-- =============================================================

CREATE TABLE exercicio_executado (
    idexercicio_executado           INT             NOT NULL AUTO_INCREMENT,
    series_realizadas               INT             NOT NULL,
    peso_utilizado                  DECIMAL(5,2)    NOT NULL,
    repeticoes_realizadas           INT             NOT NULL,
    data                            DATE            NOT NULL,
    sessao_idsessao                 INT             NOT NULL,
    dia_exercicio_iddia_exercicio   INT             NOT NULL,
    CONSTRAINT pk_exercicio_executado       PRIMARY KEY (idexercicio_executado),
    CONSTRAINT fk_exec_sessao               FOREIGN KEY (sessao_idsessao)
        REFERENCES sessao (idsessao),
    CONSTRAINT fk_exec_dia_exercicio        FOREIGN KEY (dia_exercicio_iddia_exercicio)
        REFERENCES dia_exercicio (iddia_exercicio),
    CONSTRAINT ck_series_realizadas         CHECK (series_realizadas > 0),
    CONSTRAINT ck_repeticoes_realizadas     CHECK (repeticoes_realizadas > 0),
    CONSTRAINT ck_peso_utilizado            CHECK (peso_utilizado > 0)
);