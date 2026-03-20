-- Waris Sripatoomrak 6788112
USE PremierProducts;

-- Task 1
DROP PROCEDURE IF EXISTS sp_list_customers;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_customers()
BEGIN
    SELECT CustomerNum,
           CustomerName,
           City,
           State,
           Balance,
           CreditLine,
           RepNum
    FROM Customer;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 1
CALL sp_list_customers();

-- Task 2
DROP PROCEDURE IF EXISTS sp_list_parts;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_parts()
BEGIN
    SELECT PartNum,
           Description,
           OnHand,
           Class,
           Warehouse,
           Price
    FROM Part;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 2
CALL sp_list_parts();

-- Task 3
DROP PROCEDURE IF EXISTS sp_list_orders;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_orders()
BEGIN
    SELECT OrderNum,
           OrderDate,
           CustomerNum
    FROM Orders;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 3
CALL sp_list_orders();

-- Task 4
DROP PROCEDURE IF EXISTS sp_list_reps;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_reps()
BEGIN
    SELECT RepNum,
           FirstName,
           LastName,
           City,
           State,
           Commision,
           Rate
    FROM Rep;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 4
CALL sp_list_reps();

-- Task 5
DROP PROCEDURE IF EXISTS sp_list_orderline;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_orderline()
BEGIN
    SELECT OrderNum,
           PartNum,
           NumOrdered,
           QuotedPrice
    FROM OrderLine;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 5
CALL sp_list_orderline();

-- Task 6
DROP PROCEDURE IF EXISTS sp_list_currentorders;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_list_currentorders()
BEGIN
    SELECT CustomerName,
           OrderNum,
           PartNum,
           Description,
           NumOrdered,
           QuotedPrice,
           Warehouse,
           RepNum
    FROM CurrentOrders;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 6
CALL sp_list_currentorders();

-- Task 7
DROP FUNCTION IF EXISTS fn_part_value;
DELIMITER $$
CREATE FUNCTION fn_part_value(p_partnum VARCHAR(10))
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    DECLARE result INT DEFAULT 0;
    SELECT ( OnHand * Price ) INTO result FROM Part WHERE PartNum = p_partnum;
    RETURN result;
END $$
DELIMITER ;
-- Check 7
SELECT fn_part_value('BV06');

