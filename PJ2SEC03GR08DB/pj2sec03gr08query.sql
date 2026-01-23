USE PJ2SEC03GR08DB;

/* =================================================== BEAM QUERIES =================================================== */

/*
Query 1:
Retrieve all full names of the staff members who work in branches established before 2018 and earn a salary greater than
16,000 Baht. (Staff + Branch)
*/

SELECT CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffFullName,
       YEAR(b.DateEstablished)                    AS BranchEstablished,
       s.Salary                                   AS StaffSalary,
       s.StaffBranchID
FROM Staff s
         INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
WHERE YEAR(b.DateEstablished) < 2018
  AND s.Salary >= 16000
ORDER BY BranchEstablished;

/*
Query 2:
Retrieve all cashiers along with their branch location and supervisor's name.
(Cashier + Staff + Branch)
*/

SELECT DISTINCT CONCAT(StaffFirstName, ' ', StaffLastName) AS FullName,
                BranchLocation,
                SupervisorName
FROM Cashier c
         INNER JOIN Staff s ON s.StaffID = c.CashierStaffID
         INNER JOIN Branch b ON s.StaffBranchID = b.BranchID;

/*
Query 3:
Compute the average salaries of all cashiers and each role of promoter per branch with values of at least 16,500.00 baht,
displayed in descending order. (Staff + Branch + Promoter + Cashier)
*/

SELECT BranchLocation, `Role`, AVG(Salary) AS AvgSalary
FROM Staff s
         INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
         INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID
GROUP BY BranchLocation, `Role`
HAVING AvgSalary >= 16500
UNION ALL
SELECT BranchLocation, PromoterRole AS `Role`, AVG(Salary) AS AvgSalary
FROM Staff s
         INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
         INNER JOIN Promoter p ON s.StaffID = p.PromoterStaffID
GROUP BY BranchLocation, PromoterRole
HAVING AvgSalary >= 16500
ORDER BY AvgSalary DESC;

/*
Query 4:
List all full names of cashiers along with their service skills and cashier numbers.
(Staff + Cashier)
*/

SELECT CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffFullName, CashierServiceSkill, CashierNumber
FROM Staff s
         INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID;

/*
Query 5:
Show all emails of promoters, their roles, and the branch location they work in. (Promoter + Staff + Branch)
*/
SELECT BranchLocation, Email, PromoterRole
FROM Branch b
         LEFT OUTER JOIN Staff s ON b.BranchID = s.StaffBranchID
         RIGHT OUTER JOIN Promoter p ON s.StaffID = p.PromoterStaffID
ORDER BY b.BranchLocation, Email;

/* =================================================== BAMM QUERIES =================================================== */

/*
Show the customer orders that are in a completed status. (Customer + Order)
*/
SELECT c.CustID,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       o.OrderID,
       o.OrderStatus
FROM Customer c
         INNER JOIN Orders o ON c.CustID = o.OrderCustID
WHERE o.OrderStatus = 'COMPLETED'
ORDER BY c.CustID;

/*
Checking the order that staff who have a salary higher than average are in charge of, and the order status is still
incomplete, also ordered by date of order. (Order + Cashier + Staff)
*/
SELECT StaffID,
       CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName,
       Salary,
       OrderID,
       OrderStatus,
       OrderDate
FROM Staff s
         INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID
         INNER JOIN Orders o ON c.CashierStaffID = o.OrderCashierStaffID
WHERE s.Salary > (
                     SELECT AVG(Salary)
                     FROM Staff
                     )
  AND o.OrderStatus = 'INCOMPLETE'
ORDER BY o.OrderDate;

/*
Find the youngest customer in each gender. (Cashier)
*/
SELECT Gender,
       CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName,
       DateOfBirth,
       ( YEAR(CURDATE()) - YEAR(DateOfBirth) )  AS Age
FROM Customer c
GROUP BY Gender, CustFirstName, CustLastName, DateOfBirth
HAVING DateOfBirth = (
                         SELECT MAX(DateOfBirth)
                         FROM Customer c1
                         WHERE c1.Gender = c.Gender
                         );

/*
Display the promotion that was created by the staff who is in charge of designing the promotion.
(Promotion + PromotionPromoter + Promoter + Staff)
*/
SELECT StaffID, CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName, PromotionID, PromotionName, PromoterRole
FROM Staff s
         INNER JOIN Promoter pr ON s.StaffID = pr.PromoterStaffID
         INNER JOIN PromotionPromoter pp ON s.StaffID = pp.PP_PromoterStaffID
         INNER JOIN Promotion p ON pp.PP_PromotionID = p.PromotionID
