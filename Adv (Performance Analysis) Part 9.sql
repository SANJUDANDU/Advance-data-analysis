-- STEP 1- Analyze the yearly performance of products  by comparing each products sales to both
-- STEP 2- its average sales performance and the previous year's sales??

--SELECT * FROM Gold_Fact_Sales S
--SELECT * FROM Gold_Dim_Products P

-- USING CTE # WINDOWS FUNCTION

WITH Yearly_Product_Sales AS (
	SELECT 
		Year(Order_Date) AS Order_Year,
		p.Product_Name,
		SUM(Sales_Amount) AS Current_Sales
FROM Gold_Fact_Sales S
LEFT JOIN Gold_Dim_Products P
	ON S.Product_Key=P.Product_key
WHERE S.Order_Date IS NOT NULL
	GROUP BY 
		Year(Order_Date),
		P.Product_Name
)

SELECT 
		Order_year,
		Product_Name,
		Current_Sales,
		avg(current_sales) over (partition by product_name) as Avg_Sales,
		Current_Sales- avg(current_sales) over (partition by product_name) AS Sales_Diff_Avg,
	CASE WHEN Current_Sales- avg(current_sales) over (partition by product_name) >0 THEN 'Above Average'
		 WHEN Current_Sales- avg(current_sales) over (partition by product_name) < 0 THEN 'Below Average'
		ELSE 'Average' 
	END AS Performance_Comparison_Avg,
	coalesce(
LAG(Current_sales) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) ,
0
) AS Previous_Year_Sales ,--used coalesce to handle null values for the first year of sales data and wherever there is no previous year sales data available
Current_sales - LAG(Current_sales) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) As Sales_Diff_Prev_Year,
CASE WHEN Current_Sales- avg(current_sales) over (partition by product_name) > 0 THEN 'Increase'
		 WHEN Current_Sales- avg(current_sales) over (partition by product_name) < 0 THEN 'Decrease'
		 WHEN LAG(Current_Sales) OVER (PARTITION BY PRODUCT_NAME ORDER BY ORDER_YEAR) IS NULL THEN 'No Change'
		ELSE 'No Change' 
	END AS Previous_Yr_Change
FROM Yearly_Product_Sales












