-- Q5a: Category distribution, aggregated for charting, H1 2026
-- Purpose: chart variant of Q5 (query_8725434). Q5 splits Meme Coin into
--   manually verified and suffix-matched rows to show how much of the
--   classification is checked. For charting the two are combined, otherwise
--   the same category appears as two separate segments.
SELECT
    category,
    SUM(swap_events)                                AS swap_events,
    SUM(pct_of_swap_events)                         AS pct_of_swap_events
FROM query_8725434
GROUP BY 1
ORDER BY swap_events DESC
