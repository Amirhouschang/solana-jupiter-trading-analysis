-- Q13: Weekly category shares by final output token
-- Test period: one week
-- Grain: one Jupiter route group with a final output token
-- Route key: evt_tx_id + evt_outer_instruction_index
--
-- Final token = appears as output but never as input
-- within the same route group.
--
-- Circular routes are excluded because they have no final token.
-- Q4 manual mapping is reused exactly.
-- Unmatched mints ending in 'pump' or 'bonk' are Meme Coin (suffix).
-- Remaining unmatched tokens are Unmapped.
--
-- Output: weekly category shares of final-output routes.

WITH manual_mapping(token_mint, category) AS (
    VALUES

    -- Native Solana
    ('So11111111111111111111111111111111111111112', 'Native Solana'),
    ('pumpCmXqMfrsAkQ5r49WcJnRayYRqmXz6ae8H7H9Dfn', 'Native Solana'),
    ('27G8MtK7VtTcCHkpASjSDdkWWYfoqT6ggEuKidVJidD4', 'Native Solana'),
    ('JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN', 'Native Solana'),
    ('4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R', 'Native Solana'),
    ('orcaEKTdK7LKz57vaAYr9QeNsVEPfiu6QeMU1kektZE', 'Native Solana'),
    ('KMNo3nJsBXfcpJTVhZcXLW7RmTwTt4GVFE7suUBo9sS', 'Native Solana'),
    ('METvsvVRapdj9cFLzq4Tr43xK4tAjQfwX76z3n6mWQL', 'Native Solana'),
    ('SarosY6Vscao718M4A778z4CGtvcwcGef5M9MEH1LGL', 'Native Solana'),
    ('SKRbvo6Gf7GondiT3BbTfuRDPqLWei4j2Qy2NPGZhW3', 'Native Solana'),
    ('jtojtomepa8beP8AuQc6eXt5FriJwfFMwQx2v2f9mCL', 'Native Solana'),
    ('METAewgxyPbgwsseH8T16a39CQ5VyVxZi9zXiDPY18m', 'Native Solana'),
    ('DBRiDgJAMsM95moTzJs7M9LnkGErpbv9v6CUR1DXnUu5', 'Native Solana'),
    ('hntyVP6YFm1Hg25TN9WGLqM12b8TQmcknKrdu1oxWux', 'Native Solana'),
    ('7JA5eZdCzztSfQbJvS8aVVxMFfd81Rs9VvwnocV1mKHu', 'Native Solana'),
    ('oreoU2P8bN6jkk3jbaiVxYnG1dCXcYxwhwyK9jSybcp', 'Native Solana'),
    ('ZBCNpuD7YMXzTHB2fhGkGi78MNsHGLRXUhRewNRm9RU', 'Native Solana'),
    ('J6pQQ3FAcJQeWPPGppWRb4nM8jU3wLyYbRrLh7feMfvd', 'Native Solana'),
    ('WETZjtprkDMCcUxPi9PfWnowMRZkiGGHDb9rABuRZ2U', 'Native Solana'),

    -- Liquid Staking
    ('J1toso1uCk3RLmjorhTtrVwY9HJ7X8V9yYac6Y7kGCPn', 'Liquid Staking'),
    ('mSoLzYCxHdYgdzU16g5QSh3i5K3z3KZK7ytfqcJm7So', 'Liquid Staking'),
    ('jupSoLaHXQiZZTSfEWMTRRgpnyFm8f6sZdosWBjx93v', 'Liquid Staking'),
    ('7dHbWXmci3dT8UFYWYZweBLXgycu7Y3iL6trKn1Y7ARj', 'Liquid Staking'),
    ('bSo13r4TkiE4KumL71LsHTPpL2euBYLFx6h9HP3piy1', 'Liquid Staking'),
    ('5oVNBeEEQvYi1cX3ir8Dx5n1P7pdxydbGF2X4TxVusJm', 'Liquid Staking'),

    -- Stablecoin
    ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v', 'Stablecoin'),
    ('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB', 'Stablecoin'),
    ('USD1ttGY1N17NEEHLmELoaybftRBUSErhqYiQzvEmuB', 'Stablecoin'),
    ('2u1tszSeqZ3qBWF3uNGPFc8TzMk2tdiwknnRMWGWjGWH', 'Stablecoin'),
    ('JuprjznTrTSp2UFa3ZBUFgwdAmtZCq4MQCwysN55USD', 'Stablecoin'),
    ('2b1kV6DkPAnxd5ixfnxCpjxmKwqjjaYmCZfHsFu24GXo', 'Stablecoin'),
    ('HzwqbKZw8HxMN6bF2yFZNrht3c2iXXzpKcFu7uBEDKtr', 'Stablecoin'),
    ('USDSwr9ApdHk5bvJKMjzff41FfuX8bSxdKcR81vTwcA', 'Stablecoin'),
    ('5YMkXAYccHSGnHn9nob9xEvv6Pvka9DZWH7nTbotTu9E', 'Stablecoin'),
    ('AvZZF1YaZDziPY2RCK4oJrRVrbN3mTD9NL24hPeaZeUj', 'Stablecoin'),
    ('CASHx9KJUStyftLFWGvEVf59SGeG9sh5FfcnZMVPCASH', 'Stablecoin'),
    ('DEkqHyPN7GMRJ5cArtQFAWefqbZb33Hyf6s5iCwjEonT', 'Stablecoin'),
    ('7GxATsNMnaC88vdwd2t3mwrFuQwwGvmYPrUQ4D6FotXk', 'Stablecoin'),
    ('6FrrzDk5mQARGc1TDYoyVnSyRdds1t4PbtohCD6p3tgG', 'Stablecoin'),

    -- Cross-Chain Asset
    ('cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij', 'Cross-Chain Asset'),
    ('7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs', 'Cross-Chain Asset'),
    ('3NZ9JMVBmGAqocybic2c7LQCJScmgsAZ6vQqTDzcqmJh', 'Cross-Chain Asset'),
    ('CtzPWv73Sn1dMGVU3ZtLv9yWSyUAanBni19YWDaznnkn', 'Cross-Chain Asset'),
    ('zBTCug3er3tLyffELcvDNrKkCymbPWysGcWihESYfLg', 'Cross-Chain Asset'),
    ('98sMhvDwXj1RQi5c5Mndm3vPe9cBqPrbLaufMXFNMh5g', 'Cross-Chain Asset'),
    ('A7bdiYdS5GjqGFtxf17ppRHtDKPkkRqbKtR27dxvQXaS', 'Cross-Chain Asset'),
    ('CrAr4RRJMBVwRsZtT62pEhfA9H5utymC2mVx8e7FreP2', 'Cross-Chain Asset'),
    ('EicWvteVi2fWepEzS3FYWsnuPoP6caZfjnKqNvydLjCH', 'Cross-Chain Asset'),

    -- Tokenized RWA
    ('XsDoVfqeBukxuZHWhdvWHBhgEHjGNst4MLodqsJHzoB', 'Tokenized RWA'),
    ('XsueG8BtpquVJX9LVLLEGuViXUungE6WmK5YZ3p3bd1', 'Tokenized RWA'),
    ('Xsc9qvGR1efVDFGLrVsmkzv3qi45LTBjeUKSPmx9qEh', 'Tokenized RWA'),
    ('XsoCS1TfEyfFhfvj8EtZ528L3CaKBDBRqRapnBbDF2W', 'Tokenized RWA'),
    ('SPCXxcqXj6e5dJDVNovHN8744zkbhM2bYudU45BimGb', 'Tokenized RWA'),
    ('AymATz4TCL9sWNEEV9Kvyz45CHVhDZ6kUgjTJPzLpU9P', 'Tokenized RWA'),
    ('kLqMvUm1p4pRbxU4r8kWCTVAuWMJLtcTJqGb4b5pump', 'Tokenized RWA'),
    ('USoRyaQjch6E18nCdDvWoRgTo6osQs9MUd8JXEsspWR', 'Tokenized RWA'),
    ('5Y8NV33Vv7WbnLfq3zBcKSdYPrk7g2KoiQoe7M2tcxp5', 'Tokenized RWA'),
    ('Xs8S1uUs1zvS2p7iwtsG3b6fkhpvmwz4GYU3gWAmWHZ', 'Tokenized RWA'),

    -- Meme Coin
    ('9BB6NFEcjBCtnNLFko2FqVQBq8HHM13kCyYcdQbgpump', 'Meme Coin'),
    ('DMYNp65mub3i7LRpBdB66CgBAceLcQnv4gsWeCi6pump', 'Meme Coin'),
    ('6p6xgHyF7AeE6TZkSmFsko444wqoP15icUSqi2jfGiPN', 'Meme Coin'),
    ('8jiVXftnn2ZG6bugK7HAH5j2G3D6TpsG521gqsWwpump', 'Meme Coin'),
    ('DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263', 'Meme Coin'),
    ('Dz9mQ9NzkBcCsuGPFJ3r1bS4wgqKMHBPiVuniW8Mbonk', 'Meme Coin'),
    ('a3W4qutoEJA4232T2gwZUfgYJTetr96pU4SJMwppump', 'Meme Coin'),
    ('Dfh5DzRgSvvCFDoYc2ciTkMrbDfRKybA4SoFbPmApump', 'Meme Coin'),
    ('BBG3vpXVCm2uPBD7LUr7yfP9XUXVNJRHMtiMG7q4pump', 'Meme Coin'),
    ('8Jx8AAHj86wbQgUTjGuj6GTTL5Ps3cqxKRTvpaJApump', 'Meme Coin'),
    ('7fj85y28pKMndm4So66Szkb5GMGfLHFEkwsZdDx2pump', 'Meme Coin'),
    ('CreiuhfwdWCN5mJbMJtA9bBpYQrQF2tCBuZwSPWfpump', 'Meme Coin'),
    ('CAjtTHvC878f8cZ4zEwdvgjkjFM7rbYN8Mb1go1cpump', 'Meme Coin'),
    ('7GCihgDB8fe6KNjn2MYtkzZcRjQy3t9GHdC8uHYmW2hr', 'Meme Coin'),
    ('4TyZGqRLG3VcHTGMcLBoPUmqYitMVojXinAmkL8xpump', 'Meme Coin'),
    ('4D9jZY6nkXnm3ofmWWJVcJrvtXDMfE5Zwy8rZMy5pump', 'Meme Coin'),
    ('pixvL7orpc8AfVUmeQ3kJZ588EegnXSQd7UW4TcVzDk', 'Meme Coin'),
    ('EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm', 'Meme Coin'),
    ('61V8vBaqAGMpgDQi4JcAwo1dmBGHsyhzodcPqnEVpump', 'Meme Coin'),
    ('3BHhMXMyyGGzLcTk6u5iJwTcV7eEGG9bWJrTKUttpump', 'Meme Coin'),
    ('J3NKxxXZcnNiMjKw9hYb2K4LUxgwB6t1FtPtQVsv3KFr', 'Meme Coin'),
    ('6MFiqqkS4MUwmkoa8sj5UJcFzJGVxHD1yEpoyRRUdoge', 'Meme Coin'),
    ('kMKX8hBaj3BTRBbeYix9c16EieBP5dih8DTSSwCpump', 'Meme Coin'),
    ('4FdojUmXeaFMBG6yUaoufAC5Bz7u9AwnSAMizkx5pump', 'Meme Coin'),
    ('E714f3oiK3sA8WGBBpmgx7Vkptz7Xh7H9YNWjpkLpump', 'Meme Coin'),
    ('8opvqaWysX1oYbXuTL8PHaoaTiXD69VFYAX4smPebonk', 'Meme Coin'),
    ('FmjijgwEHpe32VPvHy1s7u7TLthh9yu1j75djVbWpump', 'Meme Coin'),
    ('ChNrhBZwGtn1ZRsrdzcuBqiKTYfVViCPZqJdsgBHpump', 'Meme Coin'),
    ('NV2RYH954cTJ3ckFUpvfqaQXU4ARqqDH3562nFSpump', 'Meme Coin'),
    ('8f62NyJGo7He5uWeveTA2JJQf4xzf8aqxkmzxRQ3mxfU', 'Meme Coin'),
    ('Cm6fNnMk7NfzStP9CZpsQA2v3jjzbcYGAxdJySmHpump', 'Meme Coin'),
    ('5UUH9RTDiSpq6HKS6bp4NdU9PNJpXRXuiw6ShBTBhgH2', 'Meme Coin'),
    ('JE8zmsKRivXggZsJxXHBdCkako85YawNtU5hqS4upump', 'Meme Coin'),
    ('x95HN3DWvbfCBtTjGm587z8suK3ec6cwQwgZNLbWKyp', 'Meme Coin'),
    ('Ce2gx9KGXJ6C9Mp5b5x1sn9Mg87JwEbrQby4Zqo3pump', 'Meme Coin'),
    ('8Hg96R1AGDe5vKABwniVPT2LHdhZHmCTFijZAXXZpump', 'Meme Coin'),
    ('4YiLHDR4B4pE4R5GUMA8HG8YunyeLwcobtEtvwMupump', 'Meme Coin'),
    ('2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv', 'Meme Coin'),
    ('G7vQWurMkMMm2dU3iZpXYFTHT9Biio4F4gZCrwFpKNwG', 'Meme Coin'),
    ('HmBdm8vbisABUjkxms6ZUnoaXbfwFM6ymxShWfAENaoi', 'Meme Coin'),
    ('NgsodHAjoLZF5VC25euE1wBiZUgTVMHSErMRRKt74mA', 'Meme Coin'),
    ('2k8yZaJjf61unHriuqdmvbxe7CUhEYML5kVJDbcotKjU', 'Meme Coin'),
    ('gLEXZ2kAfuYkpeeSzrEMbakiNeqAAZ3TsKiY9Can8pE', 'Meme Coin'),
    ('1ogCsoK7ZqZwiYam9i7xq2j6Bf2LizT6iQtGSp6vCoT', 'Meme Coin'),
    ('C8fU5GdfAt5mnw2RK7HE6XJGFNxHpaskZMkXxdm88888', 'Meme Coin'),
    ('FeR8VBqNRSUD5NtXAj2n3j1dAHkZHfyDktKuLXD4pump', 'Meme Coin'),

    -- Other
    ('Es9vdPD6sXzHhbAskU19WFnAtyRo94HKrGrPSdQ3aSSB', 'Other')
),

