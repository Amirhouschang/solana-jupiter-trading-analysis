-- Q4: Token category mapping — 105 tokens, H1 2026
-- Scope: top 100 by trade count (88% of swap events, see C1) plus 5 tokens
--   surfaced by the volume ranking in Q3. Everything else falls to 'Other'.
-- Categories are an analytical judgement, not an official taxonomy.
--
-- RULES USED
-- Native Solana     protocol tokens of Solana-native projects (JUP, RAY, ORCA, KMNO...)
-- Liquid Staking    staked SOL derivatives — held for yield, traded rarely
-- Stablecoin        fiat-pegged, incl. yield-bearing variants
-- Cross-Chain Asset assets originating on another chain (wrapped or bridged)
-- Meme Coin         no utility claim; includes all pump.fun / bonk launches
-- Tokenized RWA     real-world assets: equities and commodities
-- Other             unclear, unverifiable, or not a genuine project
--
-- The `flag` column marks tokens that are analytically suspect but still present
-- in the data. 'impostor' = imitates an established token's name and symbol.
-- Flagged rows stay in the dataset; the flag lets them be excluded or reported
-- separately rather than silently dropped.
--
-- NOTE: WSOL is classified as Native Solana, not Cross-Chain. It is the wrapped
-- form of SOL for SPL compatibility, not a bridged asset.
-- NOTE: mint Es9vdPD6sXzHhbAskU19WFnAtyRo94HKrGrPSdQ3aSSB is named 'USD Tether'
-- with symbol 'USDT', but is NOT the real USDT
-- (Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB). Unverified, created 5 months
-- ago, 3.49B supply across only 928 holders, no price feed. 182,595 swaps in
-- the period, then a single sell took the price from 1.00 to 0.0008 within
-- minutes. 24h volume 1.56 USD. Classified as Other, flagged 'impostor'.
--
-- NOTE: metadata in tokens_solana.fungible is unreliable in two ways. Some rows
-- are missing entirely (bSOL has no symbol or name). Others hold outdated values
-- from the first mint: PENGU is still labelled 'test', Moonbirds still 'SPLT'.
-- All tokens were verified manually via Solscan. This is why categorisation
-- runs on mint addresses, never on symbols.

