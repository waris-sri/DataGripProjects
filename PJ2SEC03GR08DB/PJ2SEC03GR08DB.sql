DROP DATABASE IF EXISTS PJ2SEC03GR08DB;
CREATE DATABASE IF NOT EXISTS PJ2SEC03GR08DB;
USE PJ2SEC03GR08DB;

-- Beam
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Cashier;
DROP TABLE IF EXISTS Promoter;
-- Bamm
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customer;

/* ====================================== BEAM DDL SCOPE STARTS ====================================== */
CREATE TABLE Branch (
    BranchID        CHAR(4) PRIMARY KEY UNIQUE,
    BranchLocation  VARCHAR(100) NOT NULL,
    DateEstablished DATE         NOT NULL,
    SupervisorName  VARCHAR(41)  NOT NULL
);

CREATE TABLE Staff (
    StaffID        CHAR(3)       NOT NULL UNIQUE PRIMARY KEY,
    Salary         DECIMAL(7, 2) NOT NULL,
    `Role`         VARCHAR(20)   NOT NULL,
    PhoneNum       CHAR(12)      NOT NULL,
    Email          VARCHAR(38)   NOT NULL,
    Address        VARCHAR(100)  NOT NULL,
    WorkingDate    DATE          NOT NULL,
    StaffFirstName VARCHAR(20)   NOT NULL,
    StaffLastName  VARCHAR(20)   NOT NULL,
    StaffBranchID  CHAR(4)       NOT NULL,
    CONSTRAINT FK_StaffBranchID FOREIGN KEY (StaffBranchID) REFERENCES Branch (BranchID),
    CONSTRAINT CHK_Role CHECK (`Role` IN ('Cashier', 'Promoter'))
);

CREATE TABLE Cashier (
    CashierStaffID      CHAR(3) NOT NULL PRIMARY KEY,
    CashierServiceSkill VARCHAR(20),
    CashierNumber       CHAR(1) NOT NULL,
    CONSTRAINT FK_CashierStaffID FOREIGN KEY (CashierStaffID) REFERENCES Staff (StaffID)
);

CREATE TABLE Promoter (
    PromoterStaffID CHAR(3)     NOT NULL PRIMARY KEY,
    PromoterRole    VARCHAR(11) NOT NULL,
    CONSTRAINT FK_PromoterStaffID FOREIGN KEY (PromoterStaffID) REFERENCES Staff (StaffID),
    CONSTRAINT CHK_PromoterRole CHECK (PromoterRole IN ('Designer', 'Coordinator', 'Maintainer'))
);
/* ====================================== BEAM DDL SCOPE ENDS ====================================== */

/* ====================================== BAMM DDL SCOPE STARTS ====================================== */
CREATE TABLE Customer (
    CustomerID    CHAR(7) PRIMARY KEY,
    CustFirstName VARCHAR(20) NOT NULL,
    CustLastName  VARCHAR(20) NOT NULL,
    DateOfBirth   DATE        NOT NULL,
    Gender        VARCHAR(10) NOT NULL
);

CREATE TABLE Orders (
    OrderID             CHAR(7) PRIMARY KEY,
    OrderTime           TIME        NOT NULL,
    OrderDate           DATE        NOT NULL,
    OrderStatus         VARCHAR(20) NOT NULL,
    OrderCustID         CHAR(7)     NOT NULL,
    OrderCashierStaffID CHAR(3)     NOT NULL,
    CONSTRAINT FK_OrderCustID FOREIGN KEY (OrderCustID) REFERENCES Customer (CustomerID),
    CONSTRAINT FK_OrderCashierStaffID FOREIGN KEY (OrderCashierStaffID) REFERENCES Cashier (CashierStaffID),
    CONSTRAINT CHK_OrderStatus CHECK (OrderStatus IN ('COMPLETED', 'INCOMPLETE'))
);
/* ====================================== BAMM DDL SCOPE ENDS ====================================== */

