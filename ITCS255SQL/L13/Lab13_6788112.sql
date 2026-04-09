USE classicmodels_db;

-- Task 1
START TRANSACTION;
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName,
                       phone, addressLine1, city, country, creditLimit)
VALUES (500, 'New Customer Co.', 'Smith', 'John',
        '1234567890', '123 Main St', 'Bangkok', 'Thailand', 50000.00);
COMMIT;

-- Task 2
START TRANSACTION;
UPDATE customers
SET creditLimit = 99999.00
WHERE customerNumber = 103;
ROLLBACK;

-- Task 3
START TRANSACTION;
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (10500, '2025-01-01', '2025-01-10', NULL, 'In Process', 'New order', 103);
COMMIT;

-- Task 4
START TRANSACTION;
UPDATE orders
SET status = 'Shipped'
WHERE orderNumber = 10500;
COMMIT;

-- Task 5
START TRANSACTION;
DELETE
FROM payments
WHERE customerNumber = 103
  AND checkNumber = 'HQ336336';
ROLLBACK;

-- Task 6
START TRANSACTION;
UPDATE products
SET quantityInStock = quantityInStock - 10
WHERE productCode = 'S10_1678';
COMMIT;

-- Task 7
SET autocommit = 0;
START TRANSACTION;
INSERT INTO products (productCode, productName, productLine, productScale,
                      productVendor, productDescription, quantityInStock, buyPrice, MSRP)
VALUES ('S99_9999', 'Test Model Car', 'Classic Cars', '1:10',
        'Test Vendor', 'A test product for lab purposes.', 100, 20.00, 50.00);
COMMIT;
SET autocommit = 1;

-- Task 8
LOCK TABLES products WRITE;
UPDATE products
SET quantityInStock = quantityInStock + 50
WHERE productCode = 'S10_1678';
UNLOCK TABLES;

-- Task 9
DROP PROCEDURE IF EXISTS list_employee_emails;
DELIMITER $$
CREATE PROCEDURE list_employee_emails(INOUT email_list TEXT)
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_email VARCHAR(100) DEFAULT '';
    DECLARE cur CURSOR FOR SELECT email FROM employees;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    SET email_list = '';
    email_loop:
    LOOP
        FETCH cur INTO v_email;
        IF done = TRUE THEN
            LEAVE email_loop;
        END IF;
        SET email_list = CONCAT(v_email, ';', email_list);
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;
-- Call Task 9
SET @EMAIL_LIST = '';
CALL list_employee_emails(@EMAIL_LIST);
SELECT @EMAIL_LIST;

-- Task 10
DROP PROCEDURE IF EXISTS list_customer_names;
DELIMITER $$
CREATE PROCEDURE list_customer_names(INOUT name_list TEXT)
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_name VARCHAR(50) DEFAULT '';
    DECLARE cur CURSOR FOR SELECT customerName FROM customers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    SET name_list = '';
    name_loop:
    LOOP
        FETCH cur INTO v_name;
        IF done = TRUE THEN
            LEAVE name_loop;
        END IF;
        IF name_list = '' THEN
            SET name_list = v_name;
        ELSE
            SET name_list = CONCAT(name_list, ',', v_name);
        END IF;
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;

-- Call Task 10
SET @NAME_LIST = '';
CALL list_customer_names(@NAME_LIST);
SELECT @NAME_LIST;

-- Task 11
START TRANSACTION;
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (10501, '2025-01-05', '2025-01-15', NULL, 'In Process', NULL, 112);
INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (10501, 'S10_1678', 20, 95.70, 1);
COMMIT;

-- Task 12
START TRANSACTION;
UPDATE products
SET quantityInStock = quantityInStock - 9999
WHERE productCode = 'S10_1678';

-- Check Task 12
SET @STOCK = (
                 SELECT quantityInStock
                 FROM products
                 WHERE productCode = 'S10_1678'
                 );
IF @stock < 0 THEN
ROLLBACK;
ELSE
COMMIT;
END IF;

