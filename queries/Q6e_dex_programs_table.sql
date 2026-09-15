-- Q6e: DEX programs by routing share — table variant, top 20, H1 2026
-- Purpose: table variant of Q6 (query_8725506), limited to the 20 programs
--   that have verified names in Q6b. The remaining 69 are unnamed and would
--   show as 'Unmapped'.
SELECT
    dex_name            AS "DEX program",
    pct_of_swap_events  AS "Share of swaps (%)",
    distinct_tokens     AS "Tokens served",
    traders             AS "Traders"
FROM query_8725506
ORDER BY pct_of_swap_events DESC
LIMIT 20
