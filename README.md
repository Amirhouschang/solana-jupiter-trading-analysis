# What Solana Actually Trades — A Jupiter v6 Analysis

On-chain analysis of six months of trading through Jupiter, the routing layer of
the Solana DEX ecosystem. Built with SQL on Dune Analytics.

**Dashboard:** https://dune.com/amirhoushang/what-solana-actually-trades
**Period:** 1 January – 30 June 2026
**Data:** `jupiter_v6_solana.*`, `prices.day`, `tokens_solana.fungible` on Dune

**Structure:** Part 1 measures event-level execution. Part 2 reconstructs Jupiter
route groups to separate final outputs from intermediate routing tokens.

---

## The question

> What is actually traded through Jupiter, how is it executed, and what fees are recorded?

Part 1 answers this from swap-event data. Part 2 asks the follow-up question that
event-level outputs cannot answer on their own: *what remains as the final output
of a route, and how does that differ from the tokens seen during execution?*

Jupiter is not an exchange. It holds no liquidity of its own; it finds the best
path for a swap across the underlying AMM programs. That makes it a single
observation point for trading behaviour across the ecosystem rather than one venue.

## The finding

**Trade count, volume and recorded fees produce three different rankings.**

| Ranked by | Leader | Runner-up |
|---|---|---|
| Estimated transactions per output token | SOL — 153.9M | USDC — 120.7M |
| Priced swap-event output volume | **USDC — $82.9bn** | SOL — $76.1bn |
| Recorded fee ratio (classified categories) | **Meme Coin — 37.7 bps** | Native Solana — 32.0 bps |

*Unmapped is higher overall at 39.0 bps.*

![Recorded fee ratio by category](images/fee_rate_by_category.png)

*Recorded fees divided by priced swap-event output volume, on transactions with
at least one priced fee event and one priced swap event. These transactions are
0.12%–7.85% of each category's transactions (fee-event coverage in C2:
0.51%–7.92%), so the ranking describes recorded fee events, not the measured
cost of trading each category.*

Same six months, three different answers. Any dashboard that picks one of them
shows only part of the story.

![Category breakdown](images/category_breakdown.png)

*Share of trading activity by token category. `Mapping` shows whether a token was
verified manually or classified by mint suffix — 5.05 of the 11.0 percentage points
for meme coins are individually verified.*

Two results were not expected:

- **Stablecoin transactions carry the most events, meme coin transactions
  almost the fewest.** Transactions assigned to stablecoins average 1.55 events
  within their dominant category, meme coins 1.03. The initial hypothesis
  expected the opposite. Stablecoin outputs appear on about 75 of the 89 DEX
  programs, meme coin outputs on about 23–34. Whether that explains the gap, or
  whether orders are actually split for a better price, is not established by
  this data.
- **The two largest categories stayed dominant, but shares moved.**
  Stablecoins and native Solana assets together held 71.0–80.1% of weekly swap
  events. Individually: stablecoins 33.6–42.7%, native Solana 35.8–44.6%, meme
  coins 7.5–17.4% (C3). Native Solana ranked above stablecoins in 9 of 27 weeks.
  Six months is too short to tell a structural pattern from a reaction to
  market conditions.

![Category composition over time](images/category_over_time.png)

*Weekly share of swap events per category. Each week sums to 100%, so shifts in
behaviour are visible independently of changes in overall market size.*

### Part 2 — Final outputs and route structure

Part 1 counts every swap-event `output_mint`. That is the correct grain for
execution activity, but a multi-hop route can record intermediate assets as
outputs as well. Part 2 groups events by `(evt_tx_id, evt_outer_instruction_index)`
and classifies token roles inside each route:

- input but never output → start token
- input and output → intermediate token
- output but never input → final output token
- no output-only token → circular / closed route

This does not require assuming an event order. It uses the role each mint plays
across the complete route group.

![All events vs final output](images/final_output_category_shift.png)

