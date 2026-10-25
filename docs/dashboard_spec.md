# Dashboard specification (Tableau Public, built from data/orders_clean.csv)

## 1. Data source
Connect to `data/orders_clean.csv` (63 rows).

| Column | Classification |
|---|---|
| order_id | Dimension |
| order_month | Dimension |
| clean_first_name | Dimension |
| clean_last_name | Dimension |
| region | Dimension |
| rep_name | Dimension |
| item | Dimension |
| category | Dimension |
| status | Dimension |
| unit_price | Measure |
| quantity | Measure |
| amount | Measure |
| revenue_calc | Measure |

9 Dimensions, 4 Measures.

## 2. KPI cards
- **Total Revenue** = SUM(amount) = **INR 346,200**. This equals Part A q05 `total_revenue`.
- **Total Units Sold** = SUM(quantity) = **106**.

## 3. Chart sheets
**Revenue by Region** - bar chart. Rows: SUM(amount); Columns: region; Colour: region. Bars suit a comparison of a few categories.

| region | revenue |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |

**Revenue by Category** - bar chart. Rows: SUM(amount); Columns: category; Colour: category. Bars rank category totals clearly.

| category | revenue |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |

**Revenue Trend by Month and Category** - line chart. Rows: SUM(amount); Columns: order_month; Colour: category (one line per category). A line shows change over time.

| order_month | Apparel | Electronics | Home | Total |
|---|---|---|---|---|
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |

**Region x Category Detail** - text table. Rows: category; Columns: region; Text: SUM(amount). A text table gives exact values for every cell.

| category | East | North | South | West | Total |
|---|---|---|---|---|---|
| Apparel | 10600 | 19400 | 10000 | 37500 | 77500 |
| Electronics | 21400 | 73400 | 28700 | 18800 | 142300 |
| Home | 37500 | 26500 | 43800 | 18600 | 126400 |

## 4. Dashboard layout (top to bottom)
1. KPI cards (horizontal container: Total Revenue | Total Units Sold)
2. `category` filter (top band, directly below the KPI cards), applied to all four worksheets using this data source
3. Revenue Trend by Month and Category (line)
4. Comparison charts (horizontal container: Revenue by Region | Revenue by Category)
5. Region x Category Detail (text table)

All sit in one vertical container. With Use as Filter on, clicking a bar in Revenue by Region (e.g. North) filters the other charts and the detail table to that region only; clicking again clears it.

## 5. Insight and recommendation narrative
### Visualization summary
The dashboard shows ₹346,200 of completed revenue from 106 units sold. You can read it by region, by category and by month, and the category filter at the top changes every chart at once.

### Summary analysis
1. **Regions:** North is clearly ahead at 119,300, while East is last at 69,500. That is a gap of 49,800, and North alone is about 34.5% of all revenue.
2. **Categories:** Electronics brings in 142,300 (41.1% of the total), and 73,400 of that comes from North.
3. **Months:** total revenue slipped from 98,300 in 2026-09 to 93,100 in 2026-10, then jumped to 154,800 in 2026-11, which is up 66.3%.
4. **Home category:** it fell from 30,600 in September to 12,600 in October, then shot up to 83,200 in November.
5. **North:** revenue went from 53,500 in September to 41,300 in October (down 22.8%) and then to 24,500 in November.

### Recommendations
1. **North, Electronics:** run a Smart Watch and Earbuds promotion in North. North made only 24,500 in November against a 40,000 target. I would watch North's monthly completed revenue against that 40,000.
2. **South and East, Home:** stock up on Air Fryers before the next sale. Home hit 83,200 in November and South Home is the biggest single cell at 43,800. I would watch Home revenue per month and any Air Fryer stock-outs.
3. **East and South, Apparel:** copy what works in West, where Apparel made 37,500, because East only made 10,600 and South 10,000. I would watch East plus South Apparel revenue, which is 20,600 now.

## 6. Reconciliation
| Total Revenue KPI | Sum of Revenue by Region | Sum of Revenue by Category | Part B pivot grand total |
|---|---|---|---|
| 346200 | 346200 | 346200 | 346200 |
