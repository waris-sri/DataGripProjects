DROP DATABASE IF EXISTS Sun;
CREATE DATABASE Sun;
USE Sun;

CREATE TABLE Orders (
    OrderID             CHAR(7) PRIMARY KEY,
    OrderTime           TIME        NOT NULL,
    OrderDate           DATE        NOT NULL,
    OrderStatus         VARCHAR(20) NOT NULL,
    OrderCustID         CHAR(7)     NOT NULL,
    OrderCashierStaffID CHAR(3)     NOT NULL,
    OrderQuantity       INT         NOT NULL, -- Newly added and adapted from Sun's
    CONSTRAINT CHK_OrderStatus CHECK (OrderStatus IN ('COMPLETED', 'INCOMPLETE')),
    CONSTRAINT CHK_OrderQuantity CHECK (OrderQuantity >= 1 AND OrderQuantity <= 100)
);
/* ====================================== BAMM DDL SCOPE ENDS ====================================== */

/* ====================================== SUN DDL SCOPE STARTS ====================================== */
CREATE TABLE Products (
    ProductID     CHAR(7)       NOT NULL PRIMARY KEY,
    ProductAmount INT           NOT NULL,
    Price         DECIMAL(5, 2) NOT NULL,
    Calories      INT           NOT NULL,
    ProductName   VARCHAR(50)   NOT NULL,
    ExpiryDate    DATE          NOT NULL
);
/*
Binary M:N connectivity: Create a new relation, then inherit M’s & N’s PKs as relation’s individual FKs, which combines as PK
*/
CREATE TABLE OrderProduct (
    OP_ProductID     CHAR(7) NOT NULL,
    OP_OrderID       CHAR(7) NOT NULL,
    OP_OrderQuantity INT,
    CONSTRAINT PK_OrderProduct PRIMARY KEY (OP_ProductID, OP_OrderID)
);

INSERT INTO Products
VALUES ('4795980', 420, 29.99, 120, 'Yellow Submarine (22 oz)', '2025-12-01'),
       ('7989971', 990, 15.50, 75, 'Heritage Croissant', '2025-12-14'),
       ('4489972', 890, 40.75, 100, 'Bellinee’s Signature Coffee (16 oz)', '2025-12-05'),
       ('4434442', 750, 75.00, 225, 'Croissant Nutella', '2025-12-20'),
       ('9832742', 677, 99.99, 350, 'Yuzu Twist (16 oz)', '2025-12-03'),
       ('8672309', 439, 69.99, 255, 'Sesame Mochi Bun', '2025-12-03');

INSERT INTO Orders
VALUES ('7392641', '13:01:00', '2024-05-11', 'COMPLETED', '6788023', '101', 89),
       ('7396713', '14:30:00', '2024-05-12', 'COMPLETED', '6788130', '102', 50),
       ('5820582', '09:15:00', '2024-05-13', 'INCOMPLETE', '6788112', '103', 45),
       ('6767676', '18:05:00', '2024-05-14', 'COMPLETED', '6788200', '104', 50),
       ('4927471', '10:00:00', '2024-05-15', 'INCOMPLETE', '6788131', '105', 35);

INSERT INTO OrderProduct
VALUES ('4795980', '7392641', 9),
       ('7989971', '7396713', 2),
       ('4489972', '5820582', 4),
       ('4434442', '6767676', 3),
       ('9832742', '4927471', 1),
       ('4795980', '4082651', 1),
       ('7989971', '1245379', 2),
       ('4489972', '2018382', 4),
       ('4434442', '9876543', 2),
       ('9832742', '1357924', 1);


-- Query 1
-- Retrieve all details of products that have less than 100 calories and cost < 50.00. (Products)
SELECT *
FROM Products
WHERE Calories < 100
  AND Price < 50.00;

-- Query 2
-- Retrieve the Order ID, the year of the order date, and the order status displayed in uppercase letters. (Orders)
SELECT OrderID, YEAR(OrderDate) AS Order_Year, UPPER(OrderStatus) AS Status_Upper
FROM Orders;

-- Query 3
-- Compute the total quantity of items sold for each product ID
-- (only list products where the total amount sold is strictly > 3) →  Order_Product.
SELECT OP_ProductID, SUM(OP_OrderQuantity) AS Total_Quantity_Sold
FROM OrderProduct
GROUP BY OP_ProductID
HAVING SUM(OP_OrderQuantity) > 3;

-- Query 4
-- Retrieve the Order ID, the order date, the product's taste, and the quantity ordered for all orders that are
-- currently 'INCOMPLETE'. (Orders + Order_Product + Products)
SELECT o.OrderID, o.OrderDate, p.Calories, op.OP_OrderQuantity AS Quantity
FROM Orders AS o
         INNER JOIN OrderProduct AS op ON o.OrderID = op.OP_OrderID
         INNER JOIN Products AS p ON op.OP_ProductID = p.ProductID
WHERE o.OrderStatus = 'INCOMPLETE';

-- Query 5
-- List all full product details (ID, Price, Calories) along with any Order IDs, including products that have never been
-- ordered (NULL). (Products + Order_Product)
SELECT p.ProductID, p.Calories, p.Price, op.OP_ProductID
FROM Products AS p
         LEFT JOIN OrderProduct AS op ON p.ProductID = op.OP_ProductID;