    /*
    ============================================================================================
    Customer Report
    ============================================================================================
    Purpose: 
       - This report consolidates key customer metrics and behaviors

     Highlights:
        1. Gathers essential customer information such as names, ages and transactional details.
        2. Segments customers based into categories (VIP, REGULAR, NEW) and age groups.
        3. Aggregates customer_level metrics:
            -Total Orders
            -Total Sales
            - Total Quantity Purchased
            -Total Products
            -lifespan  (in months)
        4. Calculate  Valuable KPIs:
             - Recency (months since last order)
             -Average Order Value
             - Average monthly spend
    =============================================================================================
    */
    --CREATE VIEW Gold_Customer_Report AS
    --WITH Base_Query AS (
    --/*-------------------------------------------------------------------------------------------
    --1) Base Query: Retrieves core columns from tables
    ---------------------------------------------------------------------------------------------*/
    --Select
    --    f.Order_Number,
    --    f.Product_Key,
    --    f.Order_Date,
    --    f.Sales_Amount,
    --    f.Quantity,
    --    c.Customer_Key,
    --    c.Customer_Number,
    --    CONCAT(c.first_name, ' ', c.Last_name) AS Customer_Name,
    --    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS Age
    --from Gold_Fact_Sales f
    --left join Gold_Dim_Customers c
    --on c.Customer_Key = f.Customer_Key
    --WHERE Order_Date IS NOT NULL)

    --, Customer_Aggregation As(
    --/*-------------------------------------------------------------------------------------------
    --2) Customer Aggregation: Summarizes key metrics at the customer level
    ---------------------------------------------------------------------------------------------*/
    --SELECT 
    --    Customer_Key,
    --    Customer_Number,
    --    Customer_Name,
    --    Age,
    --    COUNT(DISTINCT Order_Number)AS Total_Orders,
    --    SUM(Sales_Amount) As Total_Sales,
    --    SUM(Quantity) AS Total_Quantity,
    --    COUNT(DISTINCT Product_Key) AS Total_Products,
    --    MAX(Order_Date)AS Last_Order_Date,
    --    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS Lifespan
    --FROM Base_Query
    --GROUP BY
    --    Customer_Key,
    --    Customer_Number,
    --    Customer_Name,
    --    Age
    --)
    --Select 
    --Customer_Key,
    --    Customer_Number,
    --    Customer_Name,
    --    Age,
    --    CASE WHEN Age <20 THEN 'Under 20'
    --         WHEN Age between 20 and 29 THEN '20-29'
    --         WHEN Age between 30 and 39 THEN '30-39'
    --         WHEN Age between 40 and 49 THEN '30-39'
    --         ELSE '50 and Above'
    --    END AS Age_Group,
    --    CASE WHEN Lifespan >= 12 AND Total_Sales > 5000 THEN 'VIP'
    --         WHEN Lifespan >= 12 AND Total_Sales <= 5000 THEN 'REGULAR'
    --         ELSE 'NEW'
    --    END AS Customer_Segment,
    --    --Compute Recency (months since last order)
    --    Last_Order_Date,
    --    DATEDIFF(MONTH, Last_Order_Date, GETDATE()) AS Recency_Months,
    --    Total_Orders,
    --    Total_Sales,
    --    Total_Quantity,
    --    Total_Products,
    --    Lifespan,
    --    --Compute Average Order Value(AOV)
    --    CASE WHEN Total_Orders = 0 THEN 0
    --         ELSE Total_Sales/Total_Orders
    --    END AS Average_Order_Value,

    --    -- Compute Average Monthly Spend
    --    CASE WHEN Lifespan = 0 THEN Total_Sales
    --         ELSE Total_Sales/Lifespan
    --    END AS Average_Monthly_Spend
    --    from Customer_Aggregation

    --    SELECT 
    --    *
    --    FROM [dbo].[Gold_Customer_Report]

        /*
        ==============================================================================
        Explanation of the Code:
        1. Base Query: This CTE retrieves essential customer and sales data, including order details,
        customer information, and calculates the age of customers.
        2. Customer Aggregation: This CTE aggregates the data at the customer level, calculating total orders,
        total sales, total quantity, total products, last order date, and lifespan in months.
        3. Final Select: This section categorizes customers into age groups and segments (VIP, REGULAR, NEW),
        and computes valuable KPIs such as recency, average order value, and average monthly spend.
        4. The final SELECT statement retrieves all columns from the created view for reporting purposes.

        Note: This view can be used to generate comprehensive customer reports, enabling businesses 
        to analyze customer behavior, segment customers effectively, and make informed decisions based on key metrics and KPIs.
        ==============================================================================
        */

        /*
        ==============================================================================
        Product Report
        ==============================================================================
        Purpose:
          - This report consolidates key product metrics and behaviors
        Highlights:
        1. Gathers essential feilds such as product name, category, subcategory, and cost.
        2. Segments products by revenue to identify High-performance, Mid-Range or Low_performers.
        3. Aggregates product-level metrics:
            - Total Orders
            - Total Sales
            - Total Quantity Sold
            -Total Customers(unique)
            - lifespan (in months)
        4. Calculate Valuable KPIs:
            - Recency (months since last sales)
            - Average order revenue(AOR)
            - Average monthly revenue
==============================================================================================
*/