| Category | All event outputs | Final output observations | Change |
|---|---:|---:|---:|
| Stablecoin | 39.33% | **31.31%** | **-8.02 pp** |
| Native Solana | 38.13% | 38.29% | +0.16 pp |
| Meme Coin | 10.98% | **18.13%** | **+7.15 pp** |
| Unmapped | 5.95% | 8.77% | +2.82 pp |
| Cross-Chain Asset | 3.91% | 2.59% | -1.32 pp |
| Liquid Staking | 1.23% | 0.45% | -0.78 pp |
| Tokenized RWA | 0.43% | 0.38% | -0.05 pp |
| Other | 0.04% | 0.08% | +0.04 pp |

The picture changes materially. Stablecoins fall by 8.02 percentage points when
only final-output observations are counted, while meme coins rise by 7.15 points.
Native Solana is almost unchanged. Part 1 was therefore not wrong: it measured
execution outputs. What would have been wrong was interpreting those event-level
shares as the tokens traders ultimately received.

Q14 provides a direct reason to expect a difference. Among route groups containing
at least one intermediate token, SOL/WSOL appears as an intermediate in **68.51%**
and USDC in **59.12%**, far ahead of USDT (18.27%) and USD1 (11.90%). Shares are
not mutually exclusive because one route can contain several intermediate tokens.

![Top 5 intermediate-hop tokens](images/top5_intermediate_tokens.png)

The route structure itself is also mixed:

![Jupiter route type distribution](images/route_type_distribution.png)

| Route type | Route groups | Share |
|---|---:|---:|
| Simple | 166,652,857 | 58.53% |
| Circle | 61,396,063 | 21.56% |
| Multi-Hop | 55,103,293 | 19.35% |
| Split | 1,564,669 | 0.55% |

These are operational route classes derived from decoded swap events. `Circle`
means that the route has no output-only token under the set-based role definition;
it does **not** by itself establish arbitrage or user intent.

Final-output category shares exclude those circular routes because they have no
output-only token. A full-period validation also checked whether every remaining
route has exactly one final token. Of **223,320,819 non-circular route groups**,
223,319,337 had one final output token. Only **1,482 routes** had more than one:
1,434 had two, 38 had three and 10 had four. That is about **0.00066%** of
non-circular routes. These rare cases create exactly **1,540 additional
final-output-token observations**, which explains why Q11 contains 223,322,359
final outputs. No route group with a NULL `evt_outer_instruction_index` appeared
in this validation.

---

## Scale

| Metric | H1 2026 |
|---|---|
| Swap events | 465,238,625 |
| Distinct transactions | 267,562,076 |
| Distinct signers | 7,970,524 |
| DEX programs used | 89 |
| Distinct output tokens | 1,074,350 |

---

## How the project was built

This section documents the actual process, including the wrong turns. The
finished queries do not show how they were arrived at.

### 1. The starting point was too vague

The project began as "analyse the Solana ecosystem through Jupiter" — roughly
ten exploratory queries and no central question. The first real work was
narrowing that to a thesis that the data could confirm or refute: *trade count,
volume and cost tell three different stories*.

### 2. Jupiter was not where it was expected to be

The obvious approach was `dex_solana.trades`, Dune's curated DEX table. Filtering
for `project = 'jupiter'` returned zero rows.

A scan of all projects in that table (Q0) showed why: Jupiter is an aggregator,
so the trades it routes are recorded under the executing AMM programs — PumpSwap,
HumidiFi, Orca Whirlpool, Meteora — not under Jupiter. Working with Jupiter means
using decoded protocol events rather than the curated table.

This turned an obstacle into the opening finding of the dashboard.

### 3. The raw data had traps

`jupiter_v6_solana.jupiter_evt_swapevent` is raw event data, not a cleaned table.
Four problems surfaced, each costing time:

- **Duplicate columns.** Both `inputMint`/`input_mint` and `inputAmount`/`input_amount`
  exist. For 2026 only the snake_case ones are populated; the camelCase ones
  silently return zero. The first version of Q1 reported 0 distinct tokens
  because of this.
