-- Q8: Recorded fee rate by token category, H1 2026
-- Purpose: compare priced recorded fees with priced swap-event output volume
--   on transactions with at least one priced fee event and priced swap event.
--
-- METHOD
-- Fees and volume are both assigned at transaction level, to the same category.
-- An earlier version categorised fees by the fee token and volume by the output
-- token independently. A check showed those disagree in roughly three quarters
-- of cases — the largest single group was a fee paid in a stablecoin on a SOL
-- purchase — so the resulting ratio did not describe the cost of trading a
-- category at all.
--
-- Each transaction is assigned to one category: the one with the most swap
-- events in that transaction. Ties are broken alphabetically. Fees and volume
-- of that transaction then both count towards that category.
--
-- COVERAGE — read before interpreting the ratio
-- Jupiter does not record a fee event on every route. The share of transactions
-- carrying one varies sharply by category: 7.92% for Native Solana, 2.32% for
-- Liquid Staking, 1.36% for Stablecoin, 0.65% for Meme Coin, 0.51% for
-- Cross-Chain Asset, and none at all for Other (see C2).
-- The ratio below therefore describes the transactions where a fee was recorded,
-- not the category as a whole. Whether that subset is representative — and
-- whether it is representative to the same degree across categories — cannot be
-- established from this data. Read the ranking as an observation about recorded
-- fee events, not as a measured cost of trading each category.
--
-- Note: fees are charged in the traded token, volume is measured on the output
--   token. Both are decimal-adjusted and priced from Dune's daily price table.
-- Note: sums include priced events only; some events in an included transaction
--   may remain unpriced. Q8 inclusion is smaller than C2 fee-event coverage:
--   0.12–7.85% of category transactions.
-- Note: volume sums all priced event outputs, including intermediate hops;
--   it is not final user-order value. The ratio is fees / event-output volume.
-- Note: absolute totals here are not comparable to Q1; only the ratio is
--   intended for comparison, within the limits stated above.
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
ranked AS (
    SELECT
        evt_tx_id,
        category,
        ROW_NUMBER() OVER (
            PARTITION BY evt_tx_id
            ORDER BY COUNT(*) DESC, category
        )                                    AS rn
    FROM legs
    GROUP BY 1, 2
),
tx_category AS (
    SELECT evt_tx_id, category
    FROM ranked
    WHERE rn = 1
),
tx_volume AS (
    SELECT
        s.evt_tx_id,
        SUM((s.output_amount / POWER(10, p.decimals)) * p.price)    AS volume_usd
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    JOIN prices.day p
      ON p.contract_address = from_base58(s.output_mint)
     AND p.timestamp        = s.evt_block_date
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
      AND p.blockchain = 'solana'
    GROUP BY 1
),
tx_fees AS (
    SELECT
        f.evt_tx_id,
        SUM((f.amount / POWER(10, p.decimals)) * p.price)           AS fee_usd
    FROM jupiter_v6_solana.jupiter_evt_feeevent f
    JOIN prices.day p
      ON p.contract_address = from_base58(f.mint)
     AND p.timestamp        = f.evt_block_date
    WHERE f.evt_block_date >= DATE '2026-01-01'
      AND f.evt_block_date <  DATE '2026-07-01'
      AND p.blockchain = 'solana'
    GROUP BY 1
)
SELECT
    t.category,
    COUNT(*)                                        AS transactions,
    SUM(f.fee_usd)                                  AS total_fees_usd,
    SUM(v.volume_usd)                               AS volume_usd,
    SUM(f.fee_usd) / COUNT(*)                       AS avg_fee_usd,
    SUM(f.fee_usd) * 10000.0
      / NULLIF(SUM(v.volume_usd), 0)                AS fee_bps
FROM tx_category t
JOIN tx_fees   f ON t.evt_tx_id = f.evt_tx_id
JOIN tx_volume v ON t.evt_tx_id = v.evt_tx_id
GROUP BY 1
ORDER BY fee_bps DESC
