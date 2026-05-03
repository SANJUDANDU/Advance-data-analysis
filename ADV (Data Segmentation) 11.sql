/*
Data Segmentation used to group the data on a specific range.
Helps understand the correlation between two measures.
For example: We can segment customers based on their total revenue to identify high-value customers,
medium-value customers, and low-value customers. This segmentation can help businesses tailor their
marketing strategies and customer engagement efforts accordingly.
[Measure] By [Measure]
*/
/*
Question 1: Segement products into cost ranges and 
count how many products fall into each segment??
*/
    --With Product_Segmentation as(
    --Select 
    --Product_key,
    --Product_Name,
    --Cost,
    --CASE WHEN Cost <100 THEN 'Below 100'
    --     WHEN Cost between 100 and 500 THEN '100-500'
    --     WHEN Cost between 500 and 1000 THEN '500-1000'
    --     ELSE 'Above 1000'
    --END AS Cost_Range
    --from Gold_Dim_Products)

    --Select
    --Cost_Range,
    --Count(Product_key) AS [Total Products]
    --from Product_Segmentation
    --GROUP BY Cost_Range
    --ORDER BY [Total Products] DESC

/* Question 2: Group customers into three segments based on their spending behaviour:
-> VIP - at least 12 months of history & spending more than $5,000.
-> REGULAR - at least 12 months of history but spending  $5,000 or less.
-> NEW - lifespan less than 12 months.
Now find the total no. of customers by each group???
*/
WITH Customer_spending as (
Select 
c.Customer_Key,
SUM(f.Sales_Amount) AS Total_Spending,
MIN(order_date) AS First_Order,
MAX(order_date) AS Last_Order,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Lifespan
from Gold_Fact_Sales f
left join Gold_Dim_Customers c
ON f.Customer_Key = c.Customer_Key
GROUP BY c.Customer_Key
)
Select
customer_segment,
count(Customer_Key) AS Total_Customers
from(
    select
    customer_key,
    CASE WHEN Lifespan >= 12 AND Total_Spending > 5000 THEN 'VIP'
         WHEN Lifespan >= 12 AND Total_Spending <= 5000 THEN 'REGULAR'
         ELSE 'NEW'
    END AS Customer_Segment
    from Customer_spending
)t
group by customer_segment
ORDER BY Total_Customers DESC
