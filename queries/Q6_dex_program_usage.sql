-- Q6: DEX programs used by Jupiter v6, H1 2026
-- Purpose: show which underlying DEXes Jupiter routes through and how broad
--   each one's token coverage is.
-- Note: `amm` is the DEX program address, not an individual pool — 89 distinct
--   values across the period. Pool-level detail is not available in this table.
-- Note: names joined from Q6b (query_8725809), which covers the top 20;
--   the remaining 69 programs show as 'Unmapped'.
WITH dex_names AS (
    SELECT * FROM query_8725809
)
SELECT
    COALESCE(n.dex_name, 'Unmapped')                AS dex_name,
    s.amm                                           AS dex_program,
    COUNT(*)                                        AS swap_events,
    approx_distinct(s.evt_tx_id)                    AS user_swaps,
    approx_distinct(s.output_mint)                  AS distinct_tokens,
    approx_distinct(s.evt_tx_signer)                AS traders,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()        AS pct_of_swap_events
FROM jupiter_v6_solana.jupiter_evt_swapevent s
LEFT JOIN dex_names n
  ON s.amm = n.dex_program
WHERE s.evt_block_date >= DATE '2026-01-01'
  AND s.evt_block_date <  DATE '2026-07-01'
GROUP BY 1, 2
ORDER BY swap_events DESC
