-- Q2a: Top 5 tokens by trade count, H1 2026
-- Purpose: chart variant of Q2 (query_8724549). The distribution is extremely
--   skewed — SOL and USDC dwarf everything else, so in a single chart the lower
--   ranks are flat against the axis. Leaders and tail are charted separately.
-- Note: ranked by exact swap_events; user_swaps is an approx_distinct estimate
--   (~2% error) and is not used for ordering.
SELECT
    symbol,
    user_swaps,
    swap_events
FROM query_8724549
ORDER BY swap_events DESC, symbol
LIMIT 5