- **`amm` is a program, not a pool.** The first assumption was that it identified
  individual liquidity pools. A check of distinct output tokens per address
  showed only 89 values, some serving tens or hundreds of thousands of tokens
  — DEX programs, not pools. Two planned queries had to be rewritten.
- **No USD values.** Amounts are raw integers in token units. Volume required
  `/ POWER(10, decimals)` plus a price join.
- **Different address formats.** `prices.day` stores Solana mints as bytes while
  the event tables use base58 strings. `from_base58()` bridges them.

### 4. Metadata could not be trusted

`tokens_solana.fungible` turned out unreliable in two distinct ways:

- Some rows are missing entirely — bSOL has no symbol and no name.
- Others hold values frozen at first mint. PENGU (Pudgy Penguins, $542m market
  cap) is still labelled `test`. Moonbirds still shows as `SPLT`.

Every one of the top 105 tokens was therefore verified manually via Solscan.
This is why the categorisation runs on mint addresses and never on symbols.

### 5. An impostor token in the top 100

Mint `Es9vdPD6sXzHhbAskU19WFnAtyRo94HKrGrPSdQ3aSSB` is named "USD Tether" with
symbol "USDT" — but it is not USDT. The real one is `Es9vMFrza...`; both begin
with `Es9v`.

Checks on Solscan: unverified, created five months earlier, 3.49bn supply across
only 928 holders, no working price feed. It recorded 173,258 swap events in
173,100 transactions, then a single sell took the price from $1.00 to $0.0008
within minutes. 24h volume at time of checking: $1.56.

It is classified `Other` and carries `flag = 'impostor'` — kept in the dataset so
it can be reported, excluded from stablecoin figures so it cannot distort them.
Deleting it would have hidden a real finding.

### 6. Scope had to be justified, not assumed

Over a million distinct tokens were traded in the period. Categorising all of
them is impossible; picking an arbitrary cutoff is unscientific.

A coverage check (C1) settled it: the top 100 tokens cover **88.1%** of all swap
events, the top 500 only **91.9%**. Four hundred more tokens for 3.8 percentage
points is not worth the manual effort. Beyond the top 100, launchpad tokens are
caught by mint suffix (`pump`, `bonk`), and everything remaining is reported as
`Unmapped` — 5.9% of events, visible rather than hidden.

A `mapping_method` column distinguishes manually verified rows from rule-based
ones, so the share of the classification that was actually checked is visible.

### 7. Performance forced compromises

Exact `COUNT(DISTINCT ...)` on 465 million rows times out after two minutes.
`approx_distinct()` replaced it where needed — roughly 2% error, irrelevant for
rankings, and disclosed everywhere it is used.

One consequence surfaced later: at small counts the approximation produced an
impossible value (0.95 legs per swap, when the minimum is 1.0). That was the
signal that Q7 was also counting at the wrong grain — transactions touching
several categories were counted more than once. Restructuring it to assign each
transaction to a single category fixed both problems, and the result became
sharper: the stablecoin–meme coin gap widened from 1.30 vs 1.02 to 1.55 vs 1.03.

### 8. A metric that came from trading, not from the data

The routing complexity measure (Q7) did not come from the tables. It came from a
wrapped BTC purchase where Jupiter had pulled the token from three separate
pools — one action for the user, three events on chain.

That observation became a metric: swap events per transaction within the
dominant category. It is the part of this project least likely to appear in a
tutorial. The result did not support the hypothesis behind it, and the metric
turned out not to measure liquidity fragmentation directly, which made it more
interesting rather than less.

### 9. Event outputs were not necessarily final outputs

The main limitation of Part 1 became the starting point for Part 2. In a route
such as `A → USDC → SOL`, both USDC and SOL appear as event outputs, even though
USDC is only an intermediate routing asset.

C4 inspected the instruction indices directly. C5 then tested a full week
(2–9 March 2026): 90.91% of transactions contained one route group, 9.09%
contained two, and 43 transactions contained three or four. A transaction
therefore cannot safely be treated as identical to one Jupiter route.

