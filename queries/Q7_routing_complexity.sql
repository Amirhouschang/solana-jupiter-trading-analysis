-- Q7: Routing complexity by token category, H1 2026
-- Purpose: measure how many DEX legs Jupiter uses per user swap, by category.
-- Note: complexity is assigned per transaction, not per event. Each transaction
--   is counted once, under the category of its most-traded output token.
--   The earlier per-event version double-counted multi-token transactions.
-- Note: exact counts throughout — no approx_distinct needed at this grain.
-- Note: swap_events counts only the legs of the dominant category, so the sum
--   across categories is lower than the project total in Q1. legs_per_swap is
--   the metric here; the raw counts are context.
WITH categories AS (
    SELECT * FROM query_8725347
),
legs AS (
    SELECT
        s.evt_tx_id,
        CASE
            WHEN c.category IS NOT NULL      THEN c.category
            WHEN s.output_mint LIKE '%pump'  THEN 'Meme Coin'
            WHEN s.output_mint LIKE '%bonk'  THEN 'Meme Coin'
            ELSE 'Unmapped'
        END                                  AS category
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    LEFT JOIN categories c
      ON s.output_mint = c.token_mint
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
),
per_tx AS (
    SELECT
        evt_tx_id,
        category,
        COUNT(*)                                        AS legs_in_tx,
        ROW_NUMBER() OVER (
            PARTITION BY evt_tx_id
            ORDER BY COUNT(*) DESC, category
        )                                               AS rn
    FROM legs
    GROUP BY 1, 2
),
dominant AS (
    SELECT evt_tx_id, category, legs_in_tx
    FROM per_tx
    WHERE rn = 1
)
SELECT
    category,
    COUNT(*)                                            AS user_swaps,
    SUM(legs_in_tx)                                     AS swap_events,
    SUM(legs_in_tx) * 1.0 / COUNT(*)                    AS legs_per_swap
FROM dominant
GROUP BY 1
ORDER BY legs_per_swap DESC
