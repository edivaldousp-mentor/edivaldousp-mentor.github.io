-- Curso Do Excel ao SQL — todas as consultas, na ordem do curso.
-- Banco: vendas.db (SQLite). Rode uma consulta por vez.



-- ======================================================
-- Módulo 0 — Da planilha para a tabela
-- ======================================================


-- ======================================================
-- Módulo 1 — SELECT e FROM
-- ======================================================

SELECT *
FROM vendas
LIMIT 5;

SELECT
    id_venda,
    data_venda,
    quantidade,
    valor_venda AS receita,
    margem_valor AS margem
FROM vendas
LIMIT 6;

SELECT DISTINCT canal_venda
FROM vendas;


-- ======================================================
-- Módulo 2 — WHERE: o filtro
-- ======================================================

SELECT id_venda, data_venda, valor_venda
FROM vendas
WHERE valor_venda > 20000
LIMIT 6;

SELECT id_venda, canal_venda, quantidade, desconto_pct, valor_venda
FROM vendas
WHERE canal_venda = 'E-commerce'
  AND desconto_pct > 0.10
  AND status_pedido = 'Concluida'
LIMIT 6;

SELECT COUNT(*) AS com_parenteses
FROM vendas
WHERE (forma_pagamento = 'Pix' OR forma_pagamento = 'Boleto')
  AND valor_venda > 10000;

SELECT COUNT(*) AS sem_parenteses
FROM vendas
WHERE forma_pagamento = 'Pix' OR forma_pagamento = 'Boleto'
  AND valor_venda > 10000;

SELECT id_venda, canal_venda, forma_pagamento, valor_venda, observacao
FROM vendas
WHERE canal_venda IN ('Loja Fisica', 'Aplicativo')
  AND valor_venda BETWEEN 5000 AND 8000
  AND observacao IS NOT NULL
LIMIT 6;

SELECT
    COUNT(*)                                        AS total_de_linhas,
    SUM(CASE WHEN observacao IS NULL THEN 1 ELSE 0 END) AS jeito_certo,
    SUM(CASE WHEN observacao =  NULL THEN 1 ELSE 0 END) AS jeito_errado
FROM vendas;


-- ======================================================
-- Módulo 3 — ORDER BY e LIMIT
-- ======================================================

SELECT id_venda, quantidade, valor_venda
FROM vendas
ORDER BY valor_venda DESC
LIMIT 6;

SELECT id_venda, canal_venda, status_pedido, valor_venda
FROM vendas
ORDER BY canal_venda ASC, valor_venda DESC
LIMIT 8;


-- ======================================================
-- Módulo 4 — A ordem em que o SQL pensa
-- ======================================================

SELECT
    id_venda,
    valor_venda - custo_total AS margem
FROM vendas
WHERE valor_venda - custo_total > 8000
ORDER BY margem DESC
LIMIT 5;


-- ======================================================
-- Módulo 5 — Contas e o SE()
-- ======================================================

SELECT
    id_venda,
    quantidade,
    preco_unitario,
    valor_venda,
    custo_total,
    valor_venda - custo_total                          AS margem_reais,
    ROUND((valor_venda - custo_total) / valor_venda, 4) AS margem_pct
FROM vendas
LIMIT 6;

SELECT
    id_venda,
    valor_venda,
    CASE WHEN valor_venda > 5000 THEN 'Alto' ELSE 'Baixo' END AS porte
FROM vendas
LIMIT 6;

SELECT
    id_venda,
    ROUND(margem_valor / valor_venda, 3) AS margem_pct,
    CASE
        WHEN margem_valor / valor_venda <  0     THEN 'Prejuizo'
        WHEN margem_valor / valor_venda <  0.15  THEN 'Margem baixa'
        WHEN margem_valor / valor_venda <  0.30  THEN 'Margem media'
        ELSE                                          'Margem alta'
    END AS classe_margem
FROM vendas
ORDER BY margem_pct
LIMIT 6;

SELECT
    id_venda,
    observacao                             AS original,
    COALESCE(observacao, 'sem observacao') AS tratado
FROM vendas
ORDER BY observacao IS NOT NULL, id_venda
LIMIT 5;

SELECT
    canal_venda,
    COUNT(*)                                                          AS pedidos,
    SUM(CASE WHEN status_pedido = 'Cancelada' THEN 1 ELSE 0 END)      AS cancelados,
    ROUND(COALESCE(
        SUM(CASE WHEN status_pedido = 'Cancelada' THEN 1 ELSE 0 END) * 1.0
        / NULLIF(COUNT(*), 0), 0), 4)                                 AS taxa_cancelamento
FROM vendas
GROUP BY canal_venda
ORDER BY taxa_cancelamento DESC;


-- ======================================================
-- Módulo 6 — GROUP BY: a tabela dinâmica
-- ======================================================

SELECT
    c.regiao,
    SUM(v.valor_venda) AS receita
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.regiao
ORDER BY receita DESC;

