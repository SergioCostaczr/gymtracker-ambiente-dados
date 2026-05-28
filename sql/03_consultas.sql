USE gymtracker;

-- =============================================================
-- SEÇÃO 1: JOINs
-- =============================================================

-- 1.1 INNER JOIN
-- Relatório de todas as sessões realizadas com nome do usuário e dia de treino
SELECT
    u.nome                  AS usuario,
    u.objetivo,
    dt.dia_da_semana        AS dia,
    s.data,
    s.hora_inicio,
    s.hora_fim,
    s.duracao_minutos
FROM sessao s
INNER JOIN usuario u
    ON s.usuario_id_usuario = u.id_usuario
INNER JOIN dia_treino dt
    ON s.dia_treino_iddia_treino = dt.iddia_treino
ORDER BY s.data, u.nome;

-- ---------------------------------------------------------------

-- 1.2 LEFT JOIN
-- Todos os usuários e suas sessões. Incluindo quem nunca treinou
SELECT
    u.nome                          AS usuario,
    u.objetivo,
    COUNT(s.idsessao)               AS total_sessoes,
    SUM(s.duracao_minutos)          AS total_minutos_treinados
FROM usuario u
LEFT JOIN sessao s
    ON s.usuario_id_usuario = u.id_usuario
GROUP BY u.id_usuario, u.nome, u.objetivo
ORDER BY total_sessoes DESC;

-- ---------------------------------------------------------------

-- 1.3 RIGHT JOIN
-- Todos os exercícios do catálogo e quantas vezes foram executados
-- (inclui exercícios que nunca foram usados)
SELECT
    e.nome                          AS exercicio,
    gm.nome                         AS grupo_muscular,
    eq.nome                         AS equipamento,
    COUNT(ee.idexercicio_executado)  AS vezes_executado
FROM exercicio_executado ee
RIGHT JOIN dia_exercicio de
    ON ee.dia_exercicio_iddia_exercicio = de.iddia_exercicio
RIGHT JOIN exercicio e
    ON de.exercicio_idexercicio = e.idexercicio
INNER JOIN grupo_muscular gm
    ON e.grupo_muscular_idgrupo_muscular = gm.idgrupo_muscular
INNER JOIN equipamento eq
    ON e.equipamento_idequipamento = eq.idequipamento
GROUP BY e.idexercicio, e.nome, gm.nome, eq.nome
ORDER BY vezes_executado DESC;

-- =============================================================
-- SEÇÃO 2: UNION
-- =============================================================

-- 2.1 Relatório unificado de exercícios de Peito e Costas
-- com o nome do usuário que os executou e o peso utilizado
SELECT
    'Peito'             AS grupo,
    u.nome              AS usuario,
    e.nome              AS exercicio,
    ee.peso_utilizado,
    ee.data
FROM exercicio_executado ee
INNER JOIN dia_exercicio de
    ON ee.dia_exercicio_iddia_exercicio = de.iddia_exercicio
INNER JOIN exercicio e
    ON de.exercicio_idexercicio = e.idexercicio
INNER JOIN grupo_muscular gm
    ON e.grupo_muscular_idgrupo_muscular = gm.idgrupo_muscular
INNER JOIN sessao s
    ON ee.sessao_idsessao = s.idsessao
INNER JOIN usuario u
    ON s.usuario_id_usuario = u.id_usuario
WHERE gm.nome = 'Peito'

UNION

SELECT
    'Costas'            AS grupo,
    u.nome              AS usuario,
    e.nome              AS exercicio,
    ee.peso_utilizado,
    ee.data
FROM exercicio_executado ee
INNER JOIN dia_exercicio de
    ON ee.dia_exercicio_iddia_exercicio = de.iddia_exercicio
INNER JOIN exercicio e
    ON de.exercicio_idexercicio = e.idexercicio
INNER JOIN grupo_muscular gm
    ON e.grupo_muscular_idgrupo_muscular = gm.idgrupo_muscular
INNER JOIN sessao s
    ON ee.sessao_idsessao = s.idsessao
INNER JOIN usuario u
    ON s.usuario_id_usuario = u.id_usuario
WHERE gm.nome = 'Costas'

ORDER BY grupo, usuario, data;

-- =============================================================
-- SEÇÃO 3: SUBQUERIES COM EXISTS E IN
-- =============================================================

-- 3.1 EXISTS
-- Usuários que nunca realizaram nenhuma sessão de treino
SELECT
    u.nome,
    u.email,
    u.objetivo
FROM usuario u
WHERE NOT EXISTS (
    SELECT 1
    FROM sessao s
    WHERE s.usuario_id_usuario = u.id_usuario
);

-- ---------------------------------------------------------------

-- 3.2 IN
-- Exercícios do catálogo que nunca foram executados por nenhum usuário
SELECT
    e.nome              AS exercicio,
    gm.nome             AS grupo_muscular,
    eq.nome             AS equipamento
FROM exercicio e
INNER JOIN grupo_muscular gm
    ON e.grupo_muscular_idgrupo_muscular = gm.idgrupo_muscular
INNER JOIN equipamento eq
    ON e.equipamento_idequipamento = eq.idequipamento
WHERE e.idexercicio NOT IN (
    SELECT de.exercicio_idexercicio
    FROM dia_exercicio de
    INNER JOIN exercicio_executado ee
        ON ee.dia_exercicio_iddia_exercicio = de.iddia_exercicio
);