route_events AS (
    SELECT
        DATE_TRUNC('week', evt_block_date) AS week,
        evt_tx_id,
        evt_outer_instruction_index,
        input_mint,
        output_mint
    FROM jupiter_v6_solana.jupiter_evt_swapevent
   WHERE evt_block_date >= DATE '2026-01-01'
   AND evt_block_date < DATE '2026-07-01'
),

token_events AS (
    SELECT
        week,
        evt_tx_id,
        evt_outer_instruction_index,
        input_mint AS token_mint,
        1 AS input_seen,
        0 AS output_seen
    FROM route_events

    UNION ALL

    SELECT
        week,
        evt_tx_id,
        evt_outer_instruction_index,
        output_mint AS token_mint,
        0 AS input_seen,
        1 AS output_seen
    FROM route_events
),

token_roles AS (
    SELECT
        week,
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint,
        MAX(input_seen) AS input_seen,
        MAX(output_seen) AS output_seen
    FROM token_events
    GROUP BY 1, 2, 3, 4
),

final_outputs AS (
    SELECT
        week,
        evt_tx_id,
        evt_outer_instruction_index,
        token_mint AS final_token_mint
    FROM token_roles
    WHERE output_seen = 1
      AND input_seen = 0
),

classified AS (
    SELECT
        f.week,
        f.evt_tx_id,
        f.evt_outer_instruction_index,

        CASE
            WHEN m.token_mint IS NOT NULL THEN m.category
            WHEN f.final_token_mint LIKE '%pump'
              OR f.final_token_mint LIKE '%bonk'
                THEN 'Meme Coin'
            ELSE 'Unmapped'
        END AS category,

        CASE
            WHEN m.token_mint IS NOT NULL THEN 'manual'
            WHEN f.final_token_mint LIKE '%pump'
              OR f.final_token_mint LIKE '%bonk'
                THEN 'suffix'
            ELSE 'unmapped'
        END AS mapping_method

    FROM final_outputs f
    LEFT JOIN manual_mapping m
        ON f.final_token_mint = m.token_mint
)

SELECT
    week,
    category,
    mapping_method,
    COUNT(*) AS final_routes,
    ROUND(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER (PARTITION BY week),
        2
    ) AS share_of_final_routes_pct
FROM classified
GROUP BY 1, 2, 3
ORDER BY week, final_routes DESC;
