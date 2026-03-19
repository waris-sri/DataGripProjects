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
    DECLARE val INT DEFAULT 0;
    SELECT ( OnHand * Price ) INTO val FROM Part WHERE PartNum = p_partnum;
    RETURN val;
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
    DECLARE val INT DEFAULT 0;
    SELECT ( CreditLine - Balance ) INTO val FROM Customer WHERE CustomerNum = p_customernum;
    RETURN val;
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
    DECLARE val VARCHAR(200) DEFAULT '';
    SELECT CONCAT(FirstName, ' ', LastName) INTO val FROM Rep WHERE RepNum = p_repnum;
    RETURN val;
END $$
DELIMITER ;
-- Check 9
SELECT fn_rep_fullname(35);

-- Task 10
SELECT CustomerName, fn_customer_remaining_credit(CustomerNum) AS RemainingCredit
FROM Customer;