DROP PROCEDURE IF EXISTS place_order_with_stock_check;
DELIMITER $$
CREATE PROCEDURE place_order_with_stock_check(
    IN p_productCode VARCHAR(15),
    IN p_qty INT
)
BEGIN
    DECLARE v_stock INT;
    START TRANSACTION;
    UPDATE products
    SET quantityInStock = quantityInStock - p_qty
    WHERE productCode = p_productCode;
    SELECT quantityInStock INTO v_stock FROM products WHERE productCode = p_productCode;
    IF v_stock < 0 THEN
        ROLLBACK;
        SELECT 'Transaction rolled back: insufficient stock' AS result;
    ELSE
        COMMIT;
        SELECT 'Transaction committed' AS result;
    END IF;
END$$
DELIMITER ;

-- Task 13
START TRANSACTION;
UPDATE customers
SET creditLimit = creditLimit + 5000.00
WHERE customerNumber = 112;
INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
VALUES (112, 'TX000001', '2025-01-05', 5000.00);
COMMIT;

-- Task 14
START TRANSACTION;
UPDATE employees
SET officeCode = '2'
WHERE employeeNumber = 1002;
ROLLBACK;

-- Task 15
DROP PROCEDURE IF EXISTS count_orders_per_customer;
DELIMITER $$
CREATE PROCEDURE count_orders_per_customer()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_orderNumber INT;
    DECLARE v_customerNumber INT;
    DECLARE v_prevCustomer INT DEFAULT -1;
    DECLARE v_count INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT orderNumber, customerNumber FROM orders ORDER BY customerNumber;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS order_counts;
    CREATE TEMPORARY TABLE order_counts (
        customerNumber INT,
        orderCount     INT
    );

    OPEN cur;
    order_loop:
    LOOP
        FETCH cur INTO v_orderNumber, v_customerNumber;
        IF done = TRUE THEN
            IF v_prevCustomer != -1 THEN
                INSERT INTO order_counts VALUES (v_prevCustomer, v_count);
            END IF;
            LEAVE order_loop;
        END IF;
        IF v_customerNumber != v_prevCustomer THEN
            IF v_prevCustomer != -1 THEN
                INSERT INTO order_counts VALUES (v_prevCustomer, v_count);
            END IF;
            SET v_prevCustomer = v_customerNumber;
            SET v_count = 1;
        ELSE
            SET v_count = v_count + 1;
        END IF;
    END LOOP;
    CLOSE cur;

    SELECT * FROM order_counts;
END$$
DELIMITER ;

CALL count_orders_per_customer();

-- Task 16
DROP PROCEDURE IF EXISTS total_payment_per_customer;
DELIMITER $$
CREATE PROCEDURE total_payment_per_customer()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_customerNumber INT;
    DECLARE v_amount DECIMAL(10, 2);
    DECLARE v_prevCustomer INT DEFAULT -1;
    DECLARE v_total DECIMAL(10, 2) DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT customerNumber, amount FROM payments ORDER BY customerNumber;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS payment_totals;
    CREATE TEMPORARY TABLE payment_totals (
        customerNumber INT,
        totalAmount    DECIMAL(10, 2)
    );

    OPEN cur;
    pay_loop:
    LOOP
        FETCH cur INTO v_customerNumber, v_amount;
        IF done = TRUE THEN
            IF v_prevCustomer != -1 THEN
                INSERT INTO payment_totals VALUES (v_prevCustomer, v_total);
            END IF;
            LEAVE pay_loop;
        END IF;
        IF v_customerNumber != v_prevCustomer THEN
            IF v_prevCustomer != -1 THEN
                INSERT INTO payment_totals VALUES (v_prevCustomer, v_total);
            END IF;
            SET v_prevCustomer = v_customerNumber;
            SET v_total = v_amount;
        ELSE
            SET v_total = v_total + v_amount;
        END IF;
    END LOOP;
    CLOSE cur;

    SELECT * FROM payment_totals;
END$$
DELIMITER ;

CALL total_payment_per_customer();