WHERE PromoterRole = 'Designer'
ORDER BY StaffID;

/*
Show all of the customer and product names that they have ordered before December 2025.
(Customer + Order+OrderProduct+Product)
*/
SELECT c.CustID,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       o.OrderID,
       o.OrderDate,
       OP_ProductID,
       ProductName
FROM Customer c
         LEFT OUTER JOIN Orders o ON c.CustID = o.OrderCustID
         LEFT OUTER JOIN OrderProduct op ON o.OrderID = op.OP_OrderID
         LEFT OUTER JOIN Products p ON op.OP_ProductID = p.ProductID
WHERE o.OrderDate < '2025-12-01'
ORDER BY CustID;


/* =================================================== SUN QUERIES =================================================== */

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
-- Compute the total quantity of items sold for each product ID, only list products where the total amount sold is
-- strictly > 3) (OrderProduct + Orders)
SELECT op.OP_ProductID, SUM(OrderQuantity) AS Total_Quantity_Sold
FROM OrderProduct op
         INNER JOIN Orders o ON o.OrderID = op.OP_OrderID
         INNER JOIN Products p ON p.ProductID = op.OP_ProductID
WHERE OP_ProductID = ProductID
  AND OP_OrderID = OrderID
GROUP BY OP_ProductID
HAVING Total_Quantity_Sold > 3;

-- Query 4
-- Retrieve the Order ID, the order date, the product's taste, and the quantity ordered for all orders that are
-- currently 'INCOMPLETE'. (Orders + Order_Product + Products)
SELECT o.OrderID, o.OrderDate, p.Calories, o.OrderQuantity AS Quantity, o.OrderStatus
FROM Orders AS o
         INNER JOIN OrderProduct AS op ON o.OrderID = op.OP_OrderID
         INNER JOIN Products AS p ON op.OP_ProductID = p.ProductID
WHERE o.OrderStatus = 'INCOMPLETE';

-- Query 5
-- List all full product details (ID, Price, Calories) along with any Order IDs. (Products + Order_Product)
SELECT p.ProductID, p.Calories, p.Price, op.OP_ProductID
FROM Products AS p
         LEFT JOIN OrderProduct AS op ON p.ProductID = op.OP_ProductID;

/* =================================================== M QUERIES =================================================== */

/*
Retrieve all promotions that are currently “ACTIVE” and give a discount of more than 20%, and only show promotions that
start in the year 2025. (Promotion)
*/
SELECT PromotionID,
       PromotionName,
       PromotionStartDate,
       PromotionEndDate,
       EligibilityCriteria
FROM Promotion
WHERE PromotionStartDate BETWEEN '2025-01-01' AND '2025-12-31'
  AND PromotionName LIKE '%20%';

/*
Show each staff member who works as a promoter, with their full name and the number of years they have worked since
their working date. (Staff)
*/
SELECT StaffID,
       CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName,
       WorkingDate,
       YEAR(CURDATE()) - YEAR(WorkingDate)        AS Yearsworked
FROM Staff
WHERE `Role` = 'Promoter'
ORDER BY Yearsworked DESC;

/*
Compute the total item sales per day in 2025, only listing days where the sales are more than 20 items. (Bill + Orders)
*/
SELECT b.BillDate, SUM(o.OrderQuantity) AS TotalQuantity
FROM Bill AS b
         INNER JOIN Orders AS o
                    ON b.BillOrderID = o.OrderID
WHERE b.BillDate BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY b.BillDate
HAVING TotalQuantity > 20;

/*
List all promoter staff together with their staff information, including full name, email, and phone number.
(Staff + Promoter)
*/
SELECT p.PromoterStaffID,
       CONCAT(s.StaffFirstName, ' ', s.StaffLastName) AS StaffFullName,
       s.Email,
       s.PhoneNum,
       p.PromoterRole
FROM Promoter AS p
         INNER JOIN Staff s
                    ON p.PromoterStaffID = s.StaffID;

/*
List all customers together with any orders and bills they have, and clearly show customers who have no orders or
whose orders do not yet have a bill. (Customer + Orders + Bill)
*/
SELECT c.CustID,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       o.OrderID,
       o.OrderDate,
       o.OrderStatus,
       b.BillID,
       b.BillDate,
       b.BillTime
FROM Customer AS c
         LEFT OUTER JOIN Orders o
                         ON c.CustID = o.OrderCustID
         LEFT OUTER JOIN Bill b
                         ON o.OrderID = b.BillOrderID
ORDER BY c.CustID, o.OrderDate, b.BillDate;



