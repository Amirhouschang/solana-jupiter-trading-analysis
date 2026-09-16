-- Q3: Top tokens by USD volume, H1 2026
-- Purpose: rank tokens by priced swap-event output volume, to contrast with the
--   trade-count ranking in Q2. The two rankings answer different questions.
-- Note: every output event counts, including intermediate hops (A -> SOL -> B
--   counts SOL and B). This is execution volume, not final user-order value.
-- Method: output_amount is a raw integer; divided by 10^decimals and multiplied
--   by the daily USD price of that token.
-- Note: prices.day stores Solana mints as bytes — from_base58() converts the
--   base58 mint string before joining.
-- Note: price coverage is uneven. Liquid Staking 100%, Native Solana 89%,
--   Stablecoin 82%, Cross-Chain and RWA 67%, Meme Coin only 24%. Tokens without
--   a price row are excluded, so meme coin volume is understated here.
-- Note: valuations use Dune daily prices, not execution-time prices.
WITH priced_swaps AS (
    SELECT
        s.output_mint                                       AS token_mint,
        p.symbol,
        s.evt_tx_id,
        (s.output_amount / POWER(10, p.decimals)) * p.price  AS volume_usd
    FROM jupiter_v6_solana.jupiter_evt_swapevent s
    JOIN prices.day p
      ON p.contract_address = from_base58(s.output_mint)
     AND p.timestamp        = s.evt_block_date
    WHERE s.evt_block_date >= DATE '2026-01-01'
      AND s.evt_block_date <  DATE '2026-07-01'
      AND p.blockchain = 'solana'
)
SELECT
    token_mint,
    symbol,
    SUM(volume_usd)                             AS volume_usd,
    COUNT(*)                                    AS swap_events,
    approx_distinct(evt_tx_id)                  AS user_swaps,
    SUM(volume_usd) / COUNT(*)                  AS avg_size_usd
FROM priced_swaps
GROUP BY 1, 2
ORDER BY volume_usd DESC
LIMIT 50
