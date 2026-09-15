-- Q9: Category composition over time, weekly, H1 2026
-- Purpose: show how the mix of traded assets shifts across the period.
-- Note: same categorisation as Q5 (Q4 mapping + suffix rule).
-- Note: percentages are within-week shares, so each week sums to 100%.
--   This makes behavioural shifts visible independently of total market size.
-- Note: the period spans 27 weekly intervals; the first and last are partial.
--   Their shares cover only the days included in H1 2026.
-- Note: output tokens include intermediate routing tokens.
WITH categories AS (
    SELECT * FROM query_8725347
),
swaps AS (
    SELECT
        DATE_TRUNC('week', s.evt_block_time)    AS week,
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
)
SELECT
    week,
    category,
    COUNT(*)                                            AS swap_events,
    COUNT(*) * 100.0
      / SUM(COUNT(*)) OVER (PARTITION BY week)          AS pct_of_week
FROM swaps
GROUP BY 1, 2
ORDER BY week, swap_events DESC
