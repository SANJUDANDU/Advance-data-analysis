--Which 5 products generate the highest products?? [USING TOP]

SELECT TOP 5
p.Product_Name,
sum(s.Sales_Amount) as Total_Revenue
FROM Gold_Fact_Sales S
left join Gold_Dim_Products P
on s.Product_Key = p.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC

--What are the 5 worst-performing products in terms of sales?? [USING TOP]


SELECT TOP 5
p.Product_Name,
sum(s.Sales_Amount) as Total_Revenue
FROM Gold_Fact_Sales S
left join Gold_Dim_Products P
on s.Product_Key = p.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_Revenue 

--Which 5 products generate the highest products?? [USING WINDOWS FUNCTIONS]
SELECT
*
FROM(
SELECT 
p.Product_Name,
SUM(s.Sales_Amount) as Total_Revenue,
ROW_NUMBER() OVER (ORDER BY SUM(s.Sales_Amount) DESC) AS Revenue_Rank
FROM Gold_Fact_Sales S
left join Gold_Dim_Products P
on s.Product_Key = p.Product_Key
GROUP BY p.Product_Name
)T
WHERE Revenue_Rank <= 5

--What are the 5 worst-performing products in terms of sales?? [USING WINDOWS FUNCTIONS]
SELECT
*
FROM(
SELECT 
p.Product_Name,
SUM(s.Sales_Amount) as Total_Revenue,
RANK() OVER (ORDER BY SUM(s.Sales_Amount)ASC) AS Revenue_Rank
FROM Gold_Fact_Sales S
left join Gold_Dim_Products P
on s.Product_Key = p.Product_Key
GROUP BY p.Product_Name
)t
WHERE Revenue_Rank <= 5

---Find the top 10 customers who have generated the highest revenue??? 
SELECT
*
FROM(
SELECT 
c.Customer_Key,
c.first_name,
c.Last_name,
SUM(s.Sales_Amount)as [Total Revenue],
rank()over (order by SUM(s.Sales_Amount) desc) as Revenue_Rank,
ROW_NUMBER()over (order by SUM(s.Sales_Amount) desc) as ROW_NO,
DENSE_RANK()over (order by SUM(s.Sales_Amount) desc) as DENSE_RANK
from Gold_Fact_Sales S
left join Gold_Dim_Customers c
on s.Customer_Key= c.customer_key
group by c.Customer_Key,
		 c.first_name,
		 c.Last_name
)t
WHERE Revenue_Rank <= 10


--- Find 3 customers with the fewest orders placed?? [USING TOP]

SELECT top 3
c.Customer_Key,
c.first_name,
c.Last_name,
COUNT(DISTINCT Order_Number)  [Total Orders]
from Gold_Fact_Sales S
left join Gold_Dim_Customers c
on s.Customer_Key= c.customer_key
group by c.Customer_Key,
		 c.first_name,
		 c.Last_name
order by [Total Orders]