
-- ЗАДАНИЕ 1: Минимальная, максимальная и средняя цена

SELECT 
    MIN(base_msrp) AS min_price,
    MAX(base_msrp) AS max_price,
    ROUND(AVG(base_msrp), 2) AS avg_price
FROM products;

-- ЗАДАНИЕ 2: Количество клиентов по полу

SELECT 
    gender,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;

-- ЗАДАНИЕ 3: Штаты с суммой продаж более 10 000

SELECT 
    c.state,
    SUM(s.sales_amount) AS total_sales
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.state
HAVING SUM(s.sales_amount) > 10000
ORDER BY total_sales DESC;