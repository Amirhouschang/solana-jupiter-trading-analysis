-- C1: Coverage check — share of swap events covered by top N tokens
-- Purpose: justify limiting manual categorisation to the top 100 tokens.
-- Result: top 100 cover 88.1%, top 500 cover 91.9% of all swap events.
WITH ranked AS (
    SELECT
        output_mint,
        COUNT(*) AS swap_events,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM jupiter_v6_solana.jupiter_evt_swapevent
    WHERE evt_block_date >= DATE '2026-01-01'
      AND evt_block_date <  DATE '2026-07-01'
    GROUP BY 1
)
SELECT
    SUM(CASE WHEN rn <= 100 THEN swap_events ELSE 0 END) * 100.0 / SUM(swap_events) AS pct_top_100,
    SUM(CASE WHEN rn <= 500 THEN swap_events ELSE 0 END) * 100.0 / SUM(swap_events) AS pct_top_500
FROM ranked
