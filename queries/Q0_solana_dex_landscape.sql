-- Q0: Solana DEX landscape — all projects by trade count and volume, H1 2026
-- Purpose: verify date filter and identify project labels.
-- Note: Jupiter is absent here — as an aggregator it routes through underlying
-- AMM pools (meteora, raydium, whirlpool), which are what this table records.
SELECT
    project,
    COUNT(*)                        AS total_trades,
    COUNT(DISTINCT trader_id)       AS total_traders,
    SUM(amount_usd)                 AS total_volume_usd,
    MIN(block_time)                 AS first_trade,
    MAX(block_time)                 AS last_trade
FROM dex_solana.trades
WHERE block_time >= TIMESTAMP '2026-01-01'
  AND block_time <  TIMESTAMP '2026-07-01'
GROUP BY 1
ORDER BY total_trades DESC
LIMIT 50
