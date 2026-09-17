-- Q10: Jupiter route type distribution
-- Period: H1 2026
-- Grain: one Jupiter route group
-- Route key: evt_tx_id + evt_outer_instruction_index
--
-- Classification:
-- Simple    = one swap event
-- Multi-Hop = intermediate token(s), without branching
-- Split     = a token is used more than once as input or output
-- Circle    = no final output token exists; route returns to its starting token

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

route_event_counts AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        COUNT(*) AS event_count
    FROM route_events
    GROUP BY 1, 2
),

token_events AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        input_mint AS token_mint,
        1 AS input_event,
        0 AS output_event
    FROM route_events

    UNION ALL

    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        output_mint AS token_mint,
        0 AS input_event,
        1 AS output_event
    FROM route_events
),

token_roles AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint,
        SUM(input_event) AS input_events,
        SUM(output_event) AS output_events
    FROM token_events
    GROUP BY 1, 2, 3
),

route_roles AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,

        COUNT_IF(
            output_events > 0
            AND input_events = 0
        ) AS final_tokens,

        COUNT_IF(
            input_events > 0
            AND output_events > 0
        ) AS intermediate_tokens,

        MAX(input_events) AS max_input_occurrences,
        MAX(output_events) AS max_output_occurrences

    FROM token_roles
    GROUP BY 1, 2
),

classified AS (
    SELECT
        e.evt_tx_id,
        e.evt_outer_instruction_index,

        CASE
            WHEN r.final_tokens = 0
                THEN 'Circle'

            WHEN e.event_count = 1
                THEN 'Simple'

            WHEN r.max_input_occurrences > 1
              OR r.max_output_occurrences > 1
                THEN 'Split'

            WHEN r.intermediate_tokens > 0
                THEN 'Multi-Hop'

            ELSE 'Simple'
        END AS route_type

    FROM route_event_counts e
    JOIN route_roles r
        ON e.evt_tx_id = r.evt_tx_id
       AND e.evt_outer_instruction_index = r.evt_outer_instruction_index
)

SELECT
    route_type,
    COUNT(*) AS routes,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS share_of_routes_pct
FROM classified
GROUP BY 1
ORDER BY routes DESC;