INSERT INTO Customer
VALUES ('6788023', 'Nussavas', 'Horchatnukul', '2005-06-08', 'M'),
       ('6788112', 'Waris', 'Sripathum', '2005-10-22', 'F'),
       ('6788130', 'Koony', 'Pongrawee', '2016-01-05', 'M'),
       ('6788291', 'Wachira', 'Chatmonkol', '2005-01-01', 'F'),
       ('6788921', 'Punrapop', 'Prach', '2005-12-31', 'F'),
       ('6788371', 'Poppumm', 'Pummpob', '2010-03-22', 'M'),
       ('6788026', 'Rachine', 'Wach', '2020-12-31', 'F'),
       ('6788145', 'Rawit', 'Ralia', '2014-12-31', 'M'),
       ('6788131', 'Pakpaphon', 'Sueqae', '2000-05-21', 'F'),
       ('6788200', 'Wuthwara', 'Leungam', '2005-09-30', 'M');

INSERT INTO Orders
VALUES ('7392641', '16:45:03', '2025-12-08', 'INCOMPLETE', '6788023', '101'),
       ('7396713', '20:32:55', '2025-03-17', 'COMPLETED', '6788130', '102'),
       ('5820582', '17:56:49', '2024-04-21', 'COMPLETED', '6788112', '103'),
       ('6767676', '13:28:52', '2025-11-20', 'INCOMPLETE', '6788200', '104'),
       ('4927471', '12:40:54', '2025-06-07', 'COMPLETED', '6788131', '105'),
       ('4082651', '19:40:12', '2024-08-09', 'COMPLETED', '6788023', '106'),
       ('1245379', '15:25:35', '2025-09-11', 'COMPLETED', '6788112', '107'),
       ('2018382', '16:39:29', '2024-08-30', 'COMPLETED', '6788130', '108'),
       ('9876543', '12:43:03', '2023-01-19', 'COMPLETED', '6788023', '109'),
       ('1357924', '10:23:00', '2025-12-02', 'COMPLETED', '6788200', '110'),
       ('7400101', '11:23:45', '2025-03-10', 'COMPLETED', '6788023', '101'),
       ('7400102', '15:40:22', '2024-11-18', 'INCOMPLETE', '6788112', '102'),
       ('7400103', '09:12:54', '2025-07-02', 'COMPLETED', '6788130', '103'),
       ('7400104', '18:55:13', '2024-09-21', 'COMPLETED', '6788291', '104'),
       ('7400105', '14:01:08', '2025-04-14', 'INCOMPLETE', '6788921', '105'),
       ('7400106', '07:25:34', '2024-06-10', 'COMPLETED', '6788371', '106'),
       ('7400107', '16:19:45', '2023-12-19', 'COMPLETED', '6788026', '107'),
       ('7400108', '10:10:10', '2025-10-12', 'COMPLETED', '6788145', '108'),
       ('7400109', '20:45:59', '2024-03:28', 'INCOMPLETE', '6788131', '109'),
       ('7400110', '12:33:18', '2025-11-03', 'COMPLETED', '6788200', '110'),
       ('7400111', '13:22:44', '2024-05-12', 'COMPLETED', '6788023', '101'),
       ('7400112', '17:58:01', '2025-01-30', 'COMPLETED', '6788112', '102'),
       ('7400113', '19:49:33', '2025-08-18', 'INCOMPLETE', '6788130', '103'),
       ('7400114', '08:20:47', '2024-10-06', 'COMPLETED', '6788291', '104'),
       ('7400115', '22:11:39', '2025-09-09', 'COMPLETED', '6788921', '105'),
       ('7400116', '06:59:11', '2024-07-25', 'COMPLETED', '6788371', '106'),
       ('7400117', '21:30:07', '2023-11-09', 'INCOMPLETE', '6788026', '107'),
       ('7400118', '15:13:21', '2025-06-16', 'COMPLETED', '6788145', '108'),
       ('7400119', '09:44:55', '2024-04-04', 'COMPLETED', '6788131', '109'),
       ('7400120', '18:18:18', '2025-12-05', 'INCOMPLETE', '6788200', '110');

