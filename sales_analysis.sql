CREATE DATABASE sales_analysis;

USE sales_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Alicia', 'Brown', 'St. Louis', 'MO'),
(2, 'Marcus', 'Johnson', 'Chicago', 'IL'),
(3, 'Tanya', 'Smith', 'Kansas City', 'MO'),
(4, 'David', 'Lee', 'Dallas', 'TX'),
(5, 'Rachel', 'Green', 'Atlanta', 'GA');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 899.99),
(102, 'Monitor', 'Electronics', 249.99),
(103, 'Desk Chair', 'Furniture', 179.99),
(104, 'Keyboard', 'Electronics', 79.99),
(105, 'Standing Desk', 'Furniture', 399.99);

INSERT INTO orders VALUES
(1001, 1, '2024-01-15', 101, 1),
(1002, 2, '2024-01-20', 102, 2),
(1003, 3, '2024-02-05', 103, 1),
(1004, 1, '2024-02-18', 104, 3),
(1005, 4, '2024-03-02', 105, 1),
(1006, 5, '2024-03-15', 101, 1),
(1007, 2, '2024-04-01', 104, 2),
(1008, 3, '2024-04-12', 102, 1),
(1009, 1, '2024-05-03', 105, 1),
(1010, 5, '2024-05-21', 103, 2);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;

SELECT 
    p.product_name,
    p.category,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;

/*This query analyzes the top customers */
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    c.state,
    SUM(o.quantity * p.price) AS total_spent
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

/* This query shows monthly revenue trends */
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(o.quantity * p.price) AS revenue
FROM orders o
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;

/* This query shows repeat customers */
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1;

/*This query shows the revenue by category */
SELECT 
    p.category,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
