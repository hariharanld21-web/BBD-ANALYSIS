# Spreadsheet notes (Google Sheets)

## Setup
- Tabs created: `orders` (imported from data/orders_enriched.csv) and `products`.
- Rows imported into `orders`: 90 (plus header). `order_month` kept as Plain text; it still shows `2026-09`.
- `products` tab occupies range `A1:C10` (header + 9 rows; columns item, category, unit_price).
- Before building `completed_orders` I applied the filter `status = completed`, then sorted the 63 visible rows by `amount` largest to smallest.
- Spare-cell test of the fallback: `=XLOOKUP("Mystery Item",$A$2:$A$10,$C$2:$C$10,"UNKNOWN_ITEM")` displays `UNKNOWN_ITEM`.

## (a) Formulas typed in the first data row (row 2), copied down all 90 rows
| Column | Formula |
|---|---|
| clean_first_name | `=PROPER(TRIM(C2))` |
| clean_last_name | `=PROPER(TRIM(D2))` |
| category | `=VLOOKUP(G2,products!$A$2:$C$10,2,FALSE)` |
| unit_price | `=XLOOKUP(G2,products!$A$2:$A$10,products!$C$2:$C$10,"UNKNOWN_ITEM")` |
| revenue_calc | `=N2*H2` |

## (b) Aggregates on `completed_orders` (63 rows)
| Metric | Formula | Value |
|---|---|---|
| COUNT | `=COUNT(A2:A64)` | 63 |
| SUM | `=SUM(K2:K64)` | 346200 |
| AVERAGE | `=AVERAGE(K2:K64)` | 5495.24 |
| MIN | `=MIN(K2:K64)` | 1100 |
| MAX | `=MAX(K2:K64)` | 15600 |

(Column letters refer to the `amount` / `order_id` columns of the final 13-column layout.)

## (c) Pivot tables (values = sum of amount, INR)
Pivot (i): rows = category, columns = region

| category | East | North | South | West | Grand Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |
| **Grand Total** | 69500 | 119300 | 82500 | 74900 | **346200** |

Pivot (ii): rows = order_month

| order_month | Sum of amount | Count of order_id |
|---|---|---|
| 2026-09 | 98300 | 19 |
| 2026-10 | 93100 | 20 |
| 2026-11 | 154800 | 24 |
| **Grand Total** | **346200** | **63** |

## (d) Reconciliation
| Measure | Spreadsheet | Part A (q05) | Result |
|---|---|---|---|
| COUNT | 63 | total_orders = 63 | Match |
| SUM | 346200 | total_revenue = 346200 | Match |
| AVERAGE | 5495.24 | avg_order_value = 5495.24 | Match |

## (e) Data validation
- **Missing amounts:** three orders have no amount: 1001, 1010 and 1064 (these are exactly the rows q02 returns). All three are still `pending`, so they were never going to count as revenue anyway. I left the cells blank instead of typing 0 or guessing price x quantity, because a blank means "we don't know" and a 0 would claim the order was worth nothing.
- **Data types:** amount, quantity, unit_price and revenue_calc are real numbers (SUM works with no errors). order_month is text on purpose. I also checked that revenue_calc equals amount on all 63 completed rows, and the difference is 0.
- **Duplicates and outliers:** no order_id repeats (63 different ids in 63 rows). The biggest amount is 15600, and it appears on four orders: 1061, 1065, 1069 and 1077. Each one is 3 Air Fryers at 5200, so it is a normal big order and not a typo.
- **One decision for whoever inherits this sheet:** always wrap the lookup key in TRIM and keep the UNKNOWN_ITEM fallback, and filter to status = completed before adding anything up.
