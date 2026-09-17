-- C4: Column check for Part 2 — event order and route grouping
-- Purpose: verify that instruction indices exist and separate Jupiter routes
--   within a transaction. One day, five transactions with 3+ swap events.
WITH sample_tx AS (
    SELECT evt_tx_id
    FROM jupiter_v6_solana.jupiter_evt_swapevent
    WHERE evt_block_date = DATE '2026-03-02'
    GROUP BY 1
    HAVING COUNT(*) >= 3
    LIMIT 5
)
SELECT
    s.evt_tx_id,
    s.evt_outer_instruction_index,
    s.evt_inner_instruction_index,
    s.amm,
    s.input_mint,
    s.output_mint,
    s.input_amount,
    s.output_amount
FROM jupiter_v6_solana.jupiter_evt_swapevent s
JOIN sample_tx t ON s.evt_tx_id = t.evt_tx_id
WHERE s.evt_block_date = DATE '2026-03-02'
ORDER BY s.evt_tx_id, s.evt_outer_instruction_index, s.evt_inner_instruction_index
