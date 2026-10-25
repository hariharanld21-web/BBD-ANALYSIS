# AI log

**AI disclosure:** I used an AI assistant to help draft the queries, notes and this log. I ran every query myself on the seed data and checked the results against the checkpoints in the brief.

## Task 1 - Five-part prompt for q13
**Role:** You are a senior SQL analyst writing standard SQLite SQL.
**Task:** Write one query that reports each rep's monthly completed revenue against their monthly target and assigns a performance_tier.
**Context:** SQL dialect: SQLite. Tables: reps(rep_id, rep_name, region, monthly_target); customers(customer_id, first_name, last_name, city, region, age, rep_id); orders(order_id, customer_id, item, quantity, amount, status, order_month). Joins: customers.rep_id = reps.rep_id; orders.customer_id = customers.customer_id.
**Constraints:** completed orders only (status = 'completed'); tiers: 'Below Target' when revenue < monthly_target, 'On Target' when revenue >= target but < 1.1 x target, 'Above Target' otherwise; no WITH clauses; no stored procedures; write the aggregate expression out in full inside CASE (no alias reuse); group by rep_name, order_month, monthly_target; order by rep_name then order_month.
**Format:** raw SQL only, with inline comments. Columns: rep_name, order_month, monthly_target, revenue, performance_tier.

## Task 2 - Defects in Scenario D1
| # | Defect | Classification | Correct fix |
|---|---|---|---|
| 1 | Table `sales` does not exist | fake method/function | Use `orders` joined to `customers` |
| 2 | Columns `region_name` and `total_sales` do not exist | fake method/function | Use `customers.region` and `orders.amount` |
| 3 | `WHERE SUM(total_sales) > 80000` (aggregate in WHERE) | logic error | Move the condition to `HAVING SUM(o.amount) > 80000` |
| 4 | "North ... grew 38% month over month" | phantom statistic | Compute from data: North fell 22.8% |

(The query also ignores the revenue definition: it must filter to status = 'completed'.)

## Task 3 - Verification of D1
Corrected query saved in `sql/d1_corrected.sql`. Result (2 rows):

| region | sales |
|---|---|
| North | 119300 |
| South | 82500 |

North monthly revenue from q11: 2026-09 = 53,500; 2026-10 = 41,300. Change = (41,300 - 53,500) / 53,500 = **-22.8%**. The assistant's claim of 38% growth is contradicted by the data.

## Task 4 - Human-in-the-loop protocol (Scenario D1)
**Specification:** "which regions sell the most?" is too vague, so I made it specific: completed-order revenue by customer region, keeping only regions above 80,000, using the real tables.
**Execution:** I tried the assistant's query against my schema and it cannot run, because `sales`, `region_name` and `total_sales` do not exist and there is an aggregate inside WHERE. Then I ran my corrected query on the seed data.
**Inspection:** I found four problems: a fake table, fake columns, an aggregate in WHERE, and a 38% number with nothing behind it. It also ignores our rule that revenue means completed orders only.
**Verification:** I checked my result against q11, where North adds up as 53,500 + 41,300 + 24,500 = 119,300, and against the grand total of 346,200. North's change from September to October is -22.8%, not +38%.
**Decision:** I **reject** the assistant's original answer and **accept** my corrected version. The evidence is that `sql/d1_corrected.sql` returns North 119300 and South 82500, which matches q11 and q05.

## Task 5 - Prompt for Scenario D2
**Role:** You are a spreadsheet debugging expert.
**Task:** Find the root cause of a lookup error and give a repaired formula.
**Context:** On the `orders` tab, cell G2 (the item column) contains the text " Smart Watch" (a space before the S). The `products` tab occupies A1:C10, header in row 1, item names in column A, unit prices in column C. The formula is `=VLOOKUP(G2,$A$2:$C$10,3,FALSE)` and it returns "value not found", although Smart Watch is in the table.
**Constraints:** exact-match lookup must stay; keep absolute ranges; do not edit the source data.
**Format:** state the root cause in one sentence, then give the repaired formula.

**Root cause (in my words):** the cell has an extra space in front, so " Smart Watch" and "Smart Watch" look the same to us but are different text to an exact-match lookup.
**Repaired formula:** `=VLOOKUP(TRIM(G2),$A$2:$C$10,3,FALSE)`

## Task 6 - Skeptical-analyst check on Part C
**Prompt:** You are a skeptical analyst. Challenge my first recommendation: "Run a Smart Watch and Earbuds promotional push in North, because North revenue was 24,500 in Nov against a 40,000 target." List every unstated assumption, say what evidence (not just correlation) would show that the promotion caused a recovery, and what would weaken the case.

**Unstated assumptions and checks from the data:**
1. *The Nov shortfall is a demand problem, not an order-processing problem.* Check: North also has a disputed order of 9,600 and a pending one of 1,900 in Nov; if these closed as completed, revenue would be 36,000, much closer to 40,000.
2. *Smart Watches and Earbuds are what North customers respond to.* Check: North Smart Watch revenue was 13,500 (Sep), 27,000 (Oct), 4,500 (Nov), while Earbuds were 12,800 in Nov - so the watch decline is the real gap.
3. *The drop reflects the customer base, not a few buyers.* Check: North has only 5 customers with completed orders, and customer 5 alone accounts for 44,000 of 119,300 (36.9%); if that customer's buying changes, the region swings.
4. *The target of 40,000 is a fair benchmark.* Check: North met or beat it only in Sep (53,500) and Oct (41,300).
