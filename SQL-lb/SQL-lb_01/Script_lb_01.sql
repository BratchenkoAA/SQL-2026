-- =====================================================
-- ЗАДАНИЕ 1: Товары типа 'scooter' дороже $500
-- =====================================================
SELECT *
FROM products
WHERE product_type = 'scooter' 
  AND base_msrp > 500
ORDER BY base_msrp DESC;

-- =====================================================
-- ЗАДАНИЕ 2: Интернет-продажи от $15000 до $30000
-- =====================================================
SELECT *
FROM public.sales
WHERE channel = 'internet' 
  AND sales_amount BETWEEN 15000 AND 30000;

-- ========================================================================
-- ЗАДАНИЕ 3: CRUD операции с таблицей high_price (выполняется в pgAdmin 4)
-- ========================================================================

-- Шаг 1: Создание таблицы с товарами дороже $1000
DROP TABLE IF EXISTS high_price;
CREATE TABLE high_price AS
SELECT *
FROM products
WHERE base_msrp > 1000;

-- Шаг 2: Увеличение цены на 10%
UPDATE high_price
SET base_msrp = base_msrp * 1.10;

-- Шаг 3: Удаление товаров выпущенных до 2015 года
DELETE FROM high_price
WHERE year < 2015;

-- Шаг 4: Итоговая выборка
SELECT * FROM high_price;