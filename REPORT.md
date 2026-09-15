# Detailed Findings

A full walk-through of the analysis behind
[What Solana Actually Trades](https://dune.com/amirhoushang/what-solana-actually-trades).
The [README](README.md) covers the summary and the method; this document goes
through each result in turn.

**Period:** 1 January – 30 June 2026
**Source:** `jupiter_v6_solana.*` on Dune Analytics

---

## 1. Scale

| Metric | H1 2026 |
|---|---|
| Swap events | 465,238,625 |
| Distinct user swaps | 267,562,076 |
| Distinct traders | 7,970,524 |
| DEX programs used | 89 |
| Distinct output tokens | 1,074,350 |

The gap between the first two rows is the first result of the project. A user
places one order; Jupiter may fill it from several venues. 465 million events
resolve to 268 million actual trades — **1.74 legs per trade on average**.

Every figure in this report is labelled as either event-level or
transaction-level, because the two answer different questions. Event counts
measure pool activity. Transaction counts measure how often people traded.

A million distinct tokens were bought in six months. That number alone says
something about the composition of the ecosystem before any categorisation
begins.

---

## 2. What is traded — two rankings that disagree

### By number of swaps

![Top 5 tokens by trade count](images/top5_by_trade_count.png)

| Rank | Token | User swaps |
|---|---|---|
| 1 | SOL (WSOL) | 153,912,777 |
| 2 | USDC | 120,696,657 |
| 3 | USDT | 32,636,451 |
| 4 | USD1 | 15,062,058 |
| 5 | cbBTC | 5,921,906 |

The top four are SOL and three stablecoins. Position five drops to under
6 million — a factor of 26 below the leader. The distribution is extremely
skewed, which is why the charts in this project are split rather than crammed
into one axis.

### By USD volume

![Top 5 tokens by volume](images/top5_by_volume.png)

| Rank | Token | Volume |
|---|---|---|
| 1 | **USDC** | $82.9bn |
| 2 | SOL | $76.1bn |
| 3 | USDT | $19.2bn |
| 4 | USD1 | $11.6bn |
| 5 | JLP | $1.8bn |

**The leader changes.** USDC moves more capital than SOL despite 33 million
fewer swaps. The same six months of data, a different question, a different
answer.

### Why: average priced swap-event size

| Token | Average priced event |
|---|---|
| jlJupUSD | $16,657 |
| CASH | $1,818 |
| USX | $933 |
| USD1 | $764 |
| USDC | $651 |
| SOL | $476 |
| Fartcoin | $91 |
| PENGU | $77 |
| BONK | $50 |
| RAY | $25 |

The spread is wide. jlJupUSD recorded only 6,013 swaps in six months but
averaged **$16,657 each**. At the other end, RAY averages $25 across 592,794
swaps. Three orders of magnitude between them, in the same venue, in the same
six months. What kind of participant sits behind each is not something this data
answers.

This figure is computed per priced swap event, not per transaction. Where a
transaction produced several events, each counts separately, so the value is a
lower bound on the size of a full user order.

Neither ranking is wrong. Trade count measures how frequently a token is traded;
volume measures how much capital moved. A dashboard that shows only one of them
tells a third of the story.

---

## 3. What kind of asset — categorisation

105 tokens were classified manually into seven categories, verified individually
on Solscan. Tokens beyond that set are matched by mint suffix (`pump`, `bonk`)
where possible; the remainder is reported as `Unmapped`.

![Category breakdown](images/category_breakdown.png)

| Category | Share of swaps | Traders | DEX programs |
|---|---|---|---|
| Stablecoin | 39.33% | 2,400,577 | 75 |
| Native Solana | 38.13% | 6,433,223 | 74 |
| Unmapped | 5.95% | 1,065,941 | 73 |
| Meme Coin (suffix) | 5.93% | 1,427,176 | 23 |
| Meme Coin (manual) | 5.05% | 3,399,235 | 34 |
| Cross-Chain Asset | 3.91% | 141,351 | 42 |
| Liquid Staking | 1.23% | 65,122 | 32 |
| Tokenized RWA | 0.43% | 27,915 | 22 |
| Other | 0.04% | 261 | 1 |

Three observations.

**Stablecoins and native Solana assets are 77% of all activity.** The ecosystem
that gets written about — meme coins, launchpads — is 11% of the trading.

One qualification on that figure: categories are assigned from the output token
of each swap event, and a route A → SOL → B records SOL as an output alongside B.
The shares therefore describe execution activity rather than what traders set out
to acquire, and the stablecoin and native Solana figures are likely inflated by
an amount this analysis does not measure.

**Meme coins reach more distinct wallets than stablecoins.** The manually
verified meme coin group alone records 3.4 million distinct signers against 2.4
million for stablecoins, for a fifth of the activity. The suffix-matched group
adds a further 1.4 million, but the two groups may overlap, so they are not
summed here. Combined with the event sizes above, the pattern is many addresses
trading small amounts against fewer addresses moving large ones. Distinct signers
are wallet addresses, not necessarily distinct people.

**Meme coins reach far fewer venues.** 23 and 34 DEX programs, against 75 for
stablecoins. That number turns out to explain the routing result in section 5.

The `Mapping` column is deliberate. It shows how much of the classification was
individually verified (`manual`) and how much rests on a rule (`suffix`).
5.05 of the 11.0 percentage points for meme coins are checked token by token;
the rest is inferred from the mint address. Stating that is more useful than a
single combined number.

`Unmapped` at 5.95% is the long tail the classification does not reach. It is
reported rather than folded into another category.

---

## 4. Where it executes

![Top 5 DEX programs](images/top5_dex_programs.png)

Jupiter routed through **89 different DEX programs**. No venue dominates: the
largest, PumpSwap, carries 9.6% of swap events, and the top five together reach
only 42%.

![DEX programs table](images/dex_programs_table.png)

The interesting column is `Tokens served`.

| Program | Share of swaps | Tokens served |
|---|---|---|
| PumpSwap | 9.6% | 128,432 |
| HumidiFi | 9.4% | **29** |
| Orca Whirlpool | 8.7% | 7,931 |
| BisonFi | 7.3% | **11** |
| Meteora DLMM | 6.9% | 7,668 |
| Meteora DAMM v2 | 4.1% | 308,772 |
| SolFi V2 | 5.6% | **11** |

Two entirely different business models sit next to each other in this table.

**HumidiFi serves 29 tokens and carries 9.4% of all routing.** BisonFi serves 11
tokens for 7.3%. SolFi V2 serves 11 for 5.6%. These are deep, specialised venues
for the assets that actually move capital — stablecoin and SOL pairs.

**PumpSwap serves 128,432 tokens for 9.6%.** Meteora DAMM v2 serves 308,772 for
4.1%. These are broad launchpad markets, where the token count is enormous and
the per-token volume is not.

Both matter to Jupiter, for opposite reasons. One provides depth, the other
provides coverage.

One caveat worth stating: of these top 20 programs, only Manifest carries a
verified-program badge on Solscan. A missing badge means the program's source
has not been published for verification there — it is not in itself a security
assessment. The names in this table come from Solscan's public labels.

---

## 5. Routing complexity — the hypothesis was wrong

This metric did not come from the data. It came from a trade: a single wrapped
BTC purchase where Jupiter pulled the token from three separate pools. One
action for the user, three events on chain.

Formalised: **swap events per transaction, by category.** Each transaction is
assigned to one category — the one with the most swap events in it, ties broken
alphabetically — and only the events of that category are counted. The figure is
therefore events within the dominant category per transaction, not the full leg
count of every transaction.

The expectation was that meme coins, with scattered liquidity, would force more
splitting.

![Routing complexity](images/routing_complexity.png)

| Category | DEX legs per swap |
|---|---|
| **Stablecoin** | **1.55** |
| Cross-Chain Asset | 1.20 |
| Liquid Staking | 1.19 |
| Native Solana | 1.10 |
| Unmapped | 1.07 |
| Tokenized RWA | 1.07 |
| Meme Coin | 1.03 |
| Other | 1.00 |

The result is the opposite of the hypothesis. Stablecoins split the most, meme
coins the least.

Section 4 offers a possible explanation. Stablecoins appear across 75 of the 89
DEX programs, meme coins across 23 to 34. Note that these are programs, not
individual pools — pool-level detail is not available in this table.

One hypothesis for this is that where more venues exist, Jupiter has more to
split across, and splitting can yield a better price. The data here is
consistent with that but does not establish it — unused routing options are not
observable in this dataset, and the query examines neither route ordering nor
whether a split improved execution.

What can be said is narrower: transactions assigned to the stablecoin category
carry more swap events within that category than transactions assigned to meme
coins. The metric was designed to measure liquidity fragmentation and does not
do that.

A note on how this was caught: the first version of the query returned 0.95 legs
per swap for one category. That is mathematically impossible — the minimum is
1.0. The impossible value exposed a counting error: transactions touching
several categories were being counted more than once. Assigning each transaction
to a single category fixed it, and sharpened the result. The stablecoin–meme
coin gap widened from 1.30 vs 1.02 to 1.55 vs 1.03.

---

## 6. What it costs — read the coverage first

Absolute fees follow category size, so they compare nothing. Fee per dollar of
volume does — but only within a limit that has to be stated before the numbers.

**Jupiter does not record a fee event on every route.** The share of transactions
that carry one varies sharply by category:

| Category | Transactions | With fee event | Coverage |
|---|---|---|---|
| Native Solana | 118,460,887 | 9,385,313 | 7.92% |
| Liquid Staking | 3,370,006 | 78,233 | 2.32% |
| Unmapped | 16,355,364 | 253,016 | 1.55% |
| Tokenized RWA | 573,675 | 8,847 | 1.54% |
| Stablecoin | 68,525,537 | 930,935 | 1.36% |
| Meme Coin | 46,677,517 | 302,363 | 0.65% |
| Cross-Chain Asset | 13,425,990 | 68,801 | 0.51% |
| Other | 173,100 | 0 | 0% |

A factor of fifteen between the widest and narrowest coverage. Everything below
is computed on those subsets.

![Recorded fee rate by category](images/fee_rate_by_category.png)

| Category | Fee rate (bps) | Total fees | Volume | Transactions |
|---|---|---|---|---|
| Unmapped | 39.00 | $36,273 | $9.3M | 19,278 |
| **Meme Coin** | **37.73** | $113,433 | $30.1M | 146,437 |
| Native Solana | 32.01 | $602,461 | $188.2M | 9,304,745 |
| Tokenized RWA | 30.71 | $536 | $174,612 | 6,581 |
| Stablecoin | 23.13 | $602,866 | $260.6M | 916,364 |
| Liquid Staking | 12.48 | $8,802 | $7.1M | 41,148 |
| Cross-Chain Asset | 10.82 | $15,895 | $14.7M | 64,656 |

Among transactions where a fee was recorded, meme coins show the highest rate of
the classified categories at 37.7 basis points, against 23.1 for stablecoins and
10.8 for cross-chain assets. That is a factor of 1.6 and 3.5 respectively.

**What this does and does not say.** It says that on the covered transactions,
the fee rate differs by category in that direction. It does not say that trading
meme coins costs 1.6× more than trading stablecoins — for that, the covered
subset would have to be representative of each category, and representative to a
similar degree across categories. With coverage ranging from 0.65% to 7.92%,
neither can be established from this data.

The ranking is an observation about recorded fee events. It is not a measured
cost of trading.

### How this section was rebuilt

The first version of this query was wrong in a way that was not visible in the
output. It categorised fees by the fee token and volume by the output token,
independently, then joined the two on category name alone.

A check revealed that those two categorisations disagree in roughly three
quarters of cases. The single largest group was *fee paid in a stablecoin on a
SOL purchase* — 137,033 pairs in a one-day sample, against 33,882 where both
sides agreed. Jupiter charges the fee in the input or output token depending on
swap type, so a meme coin purchase routinely produces a fee denominated in USDC.

The consequence: the stablecoin fee figure was largely composed of fees from
native Solana trades. The ratio described nothing coherent.

The rebuilt version assigns each transaction to one category — the one with the
most swap events in it, as in Q7 — and counts both its fees and its volume
towards that category. The numbers changed substantially. The gap between meme
coins and stablecoins narrowed from a factor of 6.4 to 1.6.

Both the error and the correction are in the repository. The earlier figures
should not be cited.

---

## 7. Over time — nothing happens, and that is the finding

![Category composition over time](images/category_over_time.png)

Weekly shares across H1 2026:

The bands run close to flat. Stablecoins and native Solana assets together hold
roughly three quarters of activity in every week of the period, and no category
changes rank. Individual weeks do move — the chart shows visible dips and
recoveries — so the stability is in the overall structure rather than in each
week's exact share.

This is the least dramatic chart in the project and possibly the most
interesting one. A mix that holds across six months of market movement is at
least consistent with the composition being a structural feature rather than a
response to conditions, though six months is not long enough to distinguish the
two.

Testing that properly would require a longer window — it is the obvious next
step for this analysis.

---

## 8. Things found along the way

None of these were in the plan.

### Jupiter is absent from the standard table

`dex_solana.trades` is Dune's curated DEX table. Filtering it for
`project = 'jupiter'` returns zero rows.

The reason is structural: Jupiter is an aggregator and holds no pools. The
trades it routes are recorded under the executing venues — PumpSwap, HumidiFi,
Orca Whirlpool, Meteora. Working with Jupiter means using decoded protocol
events instead.

That turned into the opening section of the dashboard rather than an obstacle.

### Token metadata cannot be trusted

`tokens_solana.fungible` failed in two different ways.

Some rows are missing entirely: bSOL (BlazeStake Staked SOL, $92m market cap)
has no symbol and no name at all.

Others are frozen at first mint. PENGU — Pudgy Penguins, $542m market cap,
557,116 holders — is still labelled `test` in Dune, because that was its name
when the token was deployed. Moonbirds still shows as `SPLT`.

Both were caught by verifying the top tokens on Solscan one at a time. This is
why the categorisation joins on mint addresses and never on symbols.

### An impostor in the top 100

Mint `Es9vdPD6sXzHhbAskU19WFnAtyRo94HKrGrPSdQ3aSSB` carries the name "USD Tether"
and the symbol "USDT". The real USDT is `Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB`.
Both start with `Es9v`.

What the checks showed: unverified on Solscan, created in January 2026, five months before the
period ended, 3.49bn supply across only **928 holders**, no working price feed.
It recorded 182,595 swaps. Then a single sell took the price from $1.00 to
$0.0008 within minutes. Its 24-hour volume at time of checking was $1.56.

It sits in the dataset classified as `Other` with `flag = 'impostor'` — kept so
it can be reported, excluded from stablecoin figures so it cannot distort them.
Deleting it would have removed a finding.

This is the clearest single argument for categorising on mint addresses. A
symbol-based classification would have counted it as a stablecoin and added
182,595 swaps to that category.

---

## 9. What would come next

- **A longer window.** Six months showed stability; twelve or twenty-four would
  show whether that holds across a full market cycle.
- **Solana network fees as a second cost layer.** The current analysis covers
  Jupiter's protocol fee only. Network fees would show the full cost of a trade,
  and routing complexity predicts they diverge by category.
- **Shrinking `Unmapped`.** At 5.95% it is small but has the highest fee rate in
  the dataset, which suggests it is not homogeneous.
- **Directional flow.** Every swap has a buy and a sell side. Splitting them
  would show net flow per category — whether capital was moving into stablecoins
  or out of them, week by week.
- **The same question on Ethereum.** Different data model, same structure. A
  comparison would show whether these proportions are a Solana property or a DEX
  property.
- **Understanding the fee event coverage.** Section 6 rests on 0.5 to 8 percent
  of transactions depending on category. Establishing why some routes record a
  fee event and others do not would turn that section from an observation into a
  measurement.
- **Separating final outputs from intermediate hops.** That would turn the
  category shares from a picture of execution activity into a picture of trading
  intent.

---

## Limitations

The full list is in the [README](README.md#limitations). The four that matter
most when reading this report:

- **Price coverage is uneven.** 100% for liquid staking, 89% for native Solana,
  82% for stablecoins, but only **24% for meme coins**. Meme coin volume and
  fees in sections 2 and 6 are understated.
- **Only Jupiter v6.** Direct pool swaps and other aggregators are not visible
  here. The aggregator is itself a filter on what is observed.
- **Categorisation is a judgement**, published as Q4 and checkable line by line.
  Someone else could draw the boundaries differently and get different numbers.
- **Wash trading and bots** are real on DEXes and cannot be fully filtered. Trade
  counts, particularly for meme coins, are inflated by an unknown amount.
- **Fee event coverage is narrow and uneven** — 0.51% to 7.92% depending on
  category. Section 6 is computed on that subset only.
- **Intermediate hops count as outputs.** Category shares in sections 2 and 3
  describe execution activity, not final trading intent.

The analysis describes trading behaviour, not its causes. No causal claims.
Not investment advice.
