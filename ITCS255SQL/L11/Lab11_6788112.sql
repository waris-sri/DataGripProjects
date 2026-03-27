USE PremierProducts;

-- Task 1
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_customer_credit_level;
CREATE PROCEDURE sp_customer_credit_level(
    IN p_customer INT,
    OUT p_level VARCHAR(20)
)
BEGIN
    DECLARE credit_line INT DEFAULT 0;
    SELECT CreditLine INTO credit_line FROM Customer WHERE CustomerNum = p_customer;
    IF credit_line > 10000 THEN
        SET p_level = 'PLATINUM';
    ELSEIF ( credit_line >= 7500 && credit_line <= 10000 ) THEN
        SET p_level = 'GOLD';
    ELSEIF ( credit_line < 7500 ) THEN
        SET p_level = 'SILVER';
    END IF;
    SELECT p_level;
END$$
DELIMITER ;
-- Check 1
CALL sp_customer_credit_level(524, @LEVEL);
SELECT @LEVEL;

-- Task 2
DROP FUNCTION IF EXISTS fn_balance_status;
DELIMITER $$
CREATE FUNCTION fn_balance_status(balance DECIMAL(10, 2))
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20) DEFAULT '';
    IF balance < 0 THEN
        SET result = 'DEBT';
    ELSEIF balance < 1000 THEN
        SET result = 'LOW';
    ELSE
        SET result = 'NORMAL';
    END IF;
    RETURN result;
END$$
DELIMITER ;
-- Check 2
SELECT fn_balance_status(850);

-- Task 3
DROP PROCEDURE IF EXISTS sp_part_stock_status;
DELIMITER $$
CREATE PROCEDURE sp_part_stock_status(IN p_part VARCHAR(10), OUT p_status VARCHAR(20))
BEGIN
    DECLARE v_onhand INT DEFAULT 0;
    SELECT OnHand INTO v_onhand FROM Part WHERE PartNum = p_part;
    IF v_onhand = 0 THEN
        SET p_status = 'OUT_OF_STOCK';
    ELSEIF v_onhand < 10 THEN
        SET p_status = 'LOW_STOCK';
    ELSE
        SET p_status = 'AVAILABLE';
    END IF;
END$$
DELIMITER ;
-- Check 3
CALL sp_part_stock_status('DR93', @STATUS);
SELECT @STATUS;

-- Task 4
DROP FUNCTION IF EXISTS fn_part_price_level;
DELIMITER $$
CREATE FUNCTION fn_part_price_level(price DECIMAL(10, 2))
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20) DEFAULT '';
    IF price < 20 THEN
        SET result = 'CHEAP';
    ELSEIF price < 100 THEN
        SET result = 'NORMAL';
    ELSE
        SET result = 'EXPENSIVE';
    END IF;
    RETURN result;
END$$
DELIMITER ;
-- Check 4
SELECT fn_part_price_level(120);

-- Task 5
DROP PROCEDURE IF EXISTS sp_order_size_level;
DELIMITER $$
CREATE PROCEDURE sp_order_size_level(IN p_order INT, OUT p_level VARCHAR(20))
BEGIN
    DECLARE v_total INT DEFAULT 0;
    SELECT SUM(NumOrdered) INTO v_total FROM OrderLine WHERE OrderNum = p_order;
    IF v_total < 5 THEN
        SET p_level = 'SMALL';
    ELSEIF v_total < 10 THEN
        SET p_level = 'MEDIUM';
    ELSE
        SET p_level = 'LARGE';
    END IF;
END$$
DELIMITER ;
-- Check 5
CALL sp_order_size_level(21617, @LEVEL);
SELECT @LEVEL;

-- Task 6
DROP FUNCTION IF EXISTS fn_rep_commission_level;
DELIMITER $$
CREATE FUNCTION fn_rep_commission_level(rate FLOAT)
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20) DEFAULT '';
    IF rate < 0.05 THEN
        SET result = 'LOW';
    ELSEIF rate < 0.1 THEN
        SET result = 'MEDIUM';
    ELSE
        SET result = 'HIGH';
    END IF;
    RETURN result;
END$$
DELIMITER ;
-- Check 6
SELECT fn_rep_commission_level(0.11);

-- Task 7
DROP PROCEDURE IF EXISTS sp_customer_balance_warning;
DELIMITER $$
CREATE PROCEDURE sp_customer_balance_warning(IN p_customer INT, OUT p_status VARCHAR(20))
BEGIN
    DECLARE v_balance DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_credit DECIMAL(10, 2) DEFAULT 0;
    SELECT Balance, CreditLine
    INTO v_balance, v_credit
    FROM Customer
    WHERE CustomerNum = p_customer;
    IF v_balance > v_credit THEN
        SET p_status = 'OVER_LIMIT';
    ELSEIF v_balance > 0.8 * v_credit THEN
        SET p_status = 'WARNING';
    ELSE
        SET p_status = 'SAFE';
    END IF;
