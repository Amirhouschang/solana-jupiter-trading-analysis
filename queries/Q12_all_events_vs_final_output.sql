-- Q12: All-event category shares vs final-output category shares
-- Period: H1 2026
--
-- all_events:
-- Q5, where every swap event output is counted.
--
-- final_output:
-- Q11, where only the final token of each non-circular
-- Jupiter route group is counted.
--
-- Delta is measured in percentage points:
-- final_output_share - all_events_share.

WITH comparison (
    category,
    mapping_method,
    all_events_share_pct,
    final_output_share_pct
) AS (
    VALUES
        ('Stablecoin',        'manual',   39.33, 31.31),
        ('Native Solana',     'manual',   38.13, 38.29),
        ('Unmapped',          'unmapped',  5.95,  8.77),
        ('Meme Coin',         'suffix',    5.93, 11.00),
        ('Meme Coin',         'manual',    5.05,  7.13),
        ('Cross-Chain Asset', 'manual',    3.91,  2.59),
        ('Liquid Staking',    'manual',    1.23,  0.45),
        ('Tokenized RWA',     'manual',    0.43,  0.38),
        ('Other',             'manual',    0.04,  0.08)
)

SELECT
    category,
    mapping_method,
    all_events_share_pct,
    final_output_share_pct,
    ROUND(
        final_output_share_pct - all_events_share_pct,
        2
    ) AS delta_percentage_points
FROM comparison
ORDER BY ABS(
    final_output_share_pct - all_events_share_pct
) DESC;
