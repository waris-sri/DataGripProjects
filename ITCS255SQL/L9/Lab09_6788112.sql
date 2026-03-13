-- drop database PremierProducts;
USE PremierProducts;

DROP VIEW if exists view_customer_basic;
DROP VIEW if exists view_part_price;
DROP VIEW if exists view_order_basic;
DROP VIEW if exists view_rep_contact;
DROP VIEW if exists view_order_customer;
drop view if exists view_order_detail;
drop view if exists view_customer_rep;
drop view if exists view_order_total;
drop view if exists view_customer_total_orders;
drop view if exists view_customer_purchase;
drop view if exists view_top_customer_sales;

CREATE VIEW view_customer_basic AS
    SELECT 
        CUSTOMERNUM, CUSTOMERNAME, CITY, STATE
    FROM
        Customer;
-- Check 1
SELECT 
    *
FROM
    view_customer_basic;

-- Task 2
CREATE VIEW view_part_price AS
    SELECT 
        PartNum, Description, Price
    FROM
        Part;
-- Check 2
SELECT 
    *
FROM
    view_part_price;

-- Task 3
CREATE VIEW view_order_basic AS
    SELECT 
        ORDERNUM, ORDERDATE, CUSTOMERNUM
    FROM
        Orders;
-- Check 3
SELECT 
    *
FROM
    view_order_basic;

-- Task 4
CREATE VIEW view_rep_contact AS
    SELECT 
        RepNum, FirstName, LastName, City
    FROM
        Rep;
-- Check 4
SELECT 
    *
FROM
    view_rep_contact;

-- Task 5
SHOW CREATE VIEW view_customer_basic;

-- Task 6
DROP VIEW view_part_price;
-- Check 6
SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';

-- Task 7
CREATE INDEX idx_customer_name ON Customer (CUSTOMERNAME);
-- Check 7
SHOW INDEXES FROM Customer;

-- Task 8
CREATE INDEX idx_order_date ON Orders (ORDERDATE);
-- Check 8
SHOW INDEXES FROM Orders;

-- Task 9
CREATE INDEX idx_orderline_part ON OrderLine (PARTNUM);
-- Check 9

-- Task 10
SHOW INDEXES FROM Part;

-- Task 11
CREATE VIEW view_order_customer AS
    SELECT 
        ORDERNUM, ORDERDATE, CUSTOMERNAME
    FROM
        Customer
            INNER JOIN
        Orders USING (CUSTOMERNUM);
-- Check 11
SELECT 
    *
FROM
    view_order_customer;

-- Task 12
CREATE VIEW view_order_detail AS
    SELECT 
        ORDERNUM, PARTNUM, Description, NUMORDERED
    FROM
        OrderLine
            INNER JOIN
        Part USING (PartNum);
-- Check 12
SELECT 
    *
FROM
    view_order_detail;

-- Task 13
CREATE VIEW view_customer_rep AS
    SELECT 
        CUSTOMERNAME,
        FirstName AS RepFirstName,
        LastName AS RepLastName
    FROM
        Customer
            INNER JOIN
        Rep USING (RepNum);
-- Check 13
SELECT 
    *
FROM
    view_customer_rep;

-- Task 14
CREATE VIEW view_order_total AS
    SELECT 
        ORDERNUM, SUM(NUMORDERED * QUOTEDPRICE) AS TotalAmount
    FROM
        OrderLine
    GROUP BY ORDERNUM;
-- Check 14
SELECT 
    *
FROM
    view_order_total;

-- Task 15
CREATE VIEW view_customer_total_orders AS
    SELECT 
        c.CUSTOMERNAME, COUNT(o.ORDERNUM) AS TotalOrders
    FROM
        Customer c
            INNER JOIN
        Orders o ON c.CUSTOMERNUM = o.CUSTOMERNUM
    GROUP BY c.CUSTOMERNAME;
-- Check 15
SELECT 
    *
FROM
    view_customer_total_orders;

-- Task 16
CREATE VIEW view_customer_purchase AS
    SELECT 
        CUSTOMERNAME, ORDERNUM, PARTNUM, NUMORDERED, QUOTEDPRICE
    FROM
        Customer
            INNER JOIN
        Orders USING (CUSTOMERNUM)
            INNER JOIN
        OrderLine USING (ORDERNUM);
-- Check 16
SELECT 
    *
FROM
    view_customer_purchase;

-- Task 17
CREATE VIEW view_top_customer_sales AS
    SELECT 
        c.CUSTOMERNAME,
        SUM(ol.NUMORDERED * ol.QUOTEDPRICE) AS TotalSales
    FROM
        Customer c
            INNER JOIN
        Orders o ON c.CUSTOMERNUM = o.CUSTOMERNUM
            INNER JOIN
        OrderLine ol ON o.ORDERNUM = ol.ORDERNUM
    GROUP BY c.CUSTOMERNAME
    ORDER BY TotalSales DESC;
-- Check 17
SELECT 
    *
FROM
    view_top_customer_sales;

-- Task 18
CREATE INDEX idx_orders_customer_date
    ON Orders (CUSTOMERNUM, ORDERDATE);