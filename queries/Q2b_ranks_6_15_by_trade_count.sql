-- Q2b: Tokens ranked 6–15 by trade count, H1 2026
-- Purpose: chart variant of Q2 (query_8724549), showing the range below the
--   top five at a readable scale. See Q2a for the top of the distribution.
-- Note: ranked by exact swap_events. user_swaps is an approx_distinct estimate
--   (~2% error); ranks 11–14 differ by less than that, so ordering by it
--   would not be reliable.
SELECT
    symbol,
    user_swaps,
    swap_events
FROM query_8724549
ORDER BY swap_events DESC, symbol
OFFSET 5
LIMIT 10
