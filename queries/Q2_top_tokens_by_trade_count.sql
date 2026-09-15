-- Q2: Top tokens by trade count with symbols, H1 2026
-- Scope: top 100 tokens (88% of all swap events, see C1).
-- user_swaps = distinct transactions; swap_events = raw rows.
--   One user swap can hit several DEX programs (1.74 avg, see Q1).
-- approx_distinct used — exact counts time out at 465M rows.
-- LEFT JOIN on token_mint_address; many tokens have no metadata row.
WITH top_tokens AS (
    SELECT
        output_mint                         AS token_mint,
        approx_distinct(evt_tx_id)          AS user_swaps,
        COUNT(*)                            AS swap_events,
        approx_distinct(evt_tx_signer)      AS traders
    FROM jupiter_v6_solana.jupiter_evt_swapevent
    WHERE evt_block_date >= DATE '2026-01-01'
      AND evt_block_date <  DATE '2026-07-01'
    GROUP BY 1
    ORDER BY swap_events DESC
    LIMIT 100
)
SELECT
    t.token_mint,
    f.symbol,
    f.name,
    f.decimals,
    t.user_swaps,
    t.swap_events,
    t.traders
FROM top_tokens t
LEFT JOIN tokens_solana.fungible f
  ON t.token_mint = f.token_mint_address
ORDER BY t.swap_events DESC