INSERT INTO Branch
VALUES ('0001', 'Bangkok Central', '2015-03-01', 'Somchai Chaiyaporn'),
       ('0002', 'Chiang Mai', '2017-07-15', 'Nattawut Phongsa'),
       ('0003', 'Phuket', '2016-11-20', 'Supaporn Rattanakorn'),
       ('0004', 'Khon Kaen', '2018-01-05', 'Anuwat Srisuk'),
       ('0005', 'Hat Yai', '2019-06-10', 'Kanya Charoen');

INSERT INTO Staff
VALUES ('101', 15000.00, 'Cashier', '081-234-5678', 'waris.sri@bellinees.com', '123 Sukhumvit Rd, Bangkok',
        '2020-01-10',
        'Waris', 'Sripatoomrak', '0001'),
       ('102', 18000.00, 'Cashier', '089-876-5432', 'nussavas.hor@bellinees.com', '45/33 Chang Klan Rd, Chiang Mai',
        '2021-03-20', 'Nussavas', 'Horchatnukul', '0002'),
       ('103', 16000.00, 'Cashier', '082-345-6789', 'warawuth.nga@bellinees.com', '78/67 Patong Beach, Phuket',
        '2019-05-15', 'Warawuth', 'Ngamluea', '0003'),
       ('104', 17000.00, 'Cashier', '086-543-2198', 'pongrawee.the@bellinees.com', '56/420 Mittraphap Rd, Khon Kaen',
        '2022-07-01', 'Pongrawee', 'Thepchai', '0004'),
       ('105', 15500.00, 'Cashier', '080-123-4567', 'wachiravich.tha@bellinees.com', '33 Khon Kaen Rd, Khon Kaen',
        '2020-11-30', 'Wachiravich', 'Thaosiri', '0005'),
       ('106', 18000.00, 'Cashier', '097-531-1371', 'watcharagul.sun@bellinees.com', '90 Hat Yai Rd, Hat Yai',
        '2023-08-21', 'Watcharagul', 'Sungkamanon', '0001'),
       ('107', 16000.00, 'Cashier', '061-006-6377', 'somchit.bun@bellinees.com', '12 Songkhla Rd, Hat Yai',
        '2019-05-05',
        'Somchit', 'Bunnag', '0002'),
       ('108', 17000.00, 'Cashier', '014-242-4593', 'kaew.wat@bellinees.com', '90 Hat Yai Rd, Hat Yai', '2021-07-09',
        'Kaew', 'Wattana', '0003'),
       ('109', 17000.00, 'Cashier', '089-672-6631', 'somjit.bun@bellinees.com', '24 Srinakarint Road, Nongbon',
        '2019-07-11', 'Somjit', 'Bunnag', '0004'),
       ('110', 15500.00, 'Cashier', '084-233-5567', 'amphon.met@bellinees.com',
        '757/8 Rachadaphisek 18 Sam Saen Nork Huai Khwang', '2025-11-12', 'Amphon', 'Metharom', '0005'),
       ('111', 16500.00, 'Promoter', '081-112-3344', 'nattapong.kim@bellinees.com', '45/3 Nimman Rd, Chiang Mai',
        '2020-02-15', 'Nattapong', 'Kimsri', '0001'),
       ('112', 17200.00, 'Promoter', '082-223-4455', 'araya.sai@bellinees.com', '78/5 Patong Beach, Phuket',
        '2021-06-20',
        'Araya', 'Saithong', '0002'),
       ('113', 15800.00, 'Promoter', '083-334-5566', 'phong.the@bellinees.com', '56/2 Mittraphap Rd, Khon Kaen',
        '2019-11-05', 'Phong', 'Thepchai', '0003'),
       ('114', 17500.00, 'Promoter', '084-445-6677', 'suda.kha@bellinees.com', '90/12 Hat Yai Rd, Hat Yai',
        '2022-03-10',
        'Suda', 'Khanthong', '0004'),
       ('115', 16000.00, 'Promoter', '085-556-7788', 'chatchai.bun@bellinees.com', '33/7 Sukhumvit Rd, Bangkok',
        '2020-09-01', 'Chatchai', 'Bunnag', '0005'),
       ('116', 16800.00, 'Promoter', '086-667-8899', 'thanya.wei@bellinees.com', '22/4 Chang Klan Rd, Chiang Mai',
        '2021-12-15', 'Thanya', 'Weerasak', '0001'),
       ('117', 16250.00, 'Promoter', '087-778-9900', 'somchai.kra@bellinees.com', '15/9 Patong Beach, Phuket',
        '2019-08-20', 'Somchai', 'Krairuk', '0002'),
       ('118', 17050.00, 'Promoter', '088-889-0011', 'ladda.sri@bellinees.com', '48/2 Mittraphap Rd, Khon Kaen',
        '2022-01-05', 'Ladda', 'Srisuk', '0003'),
       ('119', 15900.00, 'Promoter', '089-990-1122', 'phairoj.kit@bellinees.com', '67/8 Hat Yai Rd, Hat Yai',
        '2020-04-22', 'Phairoj', 'Kitiporn', '0004'),
       ('120', 17400.00, 'Promoter', '080-101-2233', 'jintana.som@bellinees.com', '12/6 Sukhumvit Rd, Bangkok',
        '2021-10-17', 'Jintana', 'Somdee', '0005');

