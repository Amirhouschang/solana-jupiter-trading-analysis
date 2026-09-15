-- Q6c: Top 5 DEX programs by share of swap events, H1 2026
-- Purpose: chart variant of Q6 (query_8725506). 89 programs is too many for a
--   readable chart; the top 5 carry 42% of routing. Top 20 in Q6e; full list in Q6.
SELECT
    dex_name,
    pct_of_swap_events,
    distinct_tokens
FROM query_8725506
ORDER BY pct_of_swap_events DESC
LIMIT 5
