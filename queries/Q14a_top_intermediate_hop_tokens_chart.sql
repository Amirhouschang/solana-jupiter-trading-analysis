-- Q14a: Chart-ready top intermediate-hop tokens
-- Period: H1 2026
--
-- Uses the validated Q14 results.
-- Token labels are manually assigned because Solana token metadata
-- was found to be unreliable during this project.
--
-- Share = percentage of route groups containing at least one
-- intermediate token in which the token appears as an intermediate hop.
-- Shares can sum to more than 100% because one route can contain
-- multiple intermediate tokens.

WITH token_names(token_mint, token) AS (
    VALUES
        ('So11111111111111111111111111111111111111112', 'SOL/WSOL'),
        ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v', 'USDC'),
        ('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB', 'USDT'),
        ('USD1ttGY1N17NEEHLmELoaybftRBUSErhqYiQzvEmuB', 'USD1'),
        ('cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij', 'cbBTC'),
        ('27G8MtK7VtTcCHkpASjSDdkWWYfoqT6ggEuKidVJidD4', 'JLP'),
        ('J1toso1uCk3RLmjorhTtrVwY9HJ7X8V9yYac6Y7kGCPn', 'JitoSOL'),
        ('7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs', 'WETH'),
        ('9BB6NFEcjBCtnNLFko2FqVQBq8HHM13kCyYcdQbgpump', 'Fartcoin'),
        ('2u1tszSeqZ3qBWF3uNGPFc8TzMk2tdiwknnRMWGWjGWH', 'USDG'),
        ('pumpCmXqMfrsAkQ5r49WcJnRayYRqmXz6ae8H7H9Dfn', 'PUMP'),
        ('3NZ9JMVBmGAqocybic2c7LQCJScmgsAZ6vQqTDzcqmJh', 'WBTC'),
        ('JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN', 'JUP'),
        ('6p6xgHyF7AeE6TZkSmFsko444wqoP15icUSqi2jfGiPN', 'TRUMP'),
        ('mSoLzYCxHdYgdzU16g5QSh3i5K3z3KZK7ytfqcJm7So', 'mSOL'),
        ('98sMhvDwXj1RQi5c5Mndm3vPe9cBqPrbLaufMXFNMh5g', 'HYPE'),
        ('A7bdiYdS5GjqGFtxf17ppRHtDKPkkRqbKtR27dxvQXaS', 'ZEC'),
        ('DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263', 'BONK'),
        ('CtzPWv73Sn1dMGVU3ZtLv9yWSyUAanBni19YWDaznnkn', 'xBTC'),
        ('2b1kV6DkPAnxd5ixfnxCpjxmKwqjjaYmCZfHsFu24GXo', 'PyUSD')
),

q14_results(token_mint, routes_as_intermediate, share_pct) AS (
    VALUES
        ('So11111111111111111111111111111111111111112', 80527620, 68.51),
        ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v', 69484526, 59.12),
        ('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB', 21471681, 18.27),
        ('USD1ttGY1N17NEEHLmELoaybftRBUSErhqYiQzvEmuB', 13986161, 11.90),
        ('cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij', 4217544, 3.59),
        ('27G8MtK7VtTcCHkpASjSDdkWWYfoqT6ggEuKidVJidD4', 3239738, 2.76),
        ('J1toso1uCk3RLmjorhTtrVwY9HJ7X8V9yYac6Y7kGCPn', 2616077, 2.23),
        ('7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs', 2482598, 2.11),
        ('9BB6NFEcjBCtnNLFko2FqVQBq8HHM13kCyYcdQbgpump', 2461874, 2.09),
        ('2u1tszSeqZ3qBWF3uNGPFc8TzMk2tdiwknnRMWGWjGWH', 2315075, 1.97),
        ('pumpCmXqMfrsAkQ5r49WcJnRayYRqmXz6ae8H7H9Dfn', 2154384, 1.83),
        ('3NZ9JMVBmGAqocybic2c7LQCJScmgsAZ6vQqTDzcqmJh', 2042081, 1.74),
        ('JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN', 1851419, 1.58),
        ('6p6xgHyF7AeE6TZkSmFsko444wqoP15icUSqi2jfGiPN', 1262379, 1.07),
        ('mSoLzYCxHdYgdzU16g5QSh3i5K3z3KZK7ytfqcJm7So', 1254318, 1.07),
        ('98sMhvDwXj1RQi5c5Mndm3vPe9cBqPrbLaufMXFNMh5g', 1058105, 0.90),
        ('A7bdiYdS5GjqGFtxf17ppRHtDKPkkRqbKtR27dxvQXaS', 1014697, 0.86),
        ('DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263', 879545, 0.75),
        ('CtzPWv73Sn1dMGVU3ZtLv9yWSyUAanBni19YWDaznnkn', 790368, 0.67),
        ('2b1kV6DkPAnxd5ixfnxCpjxmKwqjjaYmCZfHsFu24GXo', 720339, 0.61)
)

SELECT
    n.token,
    q.routes_as_intermediate,
    q.share_pct AS share_of_routes_with_intermediate_pct
FROM q14_results q
JOIN token_names n
    ON q.token_mint = n.token_mint
ORDER BY q.routes_as_intermediate DESC;
