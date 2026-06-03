-- =============================================================
-- GymTracker - Script DML (Povoamento)
-- =============================================================

USE gymtracker;

-- =============================================================
-- GRUPOS MUSCULARES
-- =============================================================

INSERT INTO grupo_muscular (nome) VALUES
    ('Peito'),
    ('Costas'),
    ('Ombro'),
    ('Bíceps'),
    ('Tríceps'),
    ('Perna'),
    ('Abdômen');

-- =============================================================
-- EQUIPAMENTOS
-- =============================================================

INSERT INTO equipamento (nome) VALUES
    ('Halter'),
    ('Barra'),
    ('Polia'),
    ('Máquina'),
    ('Peso Corporal');

-- =============================================================
-- USUÁRIOS
-- =============================================================

INSERT INTO usuario (nome, email, senha, objetivo, altura, peso) VALUES
    ('Carlos Mendes',    'carlos@email.com',   '$2a$10$hash1', 'HIPERTROFIA',    1.78, 82.50),
    ('Fernanda Lima',    'fernanda@email.com', '$2a$10$hash2', 'EMAGRECIMENTO',  1.65, 68.00),
    ('Rafael Souza',     'rafael@email.com',   '$2a$10$hash3', 'HIPERTROFIA',    1.82, 90.00),
    ('Juliana Costa',    'juliana@email.com',  '$2a$10$hash4', 'CONDICIONAMENTO',1.60, 58.50),
    ('Bruno Alves',      'bruno@email.com',    '$2a$10$hash5', 'REABILITAÇÃO',   1.75, 77.00);

-- =============================================================
-- HISTÓRICO DE PESO CORPORAL
-- =============================================================

INSERT INTO historico_peso_usuario (peso, data_registro, usuario_id_usuario) VALUES
    (85.00, '2025-01-01', 1),
    (84.00, '2025-02-01', 1),
    (82.50, '2025-03-01', 1),
    (72.00, '2025-01-01', 2),
    (70.00, '2025-02-01', 2),
    (68.00, '2025-03-01', 2),
    (92.00, '2025-01-01', 3),
    (91.00, '2025-02-01', 3),
    (90.00, '2025-03-01', 3),
    (60.00, '2025-01-01', 4),
    (59.00, '2025-02-01', 4),
    (58.50, '2025-03-01', 4),
    (80.00, '2025-01-01', 5),
    (78.50, '2025-02-01', 5),
    (77.00, '2025-03-01', 5);

-- =============================================================
-- EXERCÍCIOS
-- =============================================================

-- Peito (idgrupo=1) 
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Supino Reto com Barra',   'Deitar no banco, segurar a barra na largura dos ombros e empurrar verticalmente.',           1, 2),
    ('Supino Reto com Halter',  'Deitar no banco, segurar os halteres e empurrar verticalmente de forma simétrica.',          1, 1),
    ('Crucifixo',               'Deitar no banco, abrir os braços com leve flexão nos cotovelos e fechar em arco.',           1, 1);

-- Costas (idgrupo=2)
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Puxada Alta',             'Sentado na máquina, puxar a barra até a altura do queixo com pegada aberta.',                2, 3),
    ('Remada Curvada',          'Em pé inclinado, puxar a barra em direção ao abdômen mantendo a coluna neutra.',             2, 2);

-- Ombro (idgrupo=3)
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Desenvolvimento com Halter', 'Sentado, empurrar os halteres acima da cabeça de forma alternada ou simultânea.',        3, 1);

-- Bíceps (idgrupo=4)
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Rosca Direta',            'Em pé, segurar a barra com pegada supinada e flexionar os cotovelos.',                       4, 2);

-- Tríceps (idgrupo=5)
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Tríceps Polia Alta',      'De frente para a polia, empurrar o cabo para baixo estendendo completamente os cotovelos.',  5, 3);

