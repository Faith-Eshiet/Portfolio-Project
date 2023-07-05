-- Selecting the entire dataset
SELECT *
FROM SalesData

-- Counting the number of rows
SELECT COUNT(*) AS total_rows
FROM SalesData
--There are 2823 rows

--Checking for dupliate
SELECT COUNT(DISTINCT ORDERNUMBER) AS total_rows
FROM SalesData
-- We have just 307 unique ordernumbers.

--Which month had the highest sales?
SELECT month_id AS month, SUM(sales) AS total_sales
FROM SalesData
GROUP BY month_id
ORDER BY total_sales DESC
--November had the highest sales

-- Which city sold the most product?
SELECT city, SUM(quantityordered) AS total_order
FROM SalesData
GROUP BY city
ORDER BY total_order DESC
-- Madrid sold the most products

--What products are most often sold together?
SELECT T1.productline, T2.productline, COUNT(*) AS purchase_frequency
FROM SalesData AS T1
	INNER JOIN SalesData AS T2
	ON T1.ordernumber = T2.ordernumber
	AND T1.customername = T2.customername
	AND T1.productline < T2.productline
GROUP BY T1.productline, T2.productline
ORDER BY purchase_frequency DESC
-- Classic Cars and Vintage Cars are the products most often sold together

-- Which day of the week has the highest orders?
SELECT DATENAME(WEEKDAY, orderdate) AS weekday,  SUM(quantityordered) AS orders
FROM SalesData
GROUP BY DATENAME(WEEKDAY, orderdate)
ORDER BY orders DESC
--Friday has the highest orders

-- What is the average order value?
SELECT AVG(quantityordered) AS avg_order
FROM SalesData
-- The average order is 35

-- What are the top 5 best-selling products?
SELECT TOP 5 productline, SUM(sales) AS total_sales 
FROM SalesData
GROUP BY productline
ORDER BY total_sales DESC

-- Is there an increase in sales over the years?
SELECT YEAR_ID, SUM(sales) AS total_sales
FROM SalesData
GROUP BY YEAR_ID
ORDER BY total_sales DESC
-- There is an increase in sales over the years.
-- (Note that the data stops at May, 2005.)

-- Which country makes the most orders?
SELECT TOP 5 COUNTRY, SUM(quantityordered) AS total_order
FROM SalesData
GROUP BY COUNTRY
ORDER BY total_order DESC
-- USA makes the most orders.