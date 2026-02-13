DROP DATABASE IF EXISTS Lab06_6788112;
CREATE DATABASE Lab06_6788112;
USE Lab06_6788112;

-- Task 1
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS shippers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS orderDetails;

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    birthdate DATE,
    photo VARCHAR(255),
    notes TEXT
);

CREATE TABLE shippers (
    shipper_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    phone VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    supplier_id INT,
    category_id INT,
    unit VARCHAR(255),
    price DECIMAL(10 , 2 ),
    CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATE,
    shipper_id INT,
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),
    CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id),
    CONSTRAINT fk_orders_shipper FOREIGN KEY (shipper_id)
        REFERENCES shippers (shipper_id)
);

CREATE TABLE orderDetails (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    CONSTRAINT fk_orderdetails_order FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT fk_orderdetails_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE '/private/var/lib/mysql-files/categories.csv'
    INTO TABLE categories
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

LOAD DATA INFILE '/private/var/lib/mysql-files/customers.csv'
    INTO TABLE customers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;    

LOAD DATA INFILE '/private/var/lib/mysql-files/employees.csv'
    INTO TABLE employees
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;   

LOAD DATA INFILE '/private/var/lib/mysql-files/shippers.csv'
    INTO TABLE shippers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;   

LOAD DATA INFILE '/private/var/lib/mysql-files/suppliers.csv'
    INTO TABLE suppliers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS; 

LOAD DATA INFILE '/private/var/lib/mysql-files/orders.csv'
    INTO TABLE orders
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;   

LOAD DATA INFILE '/private/var/lib/mysql-files/products.csv'
    INTO TABLE products
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;   

LOAD DATA INFILE '/private/var/lib/mysql-files/orderDetails.csv'
    INTO TABLE orderDetails
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

-- Check Task 1
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM shippers;
SELECT * FROM suppliers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderDetails;

SELECT 'Product Name', 'Category Name', 'Supplier Name' 
UNION ALL SELECT 
    p.name AS 'Product Name',
    c.name AS 'Category Name',
    s.name AS 'Supplier Name'
FROM
    Products p
        JOIN
    Categories c ON p.category_id = c.category_id
        JOIN
    Suppliers s ON p.supplier_id = s.supplier_id INTO OUTFILE '/private/var/lib/mysql-files/2A.csv' FIELDS ENCLOSED BY '"' TERMINATED BY ',' ESCAPED BY '"' LINES TERMINATED BY '
';

-- 2b
SELECT 'Customer Name', 'Order Date', 'Items Count' 
UNION ALL SELECT 
    c.name AS 'Customer Name',
    o.order_date AS 'Order Date',
    COUNT(od.product_id) AS 'Items Count'
FROM
    Customers c
        JOIN
    Orders o ON c.customer_id = o.customer_id
        JOIN
    OrderDetails od ON o.order_id = od.order_id
GROUP BY o.order_id , c.name , o.order_date INTO OUTFILE '/private/var/lib/mysql-files/2B.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
';

-- 2c
SELECT 'Employee Name', 'Shipper Name', 'Total Shipments' 
UNION ALL SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name',
    s.name AS 'Shipper Name',
    COUNT(o.order_id) AS 'Total Shipments'
FROM
    Employees e
        JOIN
    Orders o ON e.employee_id = o.employee_id
        JOIN
    Shippers s ON o.shipper_id = s.shipper_id
GROUP BY e.employee_id , s.shipper_id INTO OUTFILE '/private/var/lib/mysql-files/2C.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '
';