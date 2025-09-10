USE ecommerce_dirty;

-- ___________________________________________ CREAR TABLAS _________________________________
-- Tabla de productos
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

-- Tabla de clientes
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    region VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);

-- Tabla de ventas
CREATE TABLE sales (
    order_id VARCHAR(15) PRIMARY KEY,
    order_date VARCHAR(20),  -- como string para corregir formatos luego
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);

-- Tabla de calendario
CREATE TABLE calendar (
    date VARCHAR(20),  -- también como string
    year INT,
    month INT,
    week INT,
    day_name VARCHAR(15)
);

-- _______________________________________ LIMPIEZA DE DATOS __________________________________________
SELECT * FROM sales;

SELECT DISTINCT order_date 
FROM sales
ORDER BY order_date;

-- Agregar una nueva columna temporal para guardar la fecha limpia
ALTER TABLE sales ADD COLUMN order_date_clean DATE;

-- Para fechas con guiones y formato DD-MM-YYYY
UPDATE sales
SET order_date_clean = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_date LIKE '__-__-____';

-- Para fechas con diagonales y formato YYYY/MM/DD
UPDATE sales
SET order_date_clean = STR_TO_DATE(order_date, '%Y/%m/%d')
WHERE order_date LIKE '____/__/__';

SELECT order_date, order_date_clean
FROM sales
ORDER BY order_date_clean;

-- verificar
SELECT * 
FROM sales 
WHERE order_date_clean IS NULL;

DESCRIBE sales;

CREATE TABLE sales_clean AS
SELECT *
FROM sales
WHERE sales >= 0;

SELECT * FROM sales_clean;
SELECT * FROM products_clean;
SELECT * FROM calendar;

--  _____________________________________________ limpiar tabla PRODUCTS____________________
SELECT *
FROM products
WHERE TRIM(sub_category) = '' OR sub_category IS NULL;

-- 1. Actualizar el registro con sub_category en blanco a 'Copiers'
UPDATE products
SET sub_category = 'Copiers'
WHERE TRIM(sub_category) = '';

DELETE FROM products
WHERE product_id IS NULL
  AND product_name IS NULL
  AND category IS NULL
  AND sub_category IS NULL;
  
SELECT *
FROM products
WHERE product_id IS NULL
  AND product_name IS NULL
  AND category IS NULL
  AND sub_category IS NULL;
  
DELETE FROM products
WHERE (TRIM(product_id) IS NULL OR TRIM(product_id) = '')
  AND (TRIM(product_name) IS NULL OR TRIM(product_name) = '')
  AND (TRIM(category) IS NULL OR TRIM(category) = '')
  AND (TRIM(sub_category) IS NULL OR TRIM(sub_category) = '');
  
CREATE TABLE products_clean AS
SELECT * FROM products
WHERE NOT (
  product_id IS NULL AND 
  product_name IS NULL AND 
  category IS NULL AND 
  sub_category IS NULL
);

SELECT * FROM products_clean;

SELECT DISTINCT category 
FROM products_clean 
ORDER BY category;

UPDATE products_clean 
SET category = 'Furniture' 
WHERE category = 'furnture';

--  _____________________________________________ limpiar tabla CUSTOMERS____________________
SELECT * FROM customers;

SELECT DISTINCT state 
FROM customers
ORDER BY state;

--  Actualizar registros
UPDATE customers
SET region = 'North'
WHERE region = 'norte';

UPDATE customers
SET state = 'Nuevo Leon'
WHERE state = 'Nuevo LeÃ³n';

UPDATE customers
SET state = 'Yucatan'
WHERE state = 'YucatÃ¡n';

UPDATE customers
SET state = 'Yucatan'
WHERE state = 'YucatÃ¡n';

SELECT *
FROM customers
WHERE segment = 'Corporate';

UPDATE customers
SET state = 'Yucatan'
WHERE TRIM(state) = '';

CREATE TABLE customers_clean AS
SELECT * FROM customers
WHERE NOT (
  customer_id IS NULL AND 
  customer_name IS NULL AND 
  segment IS NULL AND 
  region IS NULL AND 
  city IS NULL AND
  state IS NULL
);

SELECT * FROM customers_clean;
SELECT * FROM sales_clean;

--  _____________________________________________ limpiar tabla CALENDAR____________________
SELECT * FROM calendar;

SELECT date, COUNT(*) 
FROM calendar					-- este codigo nos muestar si hay fechas repetidas, en este caso no hay ninguna que se repite
GROUP BY date
HAVING COUNT(*) > 1;

-- _______ vamos a renombar la columna date y su tipo 

ALTER TABLE calendar
CHANGE `date` calendar_date VARCHAR(50);

ALTER TABLE calendar
ADD calendar_date_clean DATE;

UPDATE calendar
SET calendar_date_clean = STR_TO_DATE(calendar_date, '%d-%m-%Y');

ALTER TABLE calendar
DROP COLUMN calendar_date,
CHANGE calendar_date_clean calendar_date DATE;

UPDATE calendar
SET week = '1'
WHERE calendar_date = '2022-01-01';

UPDATE calendar
SET week = '1'
WHERE calendar_date = '2022-01-02';

UPDATE calendar
SET month = 'Diciembre'
WHERE month = '12';

SELECT * FROM calendar;

ALTER TABLE calendar
MODIFY month VARCHAR(50);

DESCRIBE calendar;

SELECT DISTINCT day_name 
FROM calendar
ORDER BY day_name;

SELECT * FROM sales_clean;
SELECT * FROM customers_clean;
SELECT * FROM products_clean;
SELECT * FROM calendar;