END$$
DELIMITER ;
-- Check 7
CALL sp_customer_balance_warning(148, @STATUS);
SELECT @STATUS;

-- Task 8
DROP FUNCTION IF EXISTS fn_order_quantity_level;
DELIMITER $$
CREATE FUNCTION fn_order_quantity_level(qty INT)
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(20) DEFAULT '';
    IF qty < 5 THEN
        SET result = 'SMALL';
    ELSEIF qty < 20 THEN
        SET result = 'MEDIUM';
    ELSE
        SET result = 'LARGE';
    END IF;
    RETURN result;
END$$
DELIMITER ;
-- Check 8
SELECT fn_order_quantity_level(21);

-- Task 9
DROP PROCEDURE IF EXISTS sp_part_inventory_warning;
DELIMITER $$
CREATE PROCEDURE sp_part_inventory_warning(IN p_part VARCHAR(10), OUT p_status VARCHAR(20))
BEGIN
    DECLARE v_onhand INT DEFAULT 0;
    SELECT OnHand INTO v_onhand FROM Part WHERE PartNum = p_part;
    IF v_onhand < 10 THEN
        SET p_status = 'CRITICAL';
    ELSEIF v_onhand < 20 THEN
        SET p_status = 'LOW';
    ELSE
        SET p_status = 'NORMAL';
    END IF;
END$$
DELIMITER ;
-- Check 9
CALL sp_part_inventory_warning('KT03', @STATUS);
SELECT @STATUS;

-- Task 10
DROP FUNCTION IF EXISTS fn_customer_debt_ratio;
DELIMITER $$
CREATE FUNCTION fn_customer_debt_ratio(balance DECIMAL(10, 2), creditline DECIMAL(10, 2))
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    DECLARE ratio FLOAT DEFAULT 0;
    DECLARE result VARCHAR(20) DEFAULT '';
    SET ratio = balance / creditline;
    IF ratio > 0.9 THEN
        SET result = 'RISK';
    ELSEIF ratio > 0.5 THEN
        SET result = 'WARNING';
    ELSE
        SET result = 'SAFE';
    END IF;
    RETURN result;
END$$
DELIMITER ;
-- Check 10
SELECT fn_customer_debt_ratio(3000, 10000);

-- Task 11
DROP PROCEDURE IF EXISTS sp_customer_region;
DELIMITER $$
CREATE PROCEDURE sp_customer_region(IN p_customer INT, OUT p_region VARCHAR(20))
BEGIN
    DECLARE v_zip VARCHAR(30) DEFAULT '';
    SELECT Zip INTO v_zip FROM Customer WHERE CustomerNum = p_customer;
    SET p_region = CASE v_zip
                       WHEN '32543' THEN 'NORTH-WEST'
                       WHEN '33503' THEN 'CENTER'
                       WHEN '33363' THEN 'SOUTH'
                       WHEN '33321' THEN 'SOUTH'
                       WHEN '33146' THEN 'SOUTH'
                       ELSE 'Not in List'
        END;
END$$
DELIMITER ;
-- Check 11
CALL sp_customer_region(148, @REGION);
SELECT @REGION;

-- Task 12
DROP FUNCTION IF EXISTS fn_part_class_label;
DELIMITER $$
CREATE FUNCTION fn_part_class_label(class VARCHAR(10))
    RETURNS VARCHAR(20)
    DETERMINISTIC
BEGIN
    RETURN CASE class
               WHEN 'HW' THEN 'Housewares'
               WHEN 'SG' THEN 'Sporting Goods'
               WHEN 'AP' THEN 'Appliances'
               ELSE 'Unknown'
        END;
END$$
DELIMITER ;
-- Check 12
SELECT fn_part_class_label('AP');

-- Task 13
DROP PROCEDURE IF EXISTS sp_rep_region;
DELIMITER $$
CREATE PROCEDURE sp_rep_region(IN p_rep INT, OUT p_region VARCHAR(20))
BEGIN
    DECLARE v_city VARCHAR(100) DEFAULT '';
    SELECT City INTO v_city FROM Rep WHERE RepNum = p_rep;
    SET p_region = CASE v_city
                       WHEN 'Grove' THEN 'A'
                       WHEN 'Sheldon' THEN 'B'
                       WHEN 'Fillmore' THEN 'V'
                       ELSE 'Unknown'
        END;
END$$
DELIMITER ;
-- Check 13
CALL sp_rep_region(35, @REGION);
SELECT @REGION;

-- Task 14
DROP FUNCTION IF EXISTS fn_order_day_type;
DELIMITER $$
CREATE FUNCTION fn_order_day_type(orderdate DATE)
    RETURNS VARCHAR(10)
    DETERMINISTIC