SELECT token_mint, category, flag FROM (VALUES

  -- Native Solana
  ('So11111111111111111111111111111111111111112',  'Native Solana', NULL),      -- WSOL
  ('pumpCmXqMfrsAkQ5r49WcJnRayYRqmXz6ae8H7H9Dfn',  'Native Solana', NULL),      -- PUMP
  ('27G8MtK7VtTcCHkpASjSDdkWWYfoqT6ggEuKidVJidD4', 'Native Solana', NULL),      -- JLP
  ('JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN',  'Native Solana', NULL),      -- JUP
  ('4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R', 'Native Solana', NULL),      -- RAY
  ('orcaEKTdK7LKz57vaAYr9QeNsVEPfiu6QeMU1kektZE',  'Native Solana', NULL),      -- ORCA
  ('KMNo3nJsBXfcpJTVhZcXLW7RmTwTt4GVFE7suUBo9sS',  'Native Solana', NULL),      -- KMNO
  ('METvsvVRapdj9cFLzq4Tr43xK4tAjQfwX76z3n6mWQL',  'Native Solana', NULL),      -- MET
  ('SarosY6Vscao718M4A778z4CGtvcwcGef5M9MEH1LGL',  'Native Solana', NULL),      -- SAROS
  ('SKRbvo6Gf7GondiT3BbTfuRDPqLWei4j2Qy2NPGZhW3',  'Native Solana', NULL),      -- SKR
  ('jtojtomepa8beP8AuQc6eXt5FriJwfFMwQx2v2f9mCL',  'Native Solana', NULL),      -- JTO
  ('METAewgxyPbgwsseH8T16a39CQ5VyVxZi9zXiDPY18m',  'Native Solana', NULL),      -- MPLX
  ('DBRiDgJAMsM95moTzJs7M9LnkGErpbv9v6CUR1DXnUu5', 'Native Solana', NULL),      -- DBR
  ('hntyVP6YFm1Hg25TN9WGLqM12b8TQmcknKrdu1oxWux',  'Native Solana', NULL),      -- HNT
  ('7JA5eZdCzztSfQbJvS8aVVxMFfd81Rs9VvwnocV1mKHu', 'Native Solana', NULL),      -- GEOD
  ('oreoU2P8bN6jkk3jbaiVxYnG1dCXcYxwhwyK9jSybcp',  'Native Solana', NULL),      -- ORE
  ('ZBCNpuD7YMXzTHB2fhGkGi78MNsHGLRXUhRewNRm9RU',  'Native Solana', NULL),      -- ZBCN
  ('J6pQQ3FAcJQeWPPGppWRb4nM8jU3wLyYbRrLh7feMfvd', 'Native Solana', NULL),      -- 2Z
  ('WETZjtprkDMCcUxPi9PfWnowMRZkiGGHDb9rABuRZ2U',  'Native Solana', NULL),      -- WET

  -- Liquid Staking
  ('J1toso1uCk3RLmjorhTtrVwY9HJ7X8V9yYac6Y7kGCPn', 'Liquid Staking', NULL),     -- JitoSOL
  ('mSoLzYCxHdYgdzU16g5QSh3i5K3z3KZK7ytfqcJm7So',  'Liquid Staking', NULL),     -- mSOL
  ('jupSoLaHXQiZZTSfEWMTRRgpnyFm8f6sZdosWBjx93v',  'Liquid Staking', NULL),     -- JupSOL
  ('7dHbWXmci3dT8UFYWYZweBLXgycu7Y3iL6trKn1Y7ARj', 'Liquid Staking', NULL),     -- stSOL
  ('bSo13r4TkiE4KumL71LsHTPpL2euBYLFx6h9HP3piy1',  'Liquid Staking', NULL),     -- bSOL (no metadata row)
  ('5oVNBeEEQvYi1cX3ir8Dx5n1P7pdxydbGF2X4TxVusJm', 'Liquid Staking', NULL),     -- INF (prices.day shows legacy symbol SCNSOL)

  -- Stablecoin
  ('EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v', 'Stablecoin', NULL),         -- USDC
  ('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB', 'Stablecoin', NULL),         -- USDT (real)
  ('USD1ttGY1N17NEEHLmELoaybftRBUSErhqYiQzvEmuB',  'Stablecoin', NULL),         -- USD1
  ('2u1tszSeqZ3qBWF3uNGPFc8TzMk2tdiwknnRMWGWjGWH', 'Stablecoin', NULL),         -- USDG
  ('JuprjznTrTSp2UFa3ZBUFgwdAmtZCq4MQCwysN55USD', 'Stablecoin', NULL),          -- JupUSD
  ('2b1kV6DkPAnxd5ixfnxCpjxmKwqjjaYmCZfHsFu24GXo', 'Stablecoin', NULL),         -- PyUSD
  ('HzwqbKZw8HxMN6bF2yFZNrht3c2iXXzpKcFu7uBEDKtr', 'Stablecoin', NULL),         -- EURC
  ('USDSwr9ApdHk5bvJKMjzff41FfuX8bSxdKcR81vTwcA',  'Stablecoin', NULL),         -- USDS
  ('5YMkXAYccHSGnHn9nob9xEvv6Pvka9DZWH7nTbotTu9E', 'Stablecoin', NULL),         -- hyUSD
  ('AvZZF1YaZDziPY2RCK4oJrRVrbN3mTD9NL24hPeaZeUj', 'Stablecoin', NULL),         -- syrupUSDC
  ('CASHx9KJUStyftLFWGvEVf59SGeG9sh5FfcnZMVPCASH', 'Stablecoin', NULL),         -- CASH (verified, price 0.9997)
  ('DEkqHyPN7GMRJ5cArtQFAWefqbZb33Hyf6s5iCwjEonT', 'Stablecoin', NULL),         -- USDe, Ethena
  ('7GxATsNMnaC88vdwd2t3mwrFuQwwGvmYPrUQ4D6FotXk', 'Stablecoin', NULL),         -- jlJupUSD, Jupiter Lend
  ('6FrrzDk5mQARGc1TDYoyVnSyRdds1t4PbtohCD6p3tgG', 'Stablecoin', NULL),         -- USX

  -- Cross-Chain Asset
  ('cbbtcf3aa214zXHbiAZQwf4122FBYbraNdFqgw4iMij',  'Cross-Chain Asset', NULL),  -- cbBTC
  ('7vfCXTUXx5WJV5JADk17DUJ4ksgau7utNKj4b963voxs', 'Cross-Chain Asset', NULL),  -- WETH
  ('3NZ9JMVBmGAqocybic2c7LQCJScmgsAZ6vQqTDzcqmJh', 'Cross-Chain Asset', NULL),  -- WBTC
  ('CtzPWv73Sn1dMGVU3ZtLv9yWSyUAanBni19YWDaznnkn', 'Cross-Chain Asset', NULL),  -- xBTC
  ('zBTCug3er3tLyffELcvDNrKkCymbPWysGcWihESYfLg',  'Cross-Chain Asset', NULL),  -- zBTC
  ('98sMhvDwXj1RQi5c5Mndm3vPe9cBqPrbLaufMXFNMh5g', 'Cross-Chain Asset', NULL),  -- HYPE
  ('A7bdiYdS5GjqGFtxf17ppRHtDKPkkRqbKtR27dxvQXaS', 'Cross-Chain Asset', NULL),  -- ZEC
  ('CrAr4RRJMBVwRsZtT62pEhfA9H5utymC2mVx8e7FreP2', 'Cross-Chain Asset', NULL),  -- MON
  ('EicWvteVi2fWepEzS3FYWsnuPoP6caZfjnKqNvydLjCH', 'Cross-Chain Asset', NULL),  -- LIT, Lighter (Ethereum zk-rollup perps protocol)

  -- Tokenized RWA
  ('XsDoVfqeBukxuZHWhdvWHBhgEHjGNst4MLodqsJHzoB',  'Tokenized RWA', NULL),      -- TSLAx
  ('XsueG8BtpquVJX9LVLLEGuViXUungE6WmK5YZ3p3bd1',  'Tokenized RWA', NULL),      -- CRCLx
  ('Xsc9qvGR1efVDFGLrVsmkzv3qi45LTBjeUKSPmx9qEh',  'Tokenized RWA', NULL),      -- NVDAx
  ('XsoCS1TfEyfFhfvj8EtZ528L3CaKBDBRqRapnBbDF2W',  'Tokenized RWA', NULL),      -- SPYx
  ('SPCXxcqXj6e5dJDVNovHN8744zkbhM2bYudU45BimGb',  'Tokenized RWA', NULL),      -- SPCX
  ('AymATz4TCL9sWNEEV9Kvyz45CHVhDZ6kUgjTJPzLpU9P', 'Tokenized RWA', NULL),      -- XAUt0 (gold)
  ('kLqMvUm1p4pRbxU4r8kWCTVAuWMJLtcTJqGb4b5pump',  'Tokenized RWA', NULL),      -- BRENT (oil)
  ('USoRyaQjch6E18nCdDvWoRgTo6osQs9MUd8JXEsspWR',  'Tokenized RWA', NULL),      -- USOR (oil)
  ('5Y8NV33Vv7WbnLfq3zBcKSdYPrk7g2KoiQoe7M2tcxp5', 'Tokenized RWA', NULL),      -- ONyc, OnRe Tokenized Reinsurance (Dune symbol 'ONe')
  ('Xs8S1uUs1zvS2p7iwtsG3b6fkhpvmwz4GYU3gWAmWHZ',  'Tokenized RWA', NULL),      -- QQQx, Nasdaq-100 xStock

  -- Meme Coin
  ('9BB6NFEcjBCtnNLFko2FqVQBq8HHM13kCyYcdQbgpump', 'Meme Coin', NULL),          -- Fartcoin
  ('DMYNp65mub3i7LRpBdB66CgBAceLcQnv4gsWeCi6pump', 'Meme Coin', NULL),          -- bingwu
  ('6p6xgHyF7AeE6TZkSmFsko444wqoP15icUSqi2jfGiPN', 'Meme Coin', NULL),          -- TRUMP
  ('8jiVXftnn2ZG6bugK7HAH5j2G3D6TpsG521gqsWwpump', 'Meme Coin', NULL),          -- AUTISM
  ('DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263', 'Meme Coin', NULL),          -- Bonk
  ('Dz9mQ9NzkBcCsuGPFJ3r1bS4wgqKMHBPiVuniW8Mbonk', 'Meme Coin', NULL),          -- USELESS
  ('a3W4qutoEJA4232T2gwZUfgYJTetr96pU4SJMwppump',  'Meme Coin', NULL),          -- WhiteWhale
  ('Dfh5DzRgSvvCFDoYc2ciTkMrbDfRKybA4SoFbPmApump', 'Meme Coin', NULL),          -- pippin
  ('BBG3vpXVCm2uPBD7LUr7yfP9XUXVNJRHMtiMG7q4pump', 'Meme Coin', NULL),          -- PURK
  ('8Jx8AAHj86wbQgUTjGuj6GTTL5Ps3cqxKRTvpaJApump', 'Meme Coin', NULL),          -- PENGUIN
  ('7fj85y28pKMndm4So66Szkb5GMGfLHFEkwsZdDx2pump', 'Meme Coin', NULL),          -- NICE
  ('CreiuhfwdWCN5mJbMJtA9bBpYQrQF2tCBuZwSPWfpump', 'Meme Coin', NULL),          -- PYTHIA
  ('CAjtTHvC878f8cZ4zEwdvgjkjFM7rbYN8Mb1go1cpump', 'Meme Coin', NULL),          -- DUMBMONEY
  ('7GCihgDB8fe6KNjn2MYtkzZcRjQy3t9GHdC8uHYmW2hr', 'Meme Coin', NULL),          -- POPCAT
  ('4TyZGqRLG3VcHTGMcLBoPUmqYitMVojXinAmkL8xpump', 'Meme Coin', NULL),          -- testicle
  ('4D9jZY6nkXnm3ofmWWJVcJrvtXDMfE5Zwy8rZMy5pump', 'Meme Coin', NULL),          -- JEW
  ('pixvL7orpc8AfVUmeQ3kJZ588EegnXSQd7UW4TcVzDk',  'Meme Coin', NULL),          -- PIXELS
  ('EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm', 'Meme Coin', NULL),          -- $WIF
  ('61V8vBaqAGMpgDQi4JcAwo1dmBGHsyhzodcPqnEVpump', 'Meme Coin', NULL),          -- arc
  ('3BHhMXMyyGGzLcTk6u5iJwTcV7eEGG9bWJrTKUttpump', 'Meme Coin', NULL),          -- FML
  ('J3NKxxXZcnNiMjKw9hYb2K4LUxgwB6t1FtPtQVsv3KFr', 'Meme Coin', NULL),          -- SPX
  ('6MFiqqkS4MUwmkoa8sj5UJcFzJGVxHD1yEpoyRRUdoge', 'Meme Coin', NULL),          -- TARO
  ('kMKX8hBaj3BTRBbeYix9c16EieBP5dih8DTSSwCpump',  'Meme Coin', NULL),          -- afk
  ('4FdojUmXeaFMBG6yUaoufAC5Bz7u9AwnSAMizkx5pump', 'Meme Coin', NULL),          -- core
  ('E714f3oiK3sA8WGBBpmgx7Vkptz7Xh7H9YNWjpkLpump', 'Meme Coin', NULL),          -- $JAC
  ('8opvqaWysX1oYbXuTL8PHaoaTiXD69VFYAX4smPebonk', 'Meme Coin', NULL),          -- WAR
  ('FmjijgwEHpe32VPvHy1s7u7TLthh9yu1j75djVbWpump', 'Meme Coin', NULL),          -- DEGEN
  ('ChNrhBZwGtn1ZRsrdzcuBqiKTYfVViCPZqJdsgBHpump', 'Meme Coin', NULL),          -- APES
  ('NV2RYH954cTJ3ckFUpvfqaQXU4ARqqDH3562nFSpump',  'Meme Coin', NULL),          -- Punch
  ('8f62NyJGo7He5uWeveTA2JJQf4xzf8aqxkmzxRQ3mxfU', 'Meme Coin', NULL),          -- FIGHT
  ('Cm6fNnMk7NfzStP9CZpsQA2v3jjzbcYGAxdJySmHpump', 'Meme Coin', NULL),          -- Buttcoin
  ('5UUH9RTDiSpq6HKS6bp4NdU9PNJpXRXuiw6ShBTBhgH2', 'Meme Coin', NULL),          -- TROLL
  ('JE8zmsKRivXggZsJxXHBdCkako85YawNtU5hqS4upump', 'Meme Coin', NULL),          -- PAX
  ('x95HN3DWvbfCBtTjGm587z8suK3ec6cwQwgZNLbWKyp',  'Meme Coin', NULL),          -- $HACHI
  ('Ce2gx9KGXJ6C9Mp5b5x1sn9Mg87JwEbrQby4Zqo3pump', 'Meme Coin', NULL),          -- neet
  ('8Hg96R1AGDe5vKABwniVPT2LHdhZHmCTFijZAXXZpump', 'Meme Coin', NULL),          -- XSPA
  ('4YiLHDR4B4pE4R5GUMA8HG8YunyeLwcobtEtvwMupump', 'Meme Coin', NULL),          -- ROCKET
  ('2zMMhcVQEXDtdE6vsFS7S7D5oUodfJHE8vd1gnBouauv', 'Meme Coin', NULL),          -- PENGU, Pudgy Penguins (Dune symbol 'test')
  ('G7vQWurMkMMm2dU3iZpXYFTHT9Biio4F4gZCrwFpKNwG', 'Meme Coin', NULL),          -- BIRB, Moonbirds (Dune symbol 'SPLT')
  ('HmBdm8vbisABUjkxms6ZUnoaXbfwFM6ymxShWfAENaoi', 'Meme Coin', NULL),          -- EITHER, Eitherway
  ('NgsodHAjoLZF5VC25euE1wBiZUgTVMHSErMRRKt74mA',  'Meme Coin', NULL),          -- NGMA, EnigmaAI
  ('2k8yZaJjf61unHriuqdmvbxe7CUhEYML5kVJDbcotKjU', 'Meme Coin', NULL),          -- BFS
  ('gLEXZ2kAfuYkpeeSzrEMbakiNeqAAZ3TsKiY9Can8pE',  'Meme Coin', NULL),          -- SPARQ, TheContentForge
  ('1ogCsoK7ZqZwiYam9i7xq2j6Bf2LizT6iQtGSp6vCoT',  'Meme Coin', NULL),          -- LOG
  ('C8fU5GdfAt5mnw2RK7HE6XJGFNxHpaskZMkXxdm88888', 'Meme Coin', NULL),          -- CTM, c8ntinuum
  ('FeR8VBqNRSUD5NtXAj2n3j1dAHkZHfyDktKuLXD4pump', 'Meme Coin', NULL),          -- jellyjelly

  -- Other
  ('Es9vdPD6sXzHhbAskU19WFnAtyRo94HKrGrPSdQ3aSSB', 'Other', 'impostor')  -- 'USD Tether', see note above

) AS t (token_mint, category, flag)