The route key used in Part 2 is `(evt_tx_id, evt_outer_instruction_index)`.

### 10. Final output was inferred from token roles, not event order

Within each route, every mint is reduced to two flags: whether it appears as an
input and whether it appears as an output. A token that appears only as output is
a final output; one that appears on both sides is intermediate. A route with no
output-only token is circular / closed under this definition.

This set-based method avoids relying on the ordering of decoded events and makes
the Part 1 versus Part 2 comparison directly reproducible.

### 11. The final-output count was checked explicitly

The full H1 validation accounted for all **284,716,882** route groups in Q10.
There were 61,396,063 with zero final tokens, 223,319,337 with one, 1,434 with
two, 38 with three and 10 with four.

The 1,482 multi-final routes are only about 0.00066% of non-circular routes, but
they matter for naming the metric correctly: Q11 counts **final-output-token
observations**, not an assumed one-final-token-per-route measure. Their extra
outputs explain the exact 1,540 difference between the 223,320,819 non-circular
route groups and the 223,322,359 final-output observations.

---

## Method

**Categorisation.** Seven categories across 105 manually verified tokens:
Native Solana, Liquid Staking, Stablecoin, Cross-Chain Asset, Meme Coin,
Tokenized RWA, Other. Two rules worth stating:

- WSOL is Native Solana, not Cross-Chain — it is the SPL wrapper of SOL, not a
  bridged asset.
- Solana-native protocol tokens (JUP, RAY, ORCA, KMNO) count as Native Solana
  rather than a separate DeFi category, which would overlap almost entirely.

**Dimension tables.** Q4 (tokens → categories) and Q6b (program addresses →
names) are separate queries joined by the analysis queries — the same principle
as a `dim_asset` table in a star schema, applied to on-chain data.

**Counting.** Event-level and transaction-level counts answer different questions
and are labelled as such throughout. Where a transaction touches several
categories, the treatment is stated per query.

**Route grouping.** Part 2 groups decoded swap events by
`(evt_tx_id, evt_outer_instruction_index)`. C4 checks the instruction structure;
C5 confirms that a single transaction can contain more than one route group.

**Final-output roles.** Within a route, input-only tokens are starts, tokens that
appear as both input and output are intermediate, and output-only tokens are
final outputs. Circular / closed routes have no output-only token and therefore
do not enter the final-output category distribution.

**Route types.** Q10 uses an operational classification: Circle when no final
token exists; Simple for one-event routes; Split when an input or output token
appears more than once within the route; Multi-Hop when an intermediate token is
present; remaining routes are Simple. These labels describe the decoded event
structure, not motive or user intent.

**Final-output validation.** Across H1 2026, 223,319,337 non-circular route groups
had exactly one final token and 1,482 had more than one. The latter produce 1,540
extra final-output observations. The validation returned no NULL outer instruction
index route groups.

---

## Queries

| ID | Title | Role |
|---|---|---|
| Q0 | Solana DEX Landscape | Context; establishes Jupiter's absence |
| C1 | Coverage Check | Justifies the top-100 scope |
| C2 | Fee Event Coverage | Fee-event coverage per category (Q8 uses a smaller priced subset) |
| C3 | Weekly Range | Min/max weekly share per category, from Q9 |
| Q1 | Baseline Metrics | Headline figures |
| Q2 | Top Tokens by Trade Count | Ranking by activity |
| Q3 | Top Tokens by USD Volume | Ranking by capital |
| Q4 | Token Category Mapping | Dimension table, 105 tokens |
| Q5 | Category Distribution | Share of activity per category |
| Q6 | DEX Program Usage | Execution venues |
| Q6b | DEX Program Names | Dimension table, 20 programs |
| Q7 | Routing Complexity by Category | Dominant-category events per transaction |
| Q8 | Recorded Fee Rate | Recorded fees / priced event-output volume, on a priced subset |
| Q9 | Category Composition Over Time | Weekly shares |

Chart variants (Q2a/b, Q3a/b, Q5a, Q6c/e) exist because the distributions are too
skewed for a single readable chart. They add no logic of their own.