BEGIN
    RETURN CASE DAYOFWEEK(orderdate)
               WHEN 1 THEN 'WEEKEND'
               WHEN 7 THEN 'WEEKEND'
               ELSE 'WEEKDAY'
        END;
END$$
DELIMITER ;
-- Check 14
SELECT fn_order_day_type('2026-03-27');

-- Task 15
DROP PROCEDURE IF EXISTS sp_customer_credit_category;
DELIMITER $$
CREATE PROCEDURE sp_customer_credit_category(IN p_customer INT, OUT p_rank VARCHAR(20))
BEGIN
    DECLARE v_credit DECIMAL(10, 2) DEFAULT 0;
    SELECT CreditLine INTO v_credit FROM Customer WHERE CustomerNum = p_customer;
    SET p_rank = CASE
                     WHEN v_credit >= 8000 THEN 'VIP'
                     WHEN v_credit >= 6000 THEN 'GOLD'
                     ELSE 'NORMAL'
        END;
END$$
DELIMITER ;
-- Check 15
CALL sp_customer_credit_category(282, @RANK);
SELECT @RANK;

-- Task 16
DROP FUNCTION IF EXISTS fn_price_category;
DELIMITER $$
CREATE FUNCTION fn_price_category(price DECIMAL(10, 2))
    RETURNS VARCHAR(10)
    DETERMINISTIC
BEGIN
    RETURN CASE
               WHEN price < 50 THEN 'LOW'
               WHEN price < 200 THEN 'MEDIUM'
               ELSE 'HIGH'
        END;
END$$
DELIMITER ;
-- Check 16
SELECT fn_price_category(200.01);

-- Task 17
DROP PROCEDURE IF EXISTS sp_order_priority;
DELIMITER $$
CREATE PROCEDURE sp_order_priority(IN p_order INT, OUT p_priority VARCHAR(20))
BEGIN
    DECLARE v_total DECIMAL(10, 2) DEFAULT 0;
    SELECT SUM(NumOrdered * QuotedPrice)
    INTO v_total
    FROM OrderLine
    WHERE OrderNum = p_order;
    SET p_priority = CASE
                         WHEN v_total < 100 THEN 'LOW'
                         WHEN v_total < 1000 THEN 'MEDIUM'
                         ELSE 'HIGH'
        END;
END$$
DELIMITER ;
-- Check 17
CALL sp_order_priority(21613, @PRIORITY);
SELECT @PRIORITY;

-- Task 18
DROP PROCEDURE IF EXISTS sp_count_customer_orders;
DELIMITER $$
CREATE PROCEDURE sp_count_customer_orders(IN p_customer INT)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_total INT DEFAULT 0;
    SELECT COUNT(*) INTO v_total FROM Orders WHERE CustomerNum = p_customer;
    count_loop:
    LOOP
        IF v_count >= v_total THEN
            LEAVE count_loop;
        END IF;
        SET v_count = v_count + 1;
    END LOOP count_loop;
    SELECT v_count AS totalOrders;
END$$
DELIMITER ;
-- Check 18
CALL sp_count_customer_orders(608);

-- Task 19
DROP PROCEDURE IF EXISTS sp_sum_order_quantity;
DELIMITER $$
CREATE PROCEDURE sp_sum_order_quantity(IN p_order INT)
BEGIN
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_max INT DEFAULT 0;
    DECLARE v_qty INT DEFAULT 0;
    SELECT COUNT(*) INTO v_max FROM OrderLine WHERE OrderNum = p_order;
    WHILE v_count < v_max
        DO
            SELECT NumOrdered
            INTO v_qty
            FROM OrderLine
            WHERE OrderNum = p_order
            LIMIT 1 OFFSET v_count;

            SET v_total = v_total + v_qty;
            SET v_count = v_count + 1;
        END WHILE;
    SELECT v_total AS TotalQuantity;
END$$
DELIMITER ;
-- Check 19
CALL sp_sum_order_quantity(21617);

-- Task 20
DROP FUNCTION IF EXISTS fn_customer_total_spent;
CREATE FUNCTION fn_customer_total_spent(p_customer INT)
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_max INT DEFAULT 0;
    DECLARE v_amount DECIMAL(10, 2);
    SELECT COUNT(*)
    INTO v_max
    FROM Orders
    WHERE CustomerNum = p_customer;
    REPEAT
        SELECT SUM(ol.NumOrdered * ol.QuotedPrice)
        INTO v_amount
        FROM OrderLine ol
                 INNER JOIN Orders o ON ol.OrderNum = o.OrderNum
        WHERE o.CustomerNum = p_customer
        LIMIT 1 OFFSET v_count;
        SET v_total = v_total + IFNULL(v_amount, 0);
        SET v_count = v_count + 1;
    UNTIL v_count >= v_max
        END REPEAT;
    RETURN v_total;
END;
-- Check 20

SELECT fn_customer_total_spent(608);
