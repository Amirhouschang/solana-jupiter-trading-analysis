-- Q2b: Tokens ranked 6–15 by trade count, H1 2026
-- Purpose: chart variant of Q2 (query_8724549), showing the range below the
--   four leaders at a readable scale. See Q2a for the top of the distribution.
SELECT
    symbol,
    user_swaps,
    swap_events
FROM query_8724549
ORDER BY user_swaps DESC, symbol
OFFSET 5
LIMIT 10
