Create Database Project;
Use Project;
	
select * from sales;
Select * from Products;
Select * from customers;
select * from city;
desc sales;
Alter table sales add S_Date Date;
Set SQL_Safe_UPDATES = 0;
Update sales set S_Date = str_to_date(sale_date, '%m/%d/%Y');
desc Sales;
select total_amount from sales;


-- How can you identify null values in your dataset?
select * from sales
Where sale_id is Null OR sale_date ;

-- How can you check for duplicate entries in the customers table?
SELECT customer_name, City_id, Count(*) as Duplicate_count FROM customers
group by city_id, customer_name
having  count(*) > 1;

-- How do you check for mismatches between total_amount and the calculated value of price × quantity?
SELECT s.sale_id, s.Product_id, s.Quantity, p.Price, s.Total_amount,
(p.Price * s.Quantity) AS Calculated_Total,
(s.Total_amount - (p.Price * s.Quantity)) AS Difference
FROM Sales s
JOIN Products p ON s.Product_id = p.Product_id
WHERE s.Total_amount != (p.Price * s.Quantity);

-- create a comprehensive sales report with customer and product details
SELECT
s.Sale_id, s.S_date, 
c.Customer_id, c.Customer_name,ct.City_name,
p.Product_id, p.Product_name, p.Price,
s.Quantity, s.Total_amount, s.Rating, s.S_Date
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN Products p ON s.Product_id = p.Product_id
JOIN City ct ON c.City_id = ct.City_id
ORDER BY s.S_date DESC;

-- What are the total sales per city?
Select city.city_name, sum(sales.total_amount) as total_sales from sales
join customers on sales.customer_id = customers.customer_id
join city on customers.city_id = city.city_id
group by city.city_name
order by total_sales Desc;

-- How many total transactions occurred per city?
Select 
city.city_name, 
count(sales.sale_id) as total_transactions from Sales
join customers on sales.customer_id = customers.customer_id
join city on customers.city_id = city.city_id
group by city.city_name
order by total_transactions;

-- How many unique customers are there in each city?
SELECT ct.City_id, ct.City_name,
COUNT(DISTINCT c.Customer_id) AS Unique_Customers
FROM Customers
JOIN City ct ON c.City_id = ct.City_id
GROUP BY ct.City_id, ct.City_name
ORDER BY Unique_Customers DESC;

-- What is the average order value per city?
SELECT ct.City_id, ct.City_name,
ROUND(AVG(s.Total_amount), 2) AS Avg_Order_Value
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN City ct ON c.City_id = ct.City_id
GROUP BY ct.City_id, ct.City_name
ORDER BY Avg_Order_Value DESC;

-- What is the demand for each product in different cities?
SELECT ct.City_id, ct.City_name,
    p.Product_id,p.Product_name,
    SUM(s.Quantity) AS Total_Demand
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN City ct ON c.City_id = ct.City_id
JOIN Products p ON s.Product_id = p.Product_id
GROUP BY ct.City_id, ct.City_name, p.Product_id, p.Product_name
ORDER BY ct.City_name, Total_Demand DESC;

-- What is the monthly sales trend?
SELECT 
    DATE_FORMAT (s.S_date, '%Y-%m') AS Sale_Month,
    SUM(s.Total_amount) AS Monthly_Sales
FROM Sales s
WHERE s.Sale_date IS NOT NULL
GROUP BY Sale_Month
ORDER BY Sale_Month;

desc sales;
select * from sales;

-- What is the average product rating per city based on customer purchases?
SELECT ct.City_id, ct.City_name,
    ROUND(AVG(s.rating), 2) AS Avg_Rating
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN City ct ON c.City_id = ct.City_id
WHERE s.rating IS NOT NULL
GROUP BY ct.City_id, ct.City_name
ORDER BY Avg_Rating DESC;

-- How do you identify the top 3 cities based on sales, unique customers, and order count?
SELECT ct.City_id, ct.City_name,
    ROUND(SUM(s.Total_amount), 2) AS Total_Sales,
    COUNT(DISTINCT c.Customer_id) AS Unique_Customers,
    COUNT(s.Sale_id) AS Order_Count
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN City ct ON c.City_id = ct.City_id
GROUP BY ct.City_id, ct.City_name
ORDER BY Total_Sales DESC
Limit 3;

-- *Top Performing Cities by Total Sales
SELECT ct.City_id, ct.City_name,
    ROUND(SUM(s.Total_amount), 2) AS Total_Sales
FROM Sales s
JOIN Customers c ON s.Customer_id = c.Customer_id
JOIN City ct ON c.City_id = ct.City_id
GROUP BY ct.City_id, ct.City_name
ORDER BY Total_Sales DESC
LIMIT 5;

-- High Customer Density (Customers per City)
SELECT ct.City_id, ct.City_name,
    COUNT(c.Customer_id) AS Customer_Count
FROM Customers c
JOIN City ct ON c.City_id = ct.City_id
GROUP BY ct.City_id, ct.City_name
ORDER BY Customer_Count DESC;