-- increased the number of staff members to 20 to match the "master table must have >=10 records" requirement
-- staff ID 101 to 110 = cashiers
-- staff ID 111 to 120 = promoters
INSERT INTO Cashier
VALUES ('101', 'VIP Service', '1'),
       ('102', 'POS System', '2'),
       ('103', 'Cash Handling', '1'),
       ('104', 'Customer Service', '2'),
       ('105', 'Trilingual', '1'),
       ('106', 'Sales', '2'),
       ('107', 'Computer Literacy', '1'),
       ('108', 'Problem Solving', '2'),
       ('109', 'Communication', '1'),
       ('110', 'Product Knowledge', '2');

INSERT INTO Promoter
VALUES ('111', 'Designer'),
       ('112', 'Coordinator'),
       ('113', 'Maintainer'),
       ('114', 'Designer'),
       ('115', 'Maintainer'),
       ('116', 'Designer'),
       ('117', 'Coordinator'),
       ('118', 'Maintainer'),
       ('119', 'Designer'),
       ('120', 'Maintainer');


SELECT *
FROM Branch;
SELECT *
FROM Staff;
SELECT *
FROM Promoter;
SELECT *
FROM Cashier;

/* =================================================== BEAM QUERIES =================================================== */

# /*
# Query 1:
# Retrieve all full names of the staff members who work in branches established before 2018 and earn a salary greater than
# 16,000 Baht. (Staff + Branch)
# */
#
# SELECT CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffFullName,
#        YEAR(b.DateEstablished)                    AS BranchEstablished,
#        s.Salary                                   AS StaffSalary,
#        s.StaffBranchID
# FROM Staff s
#          INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
# WHERE YEAR(b.DateEstablished) < 2018
#   AND s.Salary >= 16000
# ORDER BY BranchEstablished;
#
# /*
# Query 2:
# Retrieve all cashiers along with their branch location and supervisor's name.
# (Cashier + Staff + Branch)
# */
#
# SELECT DISTINCT CONCAT(StaffFirstName, ' ', StaffLastName) AS FullName,
#                 BranchLocation,
#                 SupervisorName
# FROM Cashier c
#          INNER JOIN Staff s ON s.StaffID = c.CashierStaffID
#          INNER JOIN Branch b ON s.StaffBranchID = b.BranchID;
#
# /*
# Query 3:
# Compute the average salaries of all cashiers and each role of promoter per branch with values of at least 16,500.00 baht,
# displayed in descending order. (Staff + Branch + Promoter + Cashier)
# */
#
# SELECT BranchLocation, `Role`, AVG(Salary) AS AvgSalary
# FROM Staff s
#          INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
#          INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID
# GROUP BY BranchLocation, `Role`
# HAVING AvgSalary >= 16500
# UNION ALL
# SELECT BranchLocation, PromoterRole AS `Role`, AVG(Salary) AS AvgSalary
# FROM Staff s
#          INNER JOIN Branch b ON s.StaffBranchID = b.BranchID
#          INNER JOIN Promoter p ON s.StaffID = p.PromoterStaffID
# GROUP BY BranchLocation, PromoterRole
# HAVING AvgSalary >= 16500
# ORDER BY AvgSalary DESC;
#
# /*
# Query 4:
# List all full names of cashiers along with their service skills and cashier numbers.
# (Staff + Cashier)
# */
#
# SELECT CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffFullName, CashierServiceSkill, CashierNumber
# FROM Staff s
#          INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID;
#
# /*
# Query 5:
# Show all emails of promoters, their roles, and the branch location they work in. (Promoter + Staff + Branch)
# */
# SELECT *
# FROM Branch;
# SELECT *
# FROM Staff;
# SELECT *
# FROM Promoter;
# SELECT BranchLocation, Email, PromoterRole
# FROM Branch b
#          LEFT OUTER JOIN Staff s ON b.BranchID = s.StaffBranchID
#          RIGHT OUTER JOIN Promoter p ON s.StaffID = p.PromoterStaffID
# ORDER BY b.BranchLocation, Email;

