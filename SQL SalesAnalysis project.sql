-- Customers Table
CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    city VARCHAR,
    country VARCHAR,
    user_tag VARCHAR,
    code INT
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    beverage VARCHAR,
    cost_price NUMERIC,
    selling_price NUMERIC
);

-- For Customers
COPY customers(customer_id, first_name, last_name, email, city, country, user_tag, code)
FROM 'C:\Program Files\PostgreSQL\17\data\Customers.csv' DELIMITER ',' CSV HEADER;

-- For Orders
COPY orders(order_date, order_id, customer_id, beverage, cost_price, selling_price)
FROM 'C:\Program Files\PostgreSQL\17\data\Orders.csv' DELIMITER ',' CSV HEADER;

 select * from orders;
 Select * from customers;


 SELECT 
    o.order_id,
    o.customer_id AS original_id,
    'cust-' || LPAD(o.customer_id::TEXT, 5, '0') AS formatted_id,
    c.customer_id AS customer_table_id
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
LIMIT 5; 

--1)What is the total sales amount by region?

SELECT 
    c.country AS region,
    SUM(o.selling_price) AS total_sales
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;


--2)Which products generated the most sales?
SELECT 
    beverage,
    SUM(selling_price) AS total_sales
FROM orders
GROUP BY beverage
ORDER BY total_sales DESC;


--3)How does the discount affect profit?

SELECT 
    order_id,
    beverage,
    selling_price,
    cost_price,
    (selling_price - cost_price) AS discount,
    (selling_price - cost_price) AS profit
FROM orders
ORDER BY discount DESC;

--4)How much sales does each customer segment contribute?


SELECT 
    c.user_tag AS segment,
    SUM(o.selling_price) AS total_sales
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
GROUP BY c.user_tag
ORDER BY total_sales DESC;

--5)What are the total sales for each product category?
SELECT 
    beverage AS product_category,
    SUM(selling_price) AS total_sales
FROM orders
GROUP BY beverage
ORDER BY total_sales DESC;

--6)How many orders were shipped by each shipping mode?

ALTER TABLE customers ADD COLUMN region VARCHAR;
UPDATE customers
SET region = CASE
    WHEN city IN ('Mumbai', 'Delhi', 'Hyderabad') THEN 'West'
    WHEN city IN ('Chennai', 'Bangalore') THEN 'South'
    WHEN city IN ('Kolkata') THEN 'East'
    WHEN city IN ('Lucknow', 'Patna') THEN 'North'
    ELSE 'Central'
END;

UPDATE customers
SET region = CASE
    WHEN country = 'India' THEN 'South Asia'
    WHEN country = 'Australia' THEN 'Oceania'
    WHEN country = 'England' THEN 'Europe'
    ELSE 'Other'
END;

SELECT 
    c.region,
    SUM(o.selling_price) AS region_sales,
    ROUND(
        100.0 * SUM(o.selling_price) / SUM(SUM(o.selling_price)) OVER (),
        2
    ) AS percent_of_total
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
GROUP BY c.region
ORDER BY percent_of_total DESC;







--7)What are the total sales for each month?


SELECT 
    TO_CHAR(order_date, 'Month YYYY') AS month,
    SUM(selling_price) AS total_sales
FROM orders
GROUP BY TO_CHAR(order_date, 'Month YYYY')
ORDER BY MIN(order_date);

--8)How many customers are there in each state?

SELECT 
    city AS state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

--9) Who are the top 5 customers in terms of total sales?
 
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.selling_price) AS total_sales
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;

--10)What is the total sales for each product subcategory?

SELECT 
    beverage AS sub_category,
    SUM(selling_price) AS total_sales
FROM orders
GROUP BY beverage
ORDER BY total_sales DESC;

--11) How can we rank products by their total sales within each product category?
    beverage,
    SUM(selling_price) AS total_sales,
    RANK() OVER (ORDER BY SUM(selling_price) DESC) AS sales_rank
FROM orders
GROUP BY beverage
ORDER BY sales_rank;

--12)How can we calculate cumulative sales over time (running total) for each product? 
SELECT 
    beverage,
    order_date,
    SUM(selling_price) OVER (PARTITION BY beverage ORDER BY order_date) AS cumulative_sales
FROM orders
ORDER BY beverage, order_date;

--13) How can we find the top 3 customers based on profit within each region?
SELECT * FROM (
    SELECT 
        c.country AS region,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(o.selling_price - o.cost_price) AS total_profit,
        RANK() OVER (PARTITION BY c.country ORDER BY SUM(o.selling_price - o.cost_price) DESC) AS rank
    FROM orders o
    JOIN customers c 
        ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
    GROUP BY c.country, customer_name
) ranked
WHERE rank <= 3
ORDER BY region, rank;

--14) How can we find the average sales for each segment and assign a row number to each customer based on their sales?

SELECT 
    c.user_tag AS segment,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.selling_price,
    AVG(o.selling_price) OVER (PARTITION BY c.user_tag) AS avg_sales_in_segment,
    ROW_NUMBER() OVER (PARTITION BY c.user_tag ORDER BY o.selling_price DESC) AS row_num
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id;

--15) How can we calculate the difference in sales between consecutive days for each product?
SELECT 
    beverage,
    order_date,
    selling_price,
    selling_price - LAG(selling_price, 1, 0) OVER (PARTITION BY beverage ORDER BY order_date) AS sales_diff
FROM orders
ORDER BY beverage, order_date;

--16)How can we calculate the percentage of total sales contributed by each region?

SELECT 
    c.country AS region,
    SUM(o.selling_price) AS region_sales,
    ROUND(
        100.0 * SUM(o.selling_price) / SUM(SUM(o.selling_price)) OVER (),
        2
    ) AS percent_of_total
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
GROUP BY c.country
ORDER BY percent_of_total DESC;


--17) How can we calculate the moving average of sales over the last 3 orders for each product?
SELECT 
    beverage,
    order_date,
    selling_price,
    ROUND(
        AVG(selling_price) OVER (
            PARTITION BY beverage ORDER BY order_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg
FROM orders
ORDER BY beverage, order_date;

--18)How can we find the largest and smallest order (by sales) for each customer?
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_id,
    o.selling_price,
    MAX(o.selling_price) OVER (PARTITION BY c.customer_id) AS max_order,
    MIN(o.selling_price) OVER (PARTITION BY c.customer_id) AS min_order
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
ORDER BY customer_name;


--19)How can we calculate the running total of profit for each customer?

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    (o.selling_price - o.cost_price) AS profit,
    SUM(o.selling_price - o.cost_price) OVER (
        PARTITION BY c.customer_id ORDER BY o.order_date
    ) AS running_total_profit
FROM orders o
JOIN customers c 
    ON 'cust-' || LPAD(o.customer_id::TEXT, 5, '0') = c.customer_id
ORDER BY customer_name, o.order_date;

--20)How can we assign a dense rank to each sale based on total sales, grouped by ship mode?

ALTER TABLE orders ADD COLUMN ship_mode VARCHAR;

UPDATE orders
SET ship_mode = CASE 
    WHEN order_id % 3 = 0 THEN 'Standard Class'
    WHEN order_id % 3 = 1 THEN 'First Class'
    ELSE 'Second Class'
END;

SELECT 
    order_id,
    ship_mode,
    selling_price,
    DENSE_RANK() OVER (
        PARTITION BY ship_mode ORDER BY selling_price DESC
    ) AS sales_rank
FROM orders
ORDER BY ship_mode, sales_rank;








	












