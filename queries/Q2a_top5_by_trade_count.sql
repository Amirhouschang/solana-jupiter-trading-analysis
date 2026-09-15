-- Q2a: Top 5 tokens by trade count, H1 2026
-- Purpose: chart variant of Q2 (query_8724549). The distribution is extremely
--   skewed — SOL and USDC dwarf everything else, so in a single chart the lower
--   ranks are flat against the axis. Leaders and tail are charted separately.
SELECT
    symbol,
    user_swaps,
    swap_events
FROM query_8724549
ORDER BY user_swaps DESC, symbol
LIMIT 5
