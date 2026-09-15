-- Q8: Jupiter protocol fee efficiency by token category, H1 2026
-- Purpose: measure how much protocol fee is paid per dollar of volume traded.
--   This is the metric that makes categories comparable — absolute fees only
--   reflect how large a category is.
-- Note: this is Jupiter's own protocol fee from jupiter_evt_feeevent, not the
--   Solana network fee. The two are different costs and are never combined.
-- Note: fees are charged in the token itself; volume is measured on the output
--   token. Both are decimal-adjusted and priced at the daily close.
-- Note: only rows whose token has price data are included, so coverage mirrors
--   Q3: strong for stablecoins and native assets, weak for meme coins.
-- Note: fee events are far rarer than swap events — Jupiter does not charge a
--   protocol fee on every route. fee_events is therefore not comparable to
--   swap counts elsewhere in the project.
-- Note: 'Unmapped' shows the highest fee rate. It holds long-tail tokens the
--   suffix rule does not catch, likely including further meme coins — so the
--   true meme coin figure is probably higher than the 0.515 bps shown.
WITH categories AS (
    SELECT * FROM query_8725347
),
categorised_fees AS (
    SELECT
        CASE
            WHEN c.category IS NOT NULL      THEN c.category
            WHEN f.mint LIKE '%pump'         THEN 'Meme Coin'
            WHEN f.mint LIKE '%bonk'         THEN 'Meme Coin'
            ELSE 'Unmapped'
        END                                             AS token_category,
        (f.amount / POWER(10, p.decimals)) * p.price     AS fee_usd
    FROM jupiter_v6_solana.jupiter_evt_feeevent f
    JOIN prices.day p
      ON p.contract_address = from_base58(f.mint)
     AND p.timestamp        = f.evt_block_date
    LEFT JOIN categories c
      ON f.mint = c.token_mint
    WHERE f.evt_block_date >= DATE '2026-01-01'
      AND f.evt_block_date <  DATE '2026-07-01'
      AND p.blockchain = 'solana'
),
fee_totals AS (
    SELECT
        token_category,
        COUNT(*)            AS fee_events,
        SUM(fee_usd)        AS total_fees_usd,
        SUM(fee_usd) / COUNT(*) AS avg_fee_usd
    FROM categorised_fees
    GROUP BY 1
),
categorised_volume AS (
    SELECT
        CASE
            WHEN c.category IS NOT NULL         THEN c.category
            WHEN s.output_mint LIKE '%pump'     THEN 'Meme Coin'
            WHEN s.output_mint LIKE '%bonk'     THEN 'Meme Coin'
            ELSE 'Unmapped'
        END                                                 AS token_category,
        (s.output_amount / POWER(10, p.decimals)) * p.price  AS volume_usd
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    JOIN prices.day p
      ON p.contract_address = from_base58(s.output_mint)
     AND p.timestamp        = s.evt_block_date
    LEFT JOIN categories c
      ON s.output_mint = c.token_mint
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
      AND p.blockchain = 'solana'
),
volume_totals AS (
    SELECT
        token_category,
        SUM(volume_usd)     AS volume_usd
    FROM categorised_volume
    GROUP BY 1
)
SELECT
    f.token_category                                        AS category,
    f.fee_events,
    f.total_fees_usd,
    f.avg_fee_usd,
    v.volume_usd,
    f.total_fees_usd * 10000.0
      / NULLIF(v.volume_usd, 0)                             AS fee_bps
FROM fee_totals f
LEFT JOIN volume_totals v
  ON f.token_category = v.token_category
ORDER BY fee_bps DESC