-- Task 17
DROP PROCEDURE IF EXISTS low_stock_products;
DELIMITER $$
CREATE PROCEDURE low_stock_products()
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_productCode VARCHAR(15);
    DECLARE v_productName VARCHAR(70);
    DECLARE v_qty SMALLINT;

    DECLARE cur CURSOR FOR
        SELECT productCode, productName, quantityInStock
        FROM products
        WHERE quantityInStock < 100;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TEMPORARY TABLE IF EXISTS low_stock;
    CREATE TEMPORARY TABLE low_stock (
        productCode     VARCHAR(15),
        productName     VARCHAR(70),
        quantityInStock SMALLINT
    );

    OPEN cur;
    stock_loop:
    LOOP
        FETCH cur INTO v_productCode, v_productName, v_qty;
        IF done = TRUE THEN
            LEAVE stock_loop;
        END IF;
        INSERT INTO low_stock VALUES (v_productCode, v_productName, v_qty);
    END LOOP;
    CLOSE cur;

    SELECT * FROM low_stock;
END$$
DELIMITER ;

CALL low_stock_products();

-- Task 18
DROP PROCEDURE IF EXISTS transfer_credit;
DELIMITER $$
CREATE PROCEDURE transfer_credit(
    IN p_fromCustomer INT,
    IN p_toCustomer INT,
    IN p_amount DECIMAL(10, 2)
)
BEGIN
    DECLARE v_credit DECIMAL(10, 2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SELECT 'Transaction rolled back due to error' AS result;
        END;

    START TRANSACTION;
    SELECT creditLimit INTO v_credit FROM customers WHERE customerNumber = p_fromCustomer FOR UPDATE;
    IF v_credit < p_amount THEN
        ROLLBACK;
        SELECT 'Insufficient credit limit' AS result;
    ELSE
        UPDATE customers SET creditLimit = creditLimit - p_amount WHERE customerNumber = p_fromCustomer;
        UPDATE customers SET creditLimit = creditLimit + p_amount WHERE customerNumber = p_toCustomer;
        COMMIT;
        SELECT 'Credit transfer committed' AS result;
    END IF;
END$$
DELIMITER ;

CALL transfer_credit(103, 112, 1000.00);

-- Task 19
DROP PROCEDURE IF EXISTS insert_order_with_details;
DELIMITER $$
CREATE PROCEDURE insert_order_with_details()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SELECT 'Transaction rolled back: insert failed' AS result;
        END;

    START TRANSACTION;
    INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
    VALUES (10502, '2025-02-01', '2025-02-10', NULL, 'In Process', NULL, 119);

    INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
    VALUES (10502, 'S10_1678', 5, 95.70, 1);

    INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
    VALUES (10502, 'S72_1253', 3, 45.00, 2);

    INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
    VALUES (10502, 'S700_3505', 10, 80.00, 3);
    COMMIT;
    SELECT 'Order and details committed' AS result;
END$$
DELIMITER ;

CALL insert_order_with_details();

-- Task 20
DROP PROCEDURE IF EXISTS update_stock_for_order;
DELIMITER $$
CREATE PROCEDURE update_stock_for_order(IN p_orderNumber INT)
BEGIN
    DECLARE done BOOL DEFAULT FALSE;
    DECLARE v_productCode VARCHAR(15);
    DECLARE v_qty INT;
    DECLARE v_stock INT;
    DECLARE v_insufficient INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT productCode, quantityOrdered FROM orderdetails WHERE orderNumber = p_orderNumber;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    START TRANSACTION;

    OPEN cur;
    stock_check:
    LOOP
        FETCH cur INTO v_productCode, v_qty;
        IF done = TRUE THEN
            LEAVE stock_check;
        END IF;
        SELECT quantityInStock INTO v_stock FROM products WHERE productCode = v_productCode FOR UPDATE;
        IF v_stock < v_qty THEN
            SET v_insufficient = 1;
            LEAVE stock_check;
        END IF;
        UPDATE products SET quantityInStock = quantityInStock - v_qty WHERE productCode = v_productCode;
    END LOOP;
    CLOSE cur;

    IF v_insufficient = 1 THEN
        ROLLBACK;
        SELECT CONCAT('Rollback: insufficient stock for order ', p_orderNumber) AS result;
    ELSE
        COMMIT;
        SELECT CONCAT('Stock updated and committed for order ', p_orderNumber) AS result;
    END IF;
END$$
DELIMITER ;

CALL update_stock_for_order(10100);