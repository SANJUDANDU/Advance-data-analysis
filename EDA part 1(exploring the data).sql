---Explore all the Objects in the Database

SELECT * FROM INFORMATION_SCHEMA.TABLES


---Explore all the columns in the database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Gold_Dim_Customers'