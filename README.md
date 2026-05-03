# 📊 Advanced Data Analysis — SQL Project

A comprehensive SQL-based data analysis project built on a **Gold-layer star schema** using SQL Server. The project covers everything from raw data exploration to advanced analytics, customer segmentation, performance benchmarking, and business reporting.

---

## 🗂️ Project Structure

```
├── EDA/
│   ├── EDA_part_1_exploring_the_data.sql        # Schema & table exploration
│   ├── EDA_dimensions_exploration_part2.sql      # Dimension profiling
│   ├── EDA_Date_Exploration_Part3.sql            # Date range & shipping analysis
│   ├── EDA_Magnitude_Analysis_Part5.sql          # Aggregations by country, gender, category
│   └── EDA_Ranking_Analysis_Part6.sql            # Top/bottom products & customers
│
├── Advanced Analysis/
│   ├── Adv_part7.sql                             # Year-over-year sales trend
│   ├── Adv_Cumulative_Analysis_Part8.sql         # Running totals & moving averages
│   ├── Adv_Performance_Analysis_Part9.sql        # Product performance vs avg & prior year
│   ├── ADV_Data_Segmentation_11.sql              # Customer & product segmentation
│   └── ADV_Reporting_part12.sql                  # Final customer & product report views
```

---

## 🗃️ Data Model

The project uses a **star schema** with one fact table and two dimension tables:

| Table | Type | Description |
|---|---|---|
| `Gold_Fact_Sales` | Fact | Transactional sales records |
| `Gold_Dim_Customers` | Dimension | Customer demographics |
| `Gold_Dim_Products` | Dimension | Product details & categories |

```
Gold_Dim_Customers          Gold_Fact_Sales           Gold_Dim_Products
──────────────────          ───────────────           ─────────────────
Customer_Key (PK) ◄──── Customer_Key (FK)       Product_Key (FK) ────► Product_Key (PK)
Customer_Number             Order_Number (PK)          Product_Name
First_Name                  Order_Date                 Category
Last_Name                   Shipping_Date              Subcategory
Gender                      Sales_Amount               Cost
Birthdate                   Quantity                   Price
Country                     Price
```

---

## 🔍 Exploratory Data Analysis (EDA)

### Part 1 — Schema Exploration
- Queried `INFORMATION_SCHEMA.TABLES` and `INFORMATION_SCHEMA.COLUMNS` to understand the full database structure

### Part 2 — Dimension Exploration
- Identified all unique customer countries
- Explored all product categories, subcategories, and product names

### Part 3 — Date Exploration
- Found first and last order dates
- Calculated total data span in years, months, and days
- Analysed shipping duration (order date vs shipping date)
- Identified youngest and oldest customers by birthdate

### Part 5 — Magnitude Analysis
- Total customers by country and gender
- Total products per category
- Average cost per category
- Total revenue per category
- Total revenue per customer
- Quantity sold distribution by country

### Part 6 — Ranking Analysis
- Top 5 and bottom 5 products by revenue using `TOP` and window functions
- Top 10 customers by revenue using `RANK()`, `ROW_NUMBER()`, and `DENSE_RANK()`
- 3 customers with fewest orders placed

---

## 📈 Advanced Analysis

### Part 7 — Sales Trend Over Time
- Year-over-year total sales grouped by `YEAR(Order_Date)`

### Part 8 — Cumulative Analysis
- Monthly total sales using `DATETRUNC`
- **Running total** of sales over time using `SUM() OVER (ORDER BY ...)`
- **Moving average** of price using `AVG() OVER (ORDER BY ...)`

### Part 9 — Performance Analysis
- Yearly product sales compared to:
  - **Average sales** across all years (`AVG() OVER (PARTITION BY product_name)`)
  - **Previous year's sales** using `LAG()` window function
- `COALESCE` used to handle null values for first-year records
- Performance labels: `Above Average`, `Below Average`, `Increase`, `Decrease`

### Part 11 — Data Segmentation
- **Product segmentation** by cost range: Below 100 / 100–500 / 500–1000 / Above 1000
- **Customer segmentation** by spending behaviour:
  - `VIP` — 12+ months history & spending > $5,000
  - `REGULAR` — 12+ months history & spending ≤ $5,000
  - `NEW` — lifespan < 12 months

### Part 12 — Business Reporting Views
Two reusable SQL views created for downstream reporting:

**`Gold_Customer_Report`**
- Customer demographics + transaction history
- Age group segmentation (Under 20, 20–29, 30–39, 40–49, 50+)
- VIP / Regular / New classification
- KPIs: Recency, Average Order Value (AOV), Average Monthly Spend

**`Gold_Product_Report`**
- Product details + sales aggregations
- Performance segmentation: High-Performance / Mid-Range / Low-Performer
- KPIs: Recency, Average Order Revenue (AOR), Average Monthly Revenue

---

## 🛠️ SQL Concepts Used

| Concept | Used In |
|---|---|
| `GROUP BY`, `ORDER BY`, `WHERE` | Throughout EDA |
| `JOIN` (LEFT JOIN) | Parts 5, 6, 9, 12 |
| `DATETRUNC`, `DATEDIFF`, `YEAR()` | Parts 3, 7, 8, 11, 12 |
| Window Functions (`SUM OVER`, `AVG OVER`) | Parts 8, 9 |
| `ROW_NUMBER`, `RANK`, `DENSE_RANK` | Part 6 |
| `LAG` | Part 9 |
| `CASE WHEN` | Parts 9, 11, 12 |
| CTEs (`WITH`) | Parts 9, 11, 12 |
| `COALESCE`, `NULLIF` | Parts 9, 12 |
| SQL Views (`CREATE VIEW`) | Part 12 |
| `INFORMATION_SCHEMA` | Part 1 |

---

## 💻 How to Run

1. Set up **SQL Server** (or use SQL Server Management Studio)
2. Ensure the Gold layer tables exist: `Gold_Fact_Sales`, `Gold_Dim_Customers`, `Gold_Dim_Products`
3. Run scripts in order: EDA Parts 1 → 6, then Advanced Parts 7 → 12
4. Part 12 creates views — run once, then query with `SELECT * FROM Gold_Customer_Report`

---

## 👩‍💻 Author

**Sanjana Dandu** — Data Analyst | Mumbai, India  
[LinkedIn](https://www.linkedin.com/in/sanjana-dandu) · [GitHub](https://github.com/SANJUDANDU)
