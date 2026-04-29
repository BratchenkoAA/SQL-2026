

# Лабораторная работа №5. Оптимизация запросов с помощью индексов
## Вариант: 1
### Студент:Братченко Арина 

Цель работы
Научиться анализировать производительность SQL-запросов с помощью EXPLAIN ANALYZE и ускорять их с помощью индексов B-Tree.

# Задание 1. Анализ запроса на сервере (без индекса)
Запрос:
```
sql
EXPLAIN ANALYZE
SELECT * FROM customers WHERE gender = 'F';
```
Результат:

<img width="569" height="246" alt="image" src="https://github.com/user-attachments/assets/5a1c7ea0-97fc-4459-9aba-5f16ab75caea" />

 Скриншот 1. План выполнения на сервере


Вывод: Запрос использует последовательное сканирование, так как индекс на gender отсутствует.

# Задание 2. Создание индекса и сравнение (локально)
### 2.1. Подготовка данных
```
ALTER TABLE customers ADD COLUMN gender text;
UPDATE customers SET gender = CASE WHEN RANDOM() < 0.5 THEN 'M' ELSE 'F' END;
```
### 2.2. Без индекса
```
EXPLAIN (ANALYZE, BUFFERS, TIMING) 
SELECT * FROM customers WHERE gender = 'F';
```
<img width="800" height="240" alt="image" src="https://github.com/user-attachments/assets/142ab50f-8282-4903-9fb7-09de444928ea" />

 Скриншот 2. Результат ДО создания индекса

Execution Time: 0,050 ms

### 2.3. Создание индекса
```
CREATE INDEX idx_customers_gender ON customers(gender);
```
### 2.4. С индексом
```
EXPLAIN (ANALYZE, BUFFERS, TIMING) 
SELECT * FROM customers WHERE gender = 'F';
```
<img width="797" height="294" alt="image" src="https://github.com/user-attachments/assets/aa084f13-c8ef-4ce6-a324-69efd8bb665c" />

 Скриншот 3. Результат ПОСЛЕ создания индекса

Execution Time: 0,043 ms


# Задание 3. Оптимизация диапазонного запроса (локально)
### 3.1. Создание тестовых данных
```
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    dealership_id INTEGER,
    sales_amount NUMERIC(10,2),
    sales_transaction_date TIMESTAMP
);

INSERT INTO sales (dealership_id, sales_amount, sales_transaction_date)
SELECT (RANDOM() * 200 + 1)::INT,
       (RANDOM() * 49900 + 100)::NUMERIC(10,2),
       NOW() - (RANDOM() * INTERVAL '1095 days')
FROM GENERATE_SERIES(1, 100000);
```
### 3.2. Без индекса
```
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM sales WHERE dealership_id BETWEEN 10 AND 20;
```
<img width="451" height="244" alt="image" src="https://github.com/user-attachments/assets/c7f98996-c91f-4d81-9671-e6e693dfef0a" />

 Скриншот 4. Результат ДО создания индекса



### 3.3. Создание индекса
sql
CREATE INDEX idx_sales_dealership_id ON sales(dealership_id);
### 3.4. С индексом
sql
EXPLAIN (ANALYZE, BUFFERS, TIMING)
SELECT * FROM sales WHERE dealership_id BETWEEN 10 AND 20;
<img width="813" height="308" alt="image" src="https://github.com/user-attachments/assets/89f72e3b-c147-4f4a-844c-178de92f51d8" />

 Скриншот 5. Результат ПОСЛЕ создания индекса



### 3.5. 
<img width="898" height="424" alt="image" src="https://github.com/user-attachments/assets/aa924bda-275f-4be7-8326-7207a6f3c55e" />

### Выводы:
Seq Scan (последовательное сканирование) — медленный метод для выборочных запросов.

B-Tree индекс ускоряет как точные сравнения (=), так и диапазонные условия (BETWEEN, >).

EXPLAIN ANALYZE позволяет увидеть реальный план выполнения и сравнить эффективность до/после индекса.

Индексы имеют смысл для столбцов, которые часто используются в WHERE, JOIN и ORDER BY.
