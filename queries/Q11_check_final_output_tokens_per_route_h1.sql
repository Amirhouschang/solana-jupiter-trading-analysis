-- Q11 Check: Final output tokens per route, H1 2026
-- Purpose:
-- Validate how many final output tokens exist per route group
-- and check whether NULL outer instruction indices explain
-- the small difference between Q10 and Q11 totals.

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

token_roles AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint,
        MAX(is_input) AS is_input,
        MAX(is_output) AS is_output
    FROM (
        SELECT
            evt_tx_id,
            evt_outer_instruction_index,
            input_mint AS token_mint,
            1 AS is_input,
            0 AS is_output
        FROM route_events

        UNION ALL

        SELECT
            evt_tx_id,
            evt_outer_instruction_index,
            output_mint AS token_mint,
            0 AS is_input,
            1 AS is_output
        FROM route_events
    ) x
    WHERE token_mint IS NOT NULL
    GROUP BY
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint
),

route_summary AS (
    SELECT
        evt_tx_id,
        evt_outer_instruction_index,
        SUM(
            CASE
                WHEN is_output = 1 AND is_input = 0 THEN 1
                ELSE 0
            END
        ) AS final_token_count
    FROM token_roles
    GROUP BY
        evt_tx_id,
        evt_outer_instruction_index
)

SELECT
    CASE
        WHEN evt_outer_instruction_index IS NULL
            THEN 'NULL outer index'
        ELSE 'Non-NULL outer index'
    END AS outer_index_status,
    final_token_count,
    COUNT(*) AS route_groups,
    SUM(final_token_count) AS final_output_tokens
FROM route_summary
GROUP BY
    1,
    2
ORDER BY
    1,
    2;