### Part 2 queries

| ID | Title | Role |
|---|---|---|
| C4 | Instruction Index Check — Route Grouping | Validates the route-grouping columns on decoded events |
| C5 | Jupiter Transactions with Multiple Route Groups | Shows that one transaction can contain several route groups; one-week validation |
| Q10 | Jupiter Route Type Distribution | Classifies route groups as Simple, Circle, Multi-Hop or Split |
| Q11 | Category Shares by Final Output Token | Category distribution of final-output-token observations |
| Q11 check | Final Output Tokens per Route — H1 2026 | Validates final-token cardinality and explains the Q10/Q11 count difference |
| Q12 | All Events vs Final Output Category Shares | Measures how category shares change between Part 1 and Part 2 |
| Q13 | Weekly Category Shares by Final Output Token | Weekly final-output category composition |
| Q14 | Top Intermediate-Hop Tokens | Counts route groups in which each token acts as an intermediate |

Chart/table variants Q12a, Q14a and Q14b contain no additional analytical logic;
they reshape validated results for dashboard display.

---

## Limitations

- Six months of data. Findings are period-specific and not generalisable.
- Only Jupiter v6. Direct pool swaps and other aggregators are out of scope —
  the aggregator is itself a filter on what is observed.
- Categorisation is an analytical judgement, not an official taxonomy. It is
  published as Q4 and can be checked line by line.
- `Unmapped` covers 5.9% of swap events and is always reported.
- `approx_distinct()` is used where exact counts time out. Roughly 2% error; at
  small counts an estimate can exceed the exact event count.
- **Price coverage is uneven:** 100% for liquid staking, 89% for native Solana,
  82% for stablecoins, 67% for cross-chain and RWA, but only **24% for meme
  coins**. Meme coin volume and fees are understated throughout.
- Prices are daily closes, not execution-time prices. Adequate for ranking, not
  for precise valuation.
- **Part 1 counts intermediate hops as outputs.** A route A → SOL → B records SOL
  as an output alongside B, so the Part 1 category shares describe execution
  activity. Part 2 measures the difference directly: Stablecoin share falls from
  39.33% of event outputs to 31.31% of final-output observations, while combined
  Meme Coin share rises from 10.98% to 18.13%.
- **Final-output shares do not include circular / closed routes.** Q10 identifies
  61,396,063 such route groups (21.56%); under the role-based definition they
  contain no output-only token.
- **A tiny number of non-circular routes have multiple final outputs.** The H1
  validation found 1,482 such routes (about 0.00066% of non-circular route
  groups), creating 1,540 additional final-output observations. Q11 therefore
  counts final-output-token observations rather than assuming one final token per
  route.
- **Route types are operational classifications.** They describe the structure of
  decoded events. In particular, a `Circle` label does not by itself establish
  arbitrage, motive or user intent.
- **Fee event coverage is narrow and uneven.** Jupiter does not record a fee
  event on every route. The share of transactions carrying one ranges from 7.92%
  (Native Solana) to 0.51% (Cross-Chain Asset), with none at all for Other — see
  C2. After pricing filters, Q8 uses 0.12%–7.85% of transactions. Q8 therefore describes recorded fee events, not the cost of trading a
  category. Whether the covered subset is representative cannot be established
  from this data.
- Fees recorded in `jupiter_evt_feeevent` are referred to here as recorded fee
  events. Who ultimately receives them is not established by this analysis.
- Solana network fees are a separate cost and are not analysed here. The two are
  never combined.
- `avg_size_usd` in Q3 is computed per priced swap event, not per transaction.
- Of the top 20 DEX programs, only Manifest carries a verified-program badge on
  Solscan. Names come from public labels.
- Wash trading and bot activity are real on DEXes and cannot be fully filtered.
- The analysis describes trading behaviour, not its causes. No causal claims.
- Not investment advice.

---

## Use of AI

This project was built with AI assistance, and it is worth being precise about
what that means rather than leaving it vague.

**What the AI did:**

