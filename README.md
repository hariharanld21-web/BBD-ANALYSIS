# Big Billion Days Regional Performance Review

**SQL compiler and dialect:** SQLite, run in a free browser compiler. I split the big INSERT into one INSERT per row.
**Spreadsheet tool:** Google Sheets.
**Tableau Public dashboard:** not built. I wrote the specification in `docs/dashboard_spec.md` as if it was built, and every number in it comes from the spreadsheet layer.

## Three most important findings
Completed revenue is ₹346,200 from 63 orders and 106 units. North is the strongest region at 119,300, but it dropped 22.8% from September to October and made only 24,500 in November against a 40,000 target. Electronics (142,300) and Home (126,400) carry the business, and Home jumped to 83,200 in November after only 12,600 in October. Overall revenue rose 66.3% in November to 154,800, helped a lot by East, South and West catching up.

## File index
| File | Part |
|---|---|
| `sql/00_schema_and_seed.sql`, `sql/q01.sql` to `sql/q13.sql`, `results/query_results.md`, `data/orders_enriched.csv` | A |
| `docs/spreadsheet_notes.md`, `data/orders_clean.csv` | B |
| `docs/dashboard_spec.md` | C |
| `sql/d1_corrected.sql`, `docs/ai_log.md` | D |

## Assumptions
- Revenue means the sum of `amount` for orders with status `completed`.
- The three missing amounts (orders 1001, 1010, 1064) are pending orders, so I left them blank.
- `order_month` is kept as text.
- Names were cleaned with PROPER(TRIM()).