-- Task 8
DROP FUNCTION IF EXISTS fn_customer_remaining_credit;
DELIMITER $$
CREATE FUNCTION fn_customer_remaining_credit(p_customernum INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    DECLARE result INT DEFAULT 0;
    SELECT ( CreditLine - Balance ) INTO result FROM Customer WHERE CustomerNum = p_customernum;
    RETURN result;
END $$
DELIMITER ;
-- Check 8
SELECT fn_customer_remaining_credit(408);

-- Task 9
DROP FUNCTION IF EXISTS fn_rep_fullname;
DELIMITER $$
CREATE FUNCTION fn_rep_fullname(p_repnum INT)
    RETURNS VARCHAR(200)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(200) DEFAULT '';
    SELECT CONCAT(FirstName, ' ', LastName) INTO result FROM Rep WHERE RepNum = p_repnum;
    RETURN result;
END $$
DELIMITER ;
-- Check 9
SELECT fn_rep_fullname(35);

-- Task 10
SELECT CustomerName, fn_customer_remaining_credit(CustomerNum) AS RemainingCredit
FROM Customer;

-- Task 11
DROP PROCEDURE IF EXISTS sp_orders_by_customer;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_orders_by_customer(IN p_customernum INT)
BEGIN
    SELECT OrderNum, OrderDate, CustomerNum
    FROM Orders
    WHERE CustomerNum = p_customernum
    ORDER BY OrderDate DESC;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 11
CALL sp_orders_by_customer(148);

-- Task 12
DROP PROCEDURE IF EXISTS sp_parts_by_class;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_parts_by_class(IN p_class VARCHAR(10))
BEGIN
    SELECT PartNum, Description, Class, Price
    FROM Part
    WHERE Class = p_class
    ORDER BY Price DESC;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 12
CALL sp_parts_by_class('AP');

-- Task 13
DROP PROCEDURE IF EXISTS sp_count_orders_by_customer;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_count_orders_by_customer(IN p_customernum INT, OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM Orders WHERE CustomerNum = p_customernum;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 13
CALL sp_count_orders_by_customer(148, @P_TOTAL);
SELECT @P_TOTAL;

-- Task 14
DROP PROCEDURE IF EXISTS sp_total_orders;
DELIMITER $$ -- set custom delimiter
CREATE PROCEDURE sp_total_orders()
BEGIN
    DECLARE totalOrders INT DEFAULT 0;
    SELECT COUNT(*) INTO totalOrders FROM Orders;
    SELECT totalOrders AS totalOrders;
END $$
DELIMITER ; -- reset delimiter to default
-- Check 14
CALL sp_total_orders();

-- Task 15
DROP FUNCTION IF EXISTS fn_order_total;
DELIMITER $$
CREATE FUNCTION fn_order_total(p_ordernum INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(10, 2) DEFAULT 0;
    SELECT SUM(NumOrdered * QuotedPrice) INTO result FROM OrderLine WHERE OrderNum = p_ordernum;
    RETURN result;
END $$
DELIMITER ;
-- Check 15
SELECT fn_order_total(21613);

-- Task 16
DROP FUNCTION IF EXISTS fn_customer_total_spent;
DELIMITER $$
CREATE FUNCTION fn_customer_total_spent(p_customernum INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    DECLARE result DECIMAL(10, 2) DEFAULT 0;
    SELECT SUM(ol.QuotedPrice * ol.NumOrdered)
    INTO result
    FROM Orders o
             INNER JOIN OrderLine ol
                        ON o.OrderNum = ol.OrderNum
    WHERE o.CustomerNum = p_customernum;
    RETURN result;
END $$
DELIMITER ;
-- Check 16
SELECT fn_customer_total_spent(148);

-- Task 17
SELECT OrderNum, OrderDate, fn_order_total(OrderNum) AS TotalAmount
FROM Orders;

-- Task 18
DROP PROCEDURE IF EXISTS sp_apply_credit_charge;
DELIMITER $$
CREATE PROCEDURE sp_apply_credit_charge(
    IN p_customernum INT,
    IN p_charge DECIMAL(10, 2),
    INOUT p_new_balance DECIMAL(10, 2)
)
BEGIN
    DECLARE v_balance DECIMAL(10, 2);
    SELECT Balance
    INTO v_balance
    FROM Customer
    WHERE CustomerNum = p_customernum;
    SET p_new_balance = v_balance + p_charge;
    SELECT p_new_balance AS NewBalance;
END $$
DELIMITER ;
-- Check 18
SET @B = 0;
CALL sp_apply_credit_charge(148, 0.67, @B);
SELECT ROUND(@B, 2);

-- Task 19
DROP PROCEDURE IF EXISTS sp_best_customer;
DELIMITER $$
CREATE PROCEDURE sp_best_customer(
    OUT p_customernum INT,
    OUT p_customername VARCHAR(255),
    OUT p_total DECIMAL(10, 2)
)
BEGIN
    SELECT c.CustomerNum,
           c.CustomerName,
           SUM(ol.NumOrdered * ol.QuotedPrice) AS total_spent
    INTO
        p_customernum,
        p_customername,
        p_total
    FROM Customer c
             INNER JOIN Orders o
                        ON c.CustomerNum = o.CustomerNum
             INNER JOIN OrderLine ol
                        ON o.OrderNum = ol.OrderNum
    GROUP BY c.CustomerNum, c.CustomerName
    ORDER BY total_spent DESC
    LIMIT 1;
END $$
DELIMITER ;
-- Check 19
SET @A_CUSTOMERNUM = 0;
SET @A_CUSTOMERNAME = '';
SET @A_TOTAL = 0;
CALL sp_best_customer(@A_CUSTOMERNUM, @A_CUSTOMERNAME, @A_TOTAL);
SELECT @A_CUSTOMERNUM, @A_CUSTOMERNAME, ROUND(@A_TOTAL, 2);

-- Task 20
DROP FUNCTION IF EXISTS fn_credit_level;
DELIMITER $$
CREATE FUNCTION fn_credit_level(p_remaining DECIMAL(10, 2))
    RETURNS VARCHAR(10)
    DETERMINISTIC
BEGIN
    DECLARE v_level VARCHAR(10);
    IF p_remaining > 50000 THEN
        SET v_level = 'PLATINUM';
    ELSEIF p_remaining >= 10000 THEN
        SET v_level = 'GOLD';
    ELSE
        SET v_level = 'SILVER';
    END IF;
    RETURN v_level;
END $$
DELIMITER ;
-- Check 20
SELECT CustomerName,
       fn_customer_remaining_credit(CustomerNum)                  AS RemainingCredit,
       fn_credit_level(fn_customer_remaining_credit(CustomerNum)) AS CreditLevel
FROM Customer;