-- C5: Transactions containing multiple Jupiter route groups
-- Test period: one week

WITH tx_routes AS (
    SELECT
        evt_tx_id,
        COUNT(DISTINCT evt_outer_instruction_index) AS route_groups
    FROM jupiter_v6_solana.jupiter_evt_swapevent
    WHERE evt_block_date >= DATE '2026-03-02'
      AND evt_block_date < DATE '2026-03-09'
    GROUP BY 1
)

SELECT
    route_groups,
    COUNT(*) AS transactions,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS share_of_transactions_pct
FROM tx_routes
GROUP BY 1
ORDER BY 1;
