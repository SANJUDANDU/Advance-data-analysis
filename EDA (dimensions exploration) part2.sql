--Explore All countries our customers are from??

SELECT DISTINCT Country FROM Gold_Dim_Customers

--Explore All the Categories "The Major Divisions"

SELECT DISTINCT CATEGORY, SubCategory,Product_Name FROM Gold_Dim_Products
ORDER BY 1,2,3