/*
Identify the earliest and latest dates (Boundaries).
Understand the scope of data and the timespan.
*/


--Find the date of the first order and last Orders??

SELECT 
MIN(Order_date) As First_Order_date,
MAX(Order_date) As Last_Order_date
FROM Gold_Fact_Sales

--How many years/months/days of sales are available in the data??

SELECT 
MIN(Order_date) As First_Order_date,
MAX(Order_date) As Last_Order_date,
DATEDIFF(YEAR, MIN(ORDER_DATE), MAX(ORDER_DATE)) AS Order_Range_Years,
DATEDIFF(MONTH, MIN(ORDER_DATE), MAX(ORDER_DATE)) AS Order_Range_Months,
DATEDIFF(DAY, MIN(ORDER_DATE), MAX(ORDER_DATE)) AS Order_Range_Days
FROM Gold_Fact_Sales

---Find the difference between the order date and shipping date??
Select 
order_date,
shipping_date,
datediff(day,order_date, shipping_date) As Shipping_Duration
From Gold_Fact_Sales

---Find the youngest and oldest customers in the data(In years)??

SELECT 
MIN(Birthdate) AS Youngest_Customer_Birthdate,
DATEDIFF(YEAR,MIN(Birthdate), GETDATE()) AS Oldest_Customer_Age,
MAX(Birthdate) AS Oldest_Customer_Birthdate,
DATEDIFF(YEAR,Max(Birthdate), GETDATE()) AS Youngest_Customer_Age
FROM GOLD_DIM_CUSTOMERS

