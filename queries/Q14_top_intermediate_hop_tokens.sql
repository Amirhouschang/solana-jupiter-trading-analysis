-- Q14: Top intermediate-hop tokens
-- Test period: one week
-- Grain: token within a Jupiter route group
-- Route key: evt_tx_id + evt_outer_instruction_index
--
-- Intermediate token = appears as both input and output
-- within the same route group.
--
-- routes_as_intermediate counts the number of route groups
-- in which a token acts as an intermediate hop.
--
-- The percentage is relative to all route groups that contain
-- at least one intermediate token. Because one route may contain
-- multiple intermediate tokens, percentages do not have to sum to 100%.

WITH route_events AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        input_mint,
        output_mint
    FROM jupiter_v6_solana.jupiter_evt_swapevent
    WHERE evt_block_date >= DATE '2026-01-01'
        AND evt_block_date < DATE '2026-07-01'
),

token_events AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        input_mint AS token_mint,
        1 AS input_seen,
        0 AS output_seen
    FROM route_events

    UNION ALL

    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        output_mint AS token_mint,
        0 AS input_seen,
        1 AS output_seen
    FROM route_events
),

token_roles AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint,
        MAX(input_seen) AS input_seen,
        MAX(output_seen) AS output_seen
    FROM token_events
    GROUP BY 1, 2, 3
),

intermediate_tokens AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint
    FROM token_roles
    WHERE input_seen = 1
      AND output_seen = 1
),

route_total AS (
    SELECT COUNT(DISTINCT (evt_tx_id, evt_outer_instruction_index))
        AS routes_with_intermediate
    FROM intermediate_tokens
)

SELECT
    i.token_mint,
    COUNT(*) AS routes_as_intermediate,
    ROUND(
        100.0 * COUNT(*) / r.routes_with_intermediate,
        2
    ) AS share_of_routes_with_intermediate_pct
FROM intermediate_tokens i
CROSS JOIN route_total r
GROUP BY 1, r.routes_with_intermediate
ORDER BY routes_as_intermediate DESC
LIMIT 20;
