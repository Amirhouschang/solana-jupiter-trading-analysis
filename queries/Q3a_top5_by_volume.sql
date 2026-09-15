-- Q3a: Top 5 tokens by USD volume, H1 2026
-- Purpose: chart variant of Q3 (query_8726202). Same split as Q2a/Q2b — the
--   distribution is too skewed for a single readable chart.
SELECT
    symbol,
    volume_usd,
    avg_size_usd
FROM query_8726202
ORDER BY volume_usd DESC
LIMIT 5