-- Perna (idgrupo=6)
INSERT INTO exercicio (nome, descricao, grupo_muscular_idgrupo_muscular, equipamento_idequipamento) VALUES
    ('Agachamento Livre',       'Em pé com a barra nos trapézios, flexionar os joelhos até a coxa ficar paralela ao chão.',   6, 2),
    ('Leg Press',               'Sentado na máquina, empurrar a plataforma até extensão quase completa dos joelhos.',         6, 4);

-- =============================================================
-- PLANOS DE TREINO (2 por usuário: 1 ativo, 1 inativo)
-- =============================================================

INSERT INTO plano_treino (nome, data_criacao, ativo, usuario_id_usuario) VALUES
    ('Treino A - Carlos',       '2025-01-10', 1, 1),
    ('Treino Antigo - Carlos',  '2024-06-01', 0, 1),
    ('Treino A - Fernanda',     '2025-02-01', 1, 2),
    ('Treino Antigo - Fernanda','2024-08-01', 0, 2),
    ('Treino A - Rafael',       '2025-01-15', 1, 3),
    ('Treino Antigo - Rafael',  '2024-07-01', 0, 3),
    ('Treino A - Juliana',      '2025-02-10', 1, 4),
    ('Treino Antigo - Juliana', '2024-09-01', 0, 4),
    ('Treino A - Bruno',        '2025-03-01', 1, 5),
    ('Treino Antigo - Bruno',   '2024-10-01', 0, 5);

-- =============================================================
-- DIAS DE TREINO (planos ativos: 1, 3, 5, 7, 9)
-- =============================================================

-- Carlos (plano 1): Seg=Peito/Tri, Qua=Costas/Bi, Sex=Perna
INSERT INTO dia_treino (dia_da_semana, plano_treino_idplano_treino) VALUES
    ('SEGUNDA', 1),
    ('QUARTA',  1),
    ('SEXTA',   1);

-- Fernanda (plano 3): Seg=Peito, Qua=Costas, Sex=Perna
INSERT INTO dia_treino (dia_da_semana, plano_treino_idplano_treino) VALUES
    ('SEGUNDA', 3),
    ('QUARTA',  3),
    ('SEXTA',   3);

-- Rafael (plano 5): Seg=Peito/Tri, Ter=Costas/Bi, Qui=Perna, Sab=Ombro
INSERT INTO dia_treino (dia_da_semana, plano_treino_idplano_treino) VALUES
    ('SEGUNDA', 5),
    ('TERCA',   5),
    ('QUINTA',  5),
    ('SABADO',  5);

-- Juliana (plano 7): Ter=Peito/Ombro, Qui=Costas/Bi, Sab=Perna
INSERT INTO dia_treino (dia_da_semana, plano_treino_idplano_treino) VALUES
    ('TERCA',   7),
    ('QUINTA',  7),
    ('SABADO',  7);

-- Bruno (plano 9): Seg=Peito, Qui=Costas, Sab=Perna
INSERT INTO dia_treino (dia_da_semana, plano_treino_idplano_treino) VALUES
    ('SEGUNDA', 9),
    ('QUINTA',  9),
    ('SABADO',  9);

-- =============================================================
-- DIA EXERCÍCIO
-- iddia_treino: 1=CarlosSeg, 2=CarlosQua, 3=CarlosSex
--               4=FernSeg,   5=FernQua,   6=FernSex
--               7=RafSeg,    8=RafTer,    9=RafQui,   10=RafSab
--              11=JulTer,   12=JulQui,   13=JulSab
--              14=BrunoSeg, 15=BrunoQui, 16=BrunoSab
-- =============================================================

-- Carlos - Segunda (Peito/Tríceps) - iddia_treino=1
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (10, 4, 80.00, 1, 1, 1),  -- Supino Reto Barra
    (12, 3, 24.00, 2, 1, 2),  -- Supino Reto Halter
    (12, 3,  8.00, 3, 1, 3),  -- Crucifixo
    (12, 3, 30.00, 4, 1, 8);  -- Tríceps Polia Alta

