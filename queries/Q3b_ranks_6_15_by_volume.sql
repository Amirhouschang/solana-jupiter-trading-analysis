-- Q3b: Tokens ranked 6–15 by USD volume, H1 2026
-- Purpose: chart variant of Q3 (query_8726202), showing the range below the
--   leaders at a readable scale.
SELECT
    symbol,
    volume_usd,
    avg_size_usd
FROM query_8726202
ORDER BY volume_usd DESC
OFFSET 5
LIMIT 10