- Wrote most of the SQL, including the window functions, CTEs and joins
- Explained unfamiliar functions (`approx_distinct`, `from_base58`, `PARTITION BY`)
- Suggested the query structure and the order of work
- Diagnosed errors — the duplicate-column trap, the type mismatch on the price
  join, the wrong counting grain in the first version of Q7
- Helped build and validate the Part 2 route-reconstruction queries, including
  tracing the 1,540-count difference between non-circular routes and final outputs
- Drafted dashboard and documentation text

**What the AI did not do:**

- Choose the research question or the thesis
- Decide the category boundaries, or which of several defensible options to take
- Verify the 105 tokens on Solscan
- Notice that a token labelled `test` in Dune was actually PENGU, or that a
  "USDT" in the top 100 was an impostor
- Produce the routing complexity idea, which came from an observation while
  trading, not from the data
- Judge which findings mattered

An AI generating a query is easy. Knowing that the number it returns is wrong,
and why, is not — the impossible 0.95 value in Q7 was caught because the result
contradicted what the metric could mathematically be, not because the SQL threw
an error.

The tooling changes how fast this gets built. It does not change who is
responsible for whether it is right.

---

## Repository

```
solana-jupiter-trading-analysis/
├── README.md
├── REPORT.md
├── images/
│   ├── category_breakdown.png
│   ├── category_over_time.png
│   ├── dex_programs_table.png
│   ├── fee_rate_by_category.png
│   ├── routing_complexity.png
│   ├── top5_by_trade_count.png
│   ├── top5_by_volume.png
│   ├── top5_dex_programs.png
│   ├── final_output_category_shift.png
│   ├── route_type_distribution.png
│   ├── top5_intermediate_tokens.png
│   └── top20_intermediate_tokens.png
└── queries/
    ├── Q0_solana_dex_landscape.sql
    ├── C1_coverage_check.sql
    ├── C2_fee_event_coverage.sql
    ├── C3_weekly_range.sql
    ├── Q1_baseline_metrics.sql
    ├── Q2_top_tokens_by_trade_count.sql
    ├── Q2a_top5_by_trade_count.sql
    ├── Q2b_ranks_6_15_by_trade_count.sql
    ├── Q3_top_tokens_by_volume.sql
    ├── Q3a_top5_by_volume.sql
    ├── Q3b_ranks_6_15_by_volume.sql
    ├── Q4_token_category_mapping.sql
    ├── Q5_category_distribution.sql
    ├── Q5a_category_distribution_chart.sql
    ├── Q6_dex_program_usage.sql
    ├── Q6b_dex_program_names.sql
    ├── Q6c_top5_dex_programs.sql
    ├── Q6e_dex_programs_table.sql
    ├── Q7_routing_complexity.sql
    ├── Q8_recorded_fee_rate.sql
    ├── Q9_category_composition_over_time.sql
    ├── C4_route_grouping_check.sql
    ├── C5_transactions_with_multiple_route_groups.sql
    ├── Q10_route_type_distribution.sql
    ├── Q11_category_shares_final_output.sql
    ├── Q11_check_final_output_tokens_per_route_h1.sql
    ├── Q12_all_events_vs_final_output.sql
    ├── Q12a_all_events_vs_final_output_chart.sql
    ├── Q13_weekly_final_output_category_shares.sql
    ├── Q14_top_intermediate_hop_tokens.sql
    ├── Q14a_top_intermediate_hop_tokens_chart.sql
    └── Q14b_top5_intermediate_hop_tokens.sql
```

Each query file is self-contained: the header comments state purpose, scope,
counting method and known caveats. The file contents are identical to what runs
on Dune.

The CSV exports of the query results are in the repository alongside the
queries.

**Detailed findings:** [REPORT.md](REPORT.md) — every result walked through with
the charts, including what was found along the way and what would come next.

### Related project

The stored Dune results are also used in a separate data-engineering / BI project:

**Dune API → Python → CSV → Power BI**

[Dune API Pipeline](https://github.com/Amirhouschang/dune-api-pipeline)
