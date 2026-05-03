--Analyze sales performance over time??

SELECT 
YEAR(Order_Date) AS Order_year,
SUM(Sales_Amount) AS Total_Sales
FROM Gold_Fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date)