-- Carlos - Quarta (Costas/Bíceps) - iddia_treino=2
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (10, 4, 50.00, 1, 2, 4),  -- Puxada Alta
    (10, 4, 60.00, 2, 2, 5),  -- Remada Curvada
    (12, 3, 30.00, 3, 2, 7);  -- Rosca Direta

-- Carlos - Sexta (Perna) - iddia_treino=3
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (8,  4, 100.00, 1, 3, 9),  -- Agachamento Livre
    (12, 4, 150.00, 2, 3, 10); -- Leg Press

-- Fernanda - Segunda (Peito) - iddia_treino=4
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 40.00, 1, 4, 1),  -- Supino Reto Barra
    (12, 3, 10.00, 2, 4, 3);  -- Crucifixo

-- Fernanda - Quarta (Costas) - iddia_treino=5
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 35.00, 1, 5, 4),  -- Puxada Alta
    (12, 3, 40.00, 2, 5, 5);  -- Remada Curvada

-- Fernanda - Sexta (Perna) - iddia_treino=6
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 60.00, 1, 6, 9),  -- Agachamento
    (15, 3, 90.00, 2, 6, 10); -- Leg Press

-- Rafael - Segunda (Peito/Tríceps) - iddia_treino=7
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (8,  5, 100.00, 1, 7, 1),  -- Supino Reto Barra
    (10, 4,  30.00, 2, 7, 2),  -- Supino Halter
    (12, 3,  40.00, 3, 7, 8);  -- Tríceps Polia

-- Rafael - Terça (Costas/Bíceps) - iddia_treino=8
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (8,  5, 65.00, 1, 8, 4),  -- Puxada Alta
    (8,  5, 80.00, 2, 8, 5),  -- Remada Curvada
    (10, 4, 40.00, 3, 8, 7);  -- Rosca Direta

-- Rafael - Quinta (Perna) - iddia_treino=9
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (6,  5, 140.00, 1, 9, 9),   -- Agachamento
    (10, 4, 200.00, 2, 9, 10);  -- Leg Press

-- Rafael - Sábado (Ombro) - iddia_treino=10
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (10, 4, 20.00, 1, 10, 6);  -- Desenvolvimento Halter

-- Juliana - Terça (Peito/Ombro) - iddia_treino=11
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (15, 3, 20.00, 1, 11, 2),  -- Supino Halter
    (15, 3, 10.00, 2, 11, 6);  -- Desenvolvimento Halter

-- Juliana - Quinta (Costas/Bíceps) - iddia_treino=12
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 25.00, 1, 12, 4),  -- Puxada Alta
    (12, 3, 15.00, 2, 12, 7);  -- Rosca Direta

-- Juliana - Sábado (Perna) - iddia_treino=13
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (15, 3, 40.00, 1, 13, 9),  -- Agachamento
    (15, 3, 70.00, 2, 13, 10); -- Leg Press

-- Bruno - Segunda (Peito) - iddia_treino=14
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 50.00, 1, 14, 1),  -- Supino Barra
    (12, 3, 14.00, 2, 14, 3);  -- Crucifixo

-- Bruno - Quinta (Costas) - iddia_treino=15
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (12, 3, 40.00, 1, 15, 4),  -- Puxada Alta
    (12, 3, 50.00, 2, 15, 5);  -- Remada Curvada

-- Bruno - Sábado (Perna) - iddia_treino=16
INSERT INTO dia_exercicio (repeticoes_planejadas, series_planejadas, peso_atual, ordem, dia_treino_iddia_treino, exercicio_idexercicio) VALUES
    (10, 4, 70.00,  1, 16, 9),  -- Agachamento
    (12, 4, 110.00, 2, 16, 10); -- Leg Press

-- =============================================================
-- SESSÕES
-- =============================================================

