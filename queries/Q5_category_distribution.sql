-- Q5: Trading activity by token category, H1 2026
-- Purpose: compare each category's share of activity against its token count.
-- Note: joins Q4 (query_8725347) for the 105 manually verified tokens.
-- Note: tokens outside that set are classified by mint suffix — launchpad
--   tokens end in 'pump' (Pump.fun) or 'bonk' (LetsBonk). This is a vanity
--   suffix chosen at mint time, so it identifies the launchpad reliably.
--   Everything else stays 'Unmapped' and is reported, not hidden.
-- Note: categorised on output_mint only — the token being bought.
-- Note: a transaction touching several categories is counted once in each.
--   Summing user_swaps or traders across categories therefore exceeds the
--   total from Q1 — by design, because output events can touch several categories.
--   pct_of_swap_events is unaffected: it uses exact event counts.
-- Note: approx_distinct used for user_swaps, traders and dex_programs.
--   Roughly 2% error; exact counts time out at 465M rows. At small counts the
--   estimate can exceed the exact event count (Other: 182,595 vs 173,258).
-- Note: Meme Coin appears twice, split by mapping_method. Combined share is
--   ~11.0% of swap events. Charts should aggregate the two rows.
WITH categories AS (
    SELECT * FROM query_8725347
),
swaps AS (
    SELECT
        s.evt_tx_id,
        s.evt_tx_signer,
        s.amm,
        CASE
            WHEN c.category IS NOT NULL              THEN c.category
            WHEN s.output_mint LIKE '%pump'          THEN 'Meme Coin'
            WHEN s.output_mint LIKE '%bonk'          THEN 'Meme Coin'
            ELSE 'Unmapped'
        END                                          AS category,
        CASE
            WHEN c.category IS NOT NULL              THEN 'manual'
            WHEN s.output_mint LIKE '%pump'          THEN 'suffix'
            WHEN s.output_mint LIKE '%bonk'          THEN 'suffix'
            ELSE 'none'
        END                                          AS mapping_method
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    LEFT JOIN categories c
      ON s.output_mint = c.token_mint
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
)
SELECT
    category,
    mapping_method,
    COUNT(*)                                        AS swap_events,
    approx_distinct(evt_tx_id)                      AS user_swaps,
    approx_distinct(evt_tx_signer)                  AS traders,
    approx_distinct(amm)                            AS dex_programs,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()        AS pct_of_swap_events
FROM swaps
GROUP BY 1, 2
ORDER BY swap_events DESC
