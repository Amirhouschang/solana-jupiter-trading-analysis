-- C2: Fee event coverage by token category, H1 2026
-- Purpose: establish what share of transactions in each category carries a
--   recorded Jupiter fee event. Q8 further filters this subset for pricing.
--   C2 is fee-event coverage, not the final share of transactions used by Q8.
-- Result: coverage ranges from 7.92% (Native Solana) to 0.51% (Cross-Chain
--   Asset) — a factor of 15. Other has none at all. Whether the covered subset
--   is representative of each category cannot be established from this data.
-- Note: transactions are assigned to a single category as in Q7 and Q8.
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
        END AS category
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    LEFT JOIN categories c ON s.output_mint = c.token_mint
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
),
ranked AS (
    SELECT
        evt_tx_id,
        category,
        ROW_NUMBER() OVER (PARTITION BY evt_tx_id ORDER BY COUNT(*) DESC, category) AS rn
    FROM legs
    GROUP BY 1, 2
),
tx_category AS (
    SELECT evt_tx_id, category FROM ranked WHERE rn = 1
),
tx_fees AS (
    SELECT DISTINCT evt_tx_id
    FROM jupiter_v6_solana.jupiter_evt_feeevent
    WHERE evt_block_date >= DATE '2026-01-01'
    )
SELECT
    t.category,
    COUNT(*)                                AS all_tx,
    COUNT(f.evt_tx_id)                      AS tx_with_fee,
    COUNT(f.evt_tx_id) * 100.0 / COUNT(*)   AS pct_with_fee
FROM tx_category t
LEFT JOIN tx_fees f ON t.evt_tx_id = f.evt_tx_id
GROUP BY 1
ORDER BY all_tx DESC