INSERT INTO sessao (hora_inicio, hora_fim, data, duracao_minutos, usuario_id_usuario, dia_treino_iddia_treino) VALUES
    -- Carlos
    ('07:00:00', '08:05:00', '2025-03-03', 65, 1, 1),
    ('07:00:00', '07:55:00', '2025-03-05', 55, 1, 2),
    ('07:00:00', '08:10:00', '2025-03-07', 70, 1, 3),
    -- Fernanda
    ('06:30:00', '07:20:00', '2025-03-03', 50, 2, 4),
    ('06:30:00', '07:15:00', '2025-03-05', 45, 2, 5),
    ('06:30:00', '07:25:00', '2025-03-07', 55, 2, 6),
    -- Rafael
    ('18:00:00', '19:10:00', '2025-03-03', 70, 3, 7),
    ('18:00:00', '19:05:00', '2025-03-04', 65, 3, 8),
    ('18:00:00', '19:15:00', '2025-03-06', 75, 3, 9),
    ('09:00:00', '09:50:00', '2025-03-08', 50, 3, 10),
    -- Juliana
    ('07:00:00', '07:45:00', '2025-03-04', 45, 4, 11),
    ('07:00:00', '07:40:00', '2025-03-06', 40, 4, 12),
    -- Bruno (sessão sem hora_fim — treino ainda não finalizado)
    ('08:00:00', NULL, '2025-03-10', NULL, 5, 14);

-- =============================================================
-- EXERCÍCIOS EXECUTADOS
-- =============================================================

INSERT INTO exercicio_executado (series_realizadas, peso_utilizado, repeticoes_realizadas, data, sessao_idsessao, dia_exercicio_iddia_exercicio) VALUES
    -- Sessão 1 - Carlos Seg (Peito/Tri)
    (4, 80.00, 10, '2025-03-03', 1, 1),
    (3, 24.00, 12, '2025-03-03', 1, 2),
    (3,  8.00, 12, '2025-03-03', 1, 3),
    (3, 30.00, 12, '2025-03-03', 1, 4),
    -- Sessão 2 - Carlos Qua (Costas/Bi)
    (4, 50.00, 10, '2025-03-05', 2, 5),
    (4, 60.00, 10, '2025-03-05', 2, 6),
    (3, 30.00, 12, '2025-03-05', 2, 7),
    -- Sessão 3 - Carlos Sex (Perna)
    (4, 100.00, 8,  '2025-03-07', 3, 8),
    (4, 150.00, 12, '2025-03-07', 3, 9),
    -- Sessão 4 - Fernanda Seg (Peito)
    (3, 40.00, 12, '2025-03-03', 4, 10),
    (3, 10.00, 12, '2025-03-03', 4, 11),
    -- Sessão 5 - Fernanda Qua (Costas)
    (3, 35.00, 12, '2025-03-05', 5, 12),
    (3, 40.00, 12, '2025-03-05', 5, 13),
    -- Sessão 6 - Fernanda Sex (Perna)
    (3, 60.00, 12, '2025-03-07', 6, 14),
    (3, 90.00, 15, '2025-03-07', 6, 15),
    -- Sessão 7 - Rafael Seg (Peito/Tri)
    (5, 100.00, 8,  '2025-03-03', 7, 16),
    (4,  30.00, 10, '2025-03-03', 7, 17),
    (3,  40.00, 12, '2025-03-03', 7, 18),
    -- Sessão 8 - Rafael Ter (Costas/Bi)
    (5, 65.00, 8,  '2025-03-04', 8, 19),
    (5, 80.00, 8,  '2025-03-04', 8, 20),
    (4, 40.00, 10, '2025-03-04', 8, 21),
    -- Sessão 9 - Rafael Qui (Perna)
    (5, 140.00, 6,  '2025-03-06', 9, 22),
    (4, 200.00, 10, '2025-03-06', 9, 23),
    -- Sessão 10 - Rafael Sab (Ombro)
    (4, 20.00, 10, '2025-03-08', 10, 24),
    -- Sessão 11 - Juliana Ter (Peito/Ombro)
    (3, 20.00, 15, '2025-03-04', 11, 25),
    (3, 10.00, 15, '2025-03-04', 11, 26),
    -- Sessão 12 - Juliana Qui (Costas/Bi)
    (3, 25.00, 12, '2025-03-06', 12, 27),
    (3, 15.00, 12, '2025-03-06', 12, 28);