SELECT
    canal_venda,
    COUNT(*)                        AS pedidos,
    COUNT(DISTINCT id_cliente)      AS clientes_distintos,
    ROUND(SUM(valor_venda), 2)      AS receita,
    ROUND(AVG(valor_venda), 2)      AS ticket_medio,
    ROUND(MAX(valor_venda), 2)      AS maior_venda
FROM vendas
GROUP BY canal_venda
ORDER BY receita DESC;

SELECT
    COUNT(*)                    AS linhas,
    COUNT(observacao)           AS com_observacao,
    COUNT(DISTINCT observacao)  AS observacoes_distintas
FROM vendas;

SELECT
    c.regiao,
    v.canal_venda,
    COUNT(*)                   AS pedidos,
    ROUND(SUM(v.valor_venda))  AS receita
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.regiao, v.canal_venda
ORDER BY c.regiao, receita DESC
LIMIT 8;


-- ======================================================
-- Módulo 7 — HAVING: filtrar depois de somar
-- ======================================================

SELECT
    d.nome                      AS vendedor,
    COUNT(*)                    AS pedidos,
    ROUND(SUM(v.valor_venda))   AS receita
FROM vendas v
JOIN vendedores d ON v.id_vendedor = d.id_vendedor
GROUP BY d.nome
HAVING SUM(v.valor_venda) > 4000000
ORDER BY receita DESC;

SELECT
    p.categoria,
    COUNT(*)                                        AS pedidos,
    ROUND(SUM(v.valor_venda))                       AS receita,
    ROUND(AVG(v.desconto_pct), 4)                   AS desconto_medio
FROM vendas v
JOIN produtos p ON v.id_produto = p.id_produto
WHERE v.status_pedido = 'Concluida'          -- filtra LINHA: só pedidos concluídos
  AND v.data_venda >= '2025-01-01'
GROUP BY p.categoria
HAVING COUNT(*) > 500                        -- filtra GRUPO: só categorias com volume
ORDER BY receita DESC;


-- ======================================================
-- Módulo 8 — JOIN: o PROCV que traz a tabela inteira
-- ======================================================

SELECT
    v.id_venda,
    v.data_venda,
    c.nome        AS cliente,
    c.segmento,
    c.cidade,
    c.regiao,
    v.valor_venda
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
LIMIT 6;

SELECT
    m.regiao,
    m.meta_anual,
    COUNT(v.id_venda) AS vendas_encontradas
FROM metas m
LEFT JOIN clientes c ON c.regiao   = m.regiao
LEFT JOIN vendas   v ON v.id_cliente = c.id_cliente
                    AND CAST(strftime('%Y', v.data_venda) AS INTEGER) = m.ano
WHERE m.ano = 2025
GROUP BY m.regiao, m.meta_anual
ORDER BY vendas_encontradas DESC;

SELECT m.regiao, m.ano, m.meta_anual
FROM metas m
LEFT JOIN clientes c ON c.regiao = m.regiao
WHERE c.regiao IS NULL;

SELECT
    v.id_venda,
    v.data_venda,
    c.nome        AS cliente,
    c.regiao,
    p.categoria,
    p.subproduto,
    d.nome        AS vendedor,
    d.gerente,
    v.valor_venda
FROM vendas v
JOIN clientes   c ON v.id_cliente  = c.id_cliente
JOIN produtos   p ON v.id_produto  = p.id_produto
JOIN vendedores d ON v.id_vendedor = d.id_vendedor
WHERE v.valor_venda > 25000
ORDER BY v.valor_venda DESC
LIMIT 6;

SELECT
    (SELECT COUNT(*) FROM vendas)                                     AS antes_do_join,
    (SELECT COUNT(*) FROM vendas v JOIN clientes c
        ON v.id_cliente = c.id_cliente)                               AS depois_do_join;


-- ======================================================
-- Módulo 9 — Datas
-- ======================================================

SELECT
    id_venda,
    data_venda,
    strftime('%Y', data_venda)     AS ano,
    strftime('%m', data_venda)     AS mes,
    strftime('%Y-%m', data_venda)  AS ano_mes,
    DATE(data_venda, '+30 days')   AS vence_em
FROM vendas
LIMIT 6;

SELECT
    strftime('%Y-%m', data_venda)  AS mes,
    COUNT(*)                       AS pedidos,
    ROUND(SUM(valor_venda))        AS receita
FROM vendas
GROUP BY mes
ORDER BY mes
LIMIT 8;

SELECT
    strftime('%Y-%m', data_venda) AS mes,
    ROUND(SUM(valor_venda))       AS receita
FROM vendas
WHERE data_venda BETWEEN '2025-10-01' AND '2025-12-31'
GROUP BY mes
ORDER BY mes;


-- ======================================================
-- Módulo 10 — Subconsulta e CTE: a aba auxiliar
-- ======================================================

