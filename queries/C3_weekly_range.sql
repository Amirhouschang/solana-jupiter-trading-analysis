SELECT
    category,
    MIN(pct_of_week)    AS min_pct,
    MAX(pct_of_week)    AS max_pct,
    COUNT(*)            AS weeks
FROM query_8726069
GROUP BY 1
ORDER BY max_pct DESC
