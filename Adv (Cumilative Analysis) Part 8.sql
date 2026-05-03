---Find the total sales per month 
---and the running of total sales over time??

SELECT * FROM Gold_Fact_Sales

SELECT 
ORDER_DATE,
TOTAL_SALES,
SUM(TOTAL_SALES) OVER (ORDER BY ORDER_DATE) AS Running_Total_Sales,
Avg (avg_price) OVER (ORDER BY ORDER_DATE) AS [Moving Average Sales]
FROM
(
SELECT
DATETRUNC (MONTH, Order_Date) AS [Order_Date],
SUM(Sales_Amount) AS Total_Sales,
Avg (Price) as avg_price
from Gold_Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC (MONTH, Order_Date)
)t