/* =================================================== BAMM QUERIES =================================================== */

/*
Show the customer orders that are in a completed status. (Customer + Order)
*/
SELECT c.CustomerID,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       o.OrderID,
       o.OrderStatus
FROM Customer c
         INNER JOIN Orders o ON c.CustomerID = o.CUSTID
WHERE o.OrderStatus = 'COMPLETED'
ORDER BY c.CustomerID;

/*
Show customers who are male and born before 2010, ordered by the CustomerID. (Customer)
*/
SELECT CustomerID,
       CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName,
       DateOfBirth
FROM Customer
WHERE Gender = 'M'
  AND YEAR(DateOfBirth) < 2010
ORDER BY CustomerID;

/*
Checking the order that staff who have a salary higher than average are in charge of, and the order status is still
incomplete, also ordered by date of order. (Order + Cashier + Staff)
*/
SELECT StaffID, CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName, Salary, OrderID, OrderStatus, OrderDate
FROM Staff s
         INNER JOIN Cashier c ON s.StaffID = c.CashierStaffID
         INNER JOIN Orders o ON c.CashierStaffID = o.OrderCashierStaffID
WHERE s.Salary > AVG(Salary)
  AND o.OrderStatus = 'COMPLETED'
ORDER BY o.OrderDate;

/*
Display the promotion that was created by the staff who is in charge of designing the promotion.
(Promotion + PromotionPromoter + Promoter + Staff)
*/
SELECT StaffID, CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName, PROMOTIONID, PROMOTIONNAME, PROMOTIONROLE
FROM Staff s
         INNER JOIN PROMOTIONPROMOTER pp ON s.StaffID = pp.PP_PromoterStfID
         INNER JOIN PROMOTION p ON pp.PP_PromotionID = p.PromotionID
WHERE PROMOTIONROLE = 'Designer'
ORDER BY StaffID;

/*Show all of the customer and product names that they have ordered before Dec 2025 (Customer + Order+OrderProduct+Product)*/
SELECT CustomerID, CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName, ORDERID, ORDERDATE, PRODUCTID, PRODUCTNAME
FROM Customer c
         LEFT OUTER JOIN ORDERS.O ON c.CustomerID = O.ORDERCUSTID
         RIGHT OUTER JOIN ORDERPRODUCT op ON O.ORDERID = op.OP_OrderID
         LEFT OUTER JOIN PRODUCT p ON op.OP_ProductID = p.ProductID
WHERE O.ORDERDATE < '2025-12-1'
ORDER BY CustomerID;