CREATE VIEW Gold_Product_Report AS
WITH Base_Query AS (
/*-------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
-------------------------------------------------------------------------------------------*/
Select
    f.Order_Number,
    f.Order_Date,
    f.customer_key,
    f.Sales_Amount,
    f.Quantity,
    p.Product_Key,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    p.Cost
    from Gold_Fact_Sales f
    left join Gold_Dim_Products p
        ON p.product_key = f.product_key
    WHERE Order_Date IS NOT NULL ),-- Only consider valid sales dates
    

    Product_Aggregation AS (
    /*-------------------------------------------------------------------------------------------
    2) Product Aggregation: Summarizes key metrics at the product level
    -------------------------------------------------------------------------------------------*/
    Select 
        Product_Key,
        Product_Name,
        Category,
        Subcategory,
        Cost,
        DATEDIFF(MONTH, MIN(Order_Date), MAX(Order_Date)) AS Lifespan,
        MAX(order_date) AS Last_sale_date,
        COUNT(DISTINCT Order_Number) AS Total_Orders,
        COUNT(DISTINCT customer_key) AS Total_Customers,
        SUM(Sales_Amount) AS Total_Sales,
        SUM(Quantity) AS Total_Quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT)/ NULLIF (quantity, 0)),1) AS Avg_Selling_Price
    from Base_Query 
    GROUP BY 
        Product_Key,
        Product_Name,
        Category,
        Subcategory,
        Cost
    )
    /*-------------------------------------------------------------------------------------------
    3) Final Query: Combines all product results into one output
    -------------------------------------------------------------------------------------------*/
    Select 
        Product_Key,
        Product_Name,
        Category,
        Subcategory,
        Cost,
        Last_sale_date,
        DATEDIFF(MONTH, Last_sale_date, GETDATE()) AS Recency_in_Months,
        CASE WHEN Total_Sales > 50000 THEN 'High-Performance'
             WHEN Total_Sales >=10000 THEN 'Mid-Range'
             ELSE 'Low-Performer'
        END AS Product_Segment,
        lifespan,
        Total_Orders,
        Total_Sales,
        Total_Quantity,
        Total_Customers,
        Avg_Selling_Price,
-- Compute Average order revenue (AOR)
CASE 
        WHEN total_orders = 0 THEN 0
        ELSE Total_Sales/Total_Orders
END AS Average_Order_Revenue,
-- Compute Average Monthly Revenue
CASE 
    WHEN Lifespan = 0 THEN Total_Sales
    ELSE Total_Sales/Lifespan
END AS Average_Monthly_Revenue
From Product_Aggregation

SELECT * FROM Gold_Product_Report
/*-------------------------------------------------------------------------------------------
Explanation of the Code:
1. Base Query: This CTE retrieves essential product and sales data, including order details,
product information, and calculates the lifespan of products in months.
2. Product Aggregation: This CTE aggregates the data at the product level, calculating total orders,
total sales, total quantity sold, total customers, last sale date, and lifespan in months.
3. Final Select: This section categorizes products into segments (High-Performance, Mid-Range, Low-Performer),
and computes valuable KPIs such as recency, average order revenue, and average monthly revenue.
4. The final SELECT statement retrieves all columns from the created view for reporting purposes.

Note: This view can be used to generate comprehensive product reports, enabling businesses
to analyze product performance, segment products effectively, and make informed decisions based on key metrics and KPIs.
---------------------------------------------------------------------------------------------*/
    