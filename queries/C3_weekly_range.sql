-- C3: Weekly share range per category, H1 2026
-- Purpose: min and max weekly share of swap events per category, based on Q9
--   (query_8726069). Supports the over-time statements in README, REPORT and
--   the dashboard.
-- Note: includes the partial first and last weeks. `weeks` counts only weeks
--   in which the category appears (Other: 15 of 27).
SELECT
    category,
    MIN(pct_of_week)    AS min_pct,
    MAX(pct_of_week)    AS max_pct,
    COUNT(*)            AS weeks
FROM query_8726069
GROUP BY 1
ORDER BY max_pct DESC