SELECT
    canal_venda,
    ROUND(AVG(receita_do_pedido), 2) AS ticket_medio
FROM (
    SELECT canal_venda, valor_venda AS receita_do_pedido
    FROM vendas
    WHERE status_pedido = 'Concluida'
) AS base
GROUP BY canal_venda
ORDER BY ticket_medio DESC;

WITH receita_mensal AS (
    SELECT
        strftime('%Y-%m', data_venda) AS mes,
        SUM(valor_venda)              AS receita
    FROM vendas
    WHERE status_pedido = 'Concluida'
    GROUP BY mes
),
media_geral AS (
    SELECT AVG(receita) AS media FROM receita_mensal
)
SELECT
    r.mes,
    ROUND(r.receita)                       AS receita,
    ROUND(m.media)                         AS media_do_periodo,
    ROUND(r.receita / m.media - 1, 3)      AS variacao_vs_media
FROM receita_mensal r
CROSS JOIN media_geral m
ORDER BY variacao_vs_media DESC
LIMIT 6;

SELECT
    c.nome AS cliente,
    COUNT(*)                  AS pedidos,
    ROUND(SUM(v.valor_venda)) AS receita
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.id_cliente IN (
    SELECT id_cliente
    FROM vendas
    GROUP BY id_cliente
    HAVING SUM(valor_venda) > 250000
)
GROUP BY c.nome
ORDER BY receita DESC
LIMIT 6;


-- ======================================================
-- Módulo 11 — Funções de janela
-- ======================================================

SELECT
    regiao,
    vendedor,
    receita,
    posicao
FROM (
    SELECT
        d.regiao,
        d.nome                     AS vendedor,
        ROUND(SUM(v.valor_venda))  AS receita,
        ROW_NUMBER() OVER (PARTITION BY d.regiao ORDER BY SUM(v.valor_venda) DESC) AS posicao
    FROM vendas v
    JOIN vendedores d ON v.id_vendedor = d.id_vendedor
    GROUP BY d.regiao, d.nome
) AS ranqueado
WHERE posicao <= 2
ORDER BY regiao, posicao;

SELECT
    strftime('%Y-%m', data_venda)                                        AS mes,
    ROUND(SUM(valor_venda))                                              AS receita,
    ROUND(SUM(SUM(valor_venda)) OVER (ORDER BY strftime('%Y-%m', data_venda))) AS acumulado,
    ROUND(SUM(valor_venda) * 100.0 / SUM(SUM(valor_venda)) OVER (), 2)   AS pct_do_total
FROM vendas
GROUP BY mes
ORDER BY mes
LIMIT 8;

WITH mensal AS (
    SELECT strftime('%Y-%m', data_venda) AS mes, SUM(valor_venda) AS receita
    FROM vendas
    GROUP BY mes
)
SELECT
    mes,
    ROUND(receita)                                          AS receita,
    ROUND(LAG(receita) OVER (ORDER BY mes))                 AS mes_anterior,
    ROUND(receita - LAG(receita) OVER (ORDER BY mes))       AS variacao_reais,
    ROUND((receita / LAG(receita) OVER (ORDER BY mes) - 1) * 100, 1) AS variacao_pct
FROM mensal
ORDER BY mes
LIMIT 8;

WITH mensal AS (
    SELECT strftime('%Y-%m', data_venda) AS mes, SUM(valor_venda) AS receita
    FROM vendas
    GROUP BY mes
)
SELECT
    mes,
    ROUND(receita) AS receita,
    ROUND(AVG(receita) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS media_movel_3m
FROM mensal
ORDER BY mes
LIMIT 8;


-- ======================================================
-- Módulo 12 — A tabela dinâmica de verdade
-- ======================================================

SELECT
    c.regiao,
    ROUND(SUM(CASE WHEN p.categoria = 'Eletronicos'      THEN v.valor_venda ELSE 0 END)) AS eletronicos,
    ROUND(SUM(CASE WHEN p.categoria = 'Eletrodomesticos' THEN v.valor_venda ELSE 0 END)) AS eletrodom,
    ROUND(SUM(CASE WHEN p.categoria = 'Moveis'           THEN v.valor_venda ELSE 0 END)) AS moveis,
    ROUND(SUM(CASE WHEN p.categoria = 'Vestuario'        THEN v.valor_venda ELSE 0 END)) AS vestuario,
    ROUND(SUM(CASE WHEN p.categoria = 'Esporte e Lazer'  THEN v.valor_venda ELSE 0 END)) AS esporte,
    ROUND(SUM(v.valor_venda))                                                            AS total
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN produtos p ON v.id_produto = p.id_produto
GROUP BY c.regiao
ORDER BY total DESC;


-- ======================================================
-- Módulo 13 — Exercícios
-- ======================================================


-- ======================================================
-- Cola de bolso: Excel → SQL
-- ======================================================
