-- ЗАДАНИЕ 1: Список проданных моделей в штате CA
SELECT 
    p.model,
    s.sales_transaction_date
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE c.state = 'CA' OR d.state = 'CA';

-- ЗАДАНИЕ 2: Клиенты, купившие те же модели, что и клиент с ID = 1
SELECT DISTINCT 
    c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE p.model IN (
    SELECT p2.model
    FROM sales s2
    JOIN products p2 ON s2.product_id = p2.product_id
    WHERE s2.customer_id = 1
)
AND c.customer_id <> 1;

-- ЗАДАНИЕ 3: Категории цены товаров
SELECT 
    product_id,
    model,
    base_msrp,
    CASE
        WHEN base_msrp < 500 THEN 'Low'
        WHEN base_msrp BETWEEN 500 AND 2000 THEN 'Mid'
        ELSE 'High'
    END AS price_category
FROM products;