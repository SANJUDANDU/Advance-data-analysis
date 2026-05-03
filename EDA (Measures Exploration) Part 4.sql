--Find the Total Sales

SELECT 
SUM(Sales_Amount) AS Total_Sales
FROM Gold_Fact_Sales

--Find How many items were sold 

SELECT 
SUM(Quantity) AS Total_Quantity
FROM Gold_Fact_Sales

--Find the average selling price

SELECT 
AVG(Price) AS Avg_Selling_Price
FROM Gold_Fact_Sales

--Find the total number of orders


SELECT 
COUNT(Order_Number) [Total No.of Orders]
FROM Gold_Fact_Sales

SELECT 
COUNT(DISTINCT Order_Number) [Total No.of Orders]
FROM Gold_Fact_Sales

--Find the total number of Products

SELECT 
COUNT(Product_Key) [Total No.of Products]
FROM Gold_Dim_Products

SELECT 
COUNT(DISTINCT Product_Key) [Total No.of Products]
FROM Gold_Dim_Products

--Find the total number of Customers

SELECT 
COUNT(Customer_Key) [Total No.of Customers]
FROM Gold_Dim_Customers

SELECT 
COUNT(DISTINCT Customer_Key) [Total No.of Customers]
FROM Gold_Dim_Customers

--Find the total number of Customers that has placed orders

SELECT 
COUNT(DISTINCT Customer_Key) [Total No.of Customers]
FROM Gold_Fact_Sales

SELECT*FROM[dbo].[Gold_Fact_Sales]

------GENERATE A REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS??

SELECT 'Total Sales' AS Measure_Name, SUM(Sales_Amount) AS Measure_Value FROM Gold_Fact_Sales
union all
select 'Total Quantity' , SUM(quantity)  from Gold_Fact_Sales
union all
select 'Average Price' , AVG(Price)  from Gold_Fact_Sales
union all
select 'Total No. of Orders' , COUNT(DISTINCT Order_Number) FROM Gold_Fact_Sales 
union all
select 'Total No. of Products' , count(Product_name)  from Gold_Dim_Products
union all
select 'Total No. of Customers' , COUNT(Customer_Key) FROM Gold_Dim_Customers