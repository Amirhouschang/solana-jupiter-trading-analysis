-- Q14b: Top 5 intermediate-hop tokens
-- Period: H1 2026
-- Chart-ready subset of the validated Q14 results.

SELECT *
FROM (
    VALUES
        ('SOL/WSOL', 80527620, 68.51),
        ('USDC',     69484526, 59.12),
        ('USDT',     21471681, 18.27),
        ('USD1',     13986161, 11.90),
        ('cbBTC',     4217544,  3.59)
) AS t (
    token,
    routes_as_intermediate,
    share_of_routes_with_intermediate_pct
)
ORDER BY routes_as_intermediate DESC;
