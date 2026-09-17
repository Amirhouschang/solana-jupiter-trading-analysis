-- Q12a: Chart-ready comparison of all-event vs final-output category shares
-- Period: H1 2026
--
-- Meme Coin manual and suffix classifications are combined
-- into one category for clearer dashboard presentation.

WITH comparison(category, all_events_share_pct, final_output_share_pct) AS (
    VALUES
        ('Stablecoin',        39.33, 31.31),
        ('Native Solana',     38.13, 38.29),
        ('Meme Coin',         10.98, 18.13),
        ('Unmapped',           5.95,  8.77),
        ('Cross-Chain Asset',  3.91,  2.59),
        ('Liquid Staking',     1.23,  0.45),
        ('Tokenized RWA',      0.43,  0.38),
        ('Other',              0.04,  0.08)
)

SELECT
    category,
    all_events_share_pct,
    final_output_share_pct,
    ROUND(
        final_output_share_pct - all_events_share_pct,
        2
    ) AS delta_percentage_points
FROM comparison
ORDER BY all_events_share_pct DESC;
