-- Q1: Baseline metrics — Jupiter v6 aggregator swaps, H1 2026
-- Purpose: establish data volume and verify the date filter.
-- Note: one user swap can produce several swap events (multi-pool routing),
-- so total_swap_events > total_user_swaps by design.
-- Note: this table carries both camelCase and snake_case columns for mints and
-- amounts; only the snake_case ones are populated for the 2026 period.
-- Note: `amm` is the DEX program address, not an individual pool.
SELECT
    COUNT(*)                            AS total_swap_events,
    COUNT(DISTINCT evt_tx_id)           AS total_user_swaps,
    COUNT(DISTINCT evt_tx_signer)       AS total_traders,
    COUNT(DISTINCT amm)                 AS dex_programs_used,
    COUNT(DISTINCT input_mint)          AS distinct_input_tokens,
    COUNT(DISTINCT output_mint)         AS distinct_output_tokens,
    MIN(evt_block_time)                 AS first_swap,
    MAX(evt_block_time)                 AS last_swap
FROM jupiter_v6_solana.jupiter_evt_swapevent
WHERE evt_block_date >= DATE '2026-01-01'
  AND evt_block_date <  DATE '2026-07-01'
