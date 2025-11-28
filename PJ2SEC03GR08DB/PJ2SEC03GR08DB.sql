DROP DATABASE IF EXISTS PJ2SEC03GR08DB;
CREATE DATABASE IF NOT EXISTS PJ2SEC03GR08DB;
USE PJ2SEC03GR08DB;

/*
TRANSACTIONAL (the rest are MASTER tables:
Orders
OrderProduct
Bill
PromotionPromoter*/

DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Cashier;
DROP TABLE IF EXISTS Promoter;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Bill;
DROP TABLE IF EXISTS Promotion;
DROP TABLE IF EXISTS PromotionPromoter;
DROP TABLE IF EXISTS OrderProduct;


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
    CustID        CHAR(7) PRIMARY KEY,
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
    OrderQuantity       INT         NOT NULL, -- Newly added and adapted from Sun's
    CONSTRAINT FK_OrderCustID FOREIGN KEY (OrderCustID) REFERENCES Customer (CustID),
    CONSTRAINT FK_OrderCashierStaffID FOREIGN KEY (OrderCashierStaffID) REFERENCES Cashier (CashierStaffID),
    CONSTRAINT CHK_OrderStatus CHECK (OrderStatus IN ('COMPLETED', 'INCOMPLETE')),
    CONSTRAINT CHK_OrderQuantity CHECK (OrderQuantity >= 1 AND OrderQuantity <= 100)
);
/* ====================================== BAMM DDL SCOPE ENDS ====================================== */

/* ====================================== SUN DDL SCOPE STARTS ====================================== */
CREATE TABLE Products (
    ProductID     CHAR(7)       NOT NULL PRIMARY KEY,
    ProductAmount INT           NOT NULL,
    Calories      INT           NOT NULL,
    Price         DECIMAL(5, 2) NOT NULL,
    ProductName   VARCHAR(50)   NOT NULL,
    ExpiryDate    DATE          NOT NULL
);
/*
Binary M:N connectivity: Create a new relation, then inherit M’s & N’s PKs as relation’s individual FKs, which combines as PK
*/
CREATE TABLE OrderProduct (
    OP_OrderID   CHAR(7) NOT NULL,
    OP_ProductID CHAR(7) NOT NULL,
    CONSTRAINT PK_OrderProduct PRIMARY KEY (OP_ProductID, OP_OrderID),
    CONSTRAINT FK_OP_OrderID FOREIGN KEY (OP_OrderID) REFERENCES Orders (OrderID),
    CONSTRAINT FK_OP_ProductID FOREIGN KEY (OP_ProductID) REFERENCES Products (ProductID)
);
/* ====================================== SUN DDL SCOPE ENDS ====================================== */

/* ====================================== M DDL SCOPE STARTS ====================================== */
CREATE TABLE Bill (
    BillID            CHAR(7) PRIMARY KEY,
    BillDate          DATE     NOT NULL,
    BillTime          TIME     NOT NULL,
    BillTaxID         CHAR(13) NOT NULL,
    BillCreditCardNum CHAR(16),
    BillBranchID      CHAR(4)  NOT NULL,
    BillOrderID       CHAR(7)  NOT NULL,
    CONSTRAINT FK_BillOrderID FOREIGN KEY (BillOrderID) REFERENCES Orders (OrderID),
    CONSTRAINT FK_BillBranchID FOREIGN KEY (BillBranchID) REFERENCES Branch (BranchID)
);
/* ====================================== M DDL SCOPE ENDS ====================================== */

/* ====================================== NEWLY ADDED TABLES ====================================== */
CREATE TABLE Promotion (
    PromotionID         CHAR(7)      NOT NULL PRIMARY KEY,
    EligibilityCriteria VARCHAR(100) NOT NULL,
    PromotionName       VARCHAR(40)  NOT NULL,
    PromotionStartDate  DATE         NOT NULL,
    PromotionEndDate    DATE         NOT NULL
);
/*
Binary M:N connectivity: Create a new relation, then inherit M’s & N’s PKs as relation’s individual FKs, which combines as PK
*/
CREATE TABLE PromotionPromoter (
    PP_PromotionID     CHAR(7) NOT NULL,
    PP_PromoterStaffID CHAR(3) NOT NULL,
    CONSTRAINT PK_PromotionPromoter PRIMARY KEY (PP_PromotionID, PP_PromoterStaffID),
    CONSTRAINT FK_PP_PromotionID FOREIGN KEY (PP_PromotionID) REFERENCES Promotion (PromotionID),
    CONSTRAINT FK_PP_PromoterStaffID FOREIGN KEY (PP_PromoterStaffID) REFERENCES Promoter (PromoterStaffID)
);
/* ================================================================================================ */

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

INSERT INTO Promotion
VALUES ('PROM001', 'All customers who spend over 1,000 THB', 'Spend1KGet10%', '2025-06-01', '2025-06-30'),
       ('PROM002', 'New customers only', 'Welcome20%', '2025-07-01', '2025-07-31'),
       ('PROM003', 'All members of the loyalty program', 'Loyalty15%', '2025-08-01', '2025-08-15'),
       ('PROM004', 'Orders containing at least 2 croissants', 'DoubleCroissantFreeCoffee', '2025-08-10', '2025-08-31'),
       ('PROM005', 'Visit between 14:00–17:00 (Happy Hour)', 'AfternoonDelight', '2025-09-01', '2025-09-30'),
       ('PROM006', 'Buy 1 get 1 on all espresso drinks', 'EspressoBOGO', '2025-09-15', '2025-09-22'),
       ('PROM007', 'All purchases at Pinklao Branch', 'PinklaoExclusive5%', '2025-10-01', '2025-10-10'),
       ('PROM008', 'Orders of iced drinks only', 'CoolDown10%', '2025-10-11', '2025-10-31'),
       ('PROM009', 'Purchase any pastry and drink together', 'PastryCombo20%', '2025-11-01', '2025-11-15'),
       ('PROM010', 'Members who refer a friend', 'ReferAFriendFreeCroissant', '2025-11-16', '2025-11-30');

INSERT INTO PromotionPromoter
VALUES ('PROM001', '111'),
       ('PROM001', '112'),
       ('PROM001', '113'),
       ('PROM002', '114'),
       ('PROM002', '115'),
       ('PROM002', '116'),
       ('PROM003', '117'),
       ('PROM003', '118'),
       ('PROM003', '119'),
       ('PROM004', '120'),
       ('PROM004', '111'),
       ('PROM004', '112'),
       ('PROM005', '113'),
       ('PROM005', '114'),
       ('PROM005', '115'),
       ('PROM006', '116'),
       ('PROM006', '117'),
       ('PROM006', '118'),
       ('PROM007', '119'),
       ('PROM007', '120'),
       ('PROM007', '111'),
       ('PROM008', '112'),
       ('PROM008', '113'),
       ('PROM008', '114'),
       ('PROM009', '115'),
       ('PROM009', '116'),
       ('PROM009', '117'),
       ('PROM010', '118'),
       ('PROM010', '119'),
       ('PROM010', '120'),
       ('PROM010', '111');

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
       ('6788200', 'Wuthwara', 'Leungam', '2005-09-30', 'M'),
       ('6788254', 'Kittipat', 'Sangwiroj', '2005-03-14', 'M'),
       ('6788241', 'Chalita', 'Boonsiri', '2006-07-09', 'F'),
       ('6788320', 'Natthawat', 'Wiriyakul', '2005-11-18', 'M'),
       ('6788342', 'Pimchanok', 'Rattanaporn', '2006-02-27', 'F'),
       ('6788405', 'Jirayu', 'Suthamchai', '2005-08-03', 'M');

INSERT INTO Orders
VALUES ('7392641', '16:45:03', '2025-12-08', 'INCOMPLETE', '6788023', '101', 10),
       ('7396713', '20:32:55', '2025-03-17', 'COMPLETED', '6788130', '102', 12),
       ('5820582', '17:56:49', '2024-04-21', 'COMPLETED', '6788112', '103', 2),
       ('6767676', '13:28:52', '2025-11-20', 'INCOMPLETE', '6788200', '104', 1),
       ('4927471', '12:40:54', '2025-06-07', 'COMPLETED', '6788131', '105', 6),
       ('4082651', '19:40:12', '2024-08-09', 'COMPLETED', '6788023', '106', 2),
       ('1245379', '15:25:35', '2025-09-11', 'COMPLETED', '6788112', '107', 5),
       ('2018382', '16:39:29', '2024-08-30', 'COMPLETED', '6788130', '108', 44),
       ('9876543', '12:43:03', '2023-01-19', 'COMPLETED', '6788023', '109', 67),
       ('1357924', '10:23:00', '2025-12-02', 'COMPLETED', '6788200', '110', 7),
       ('7400101', '11:23:45', '2025-03-10', 'COMPLETED', '6788023', '101', 77),
       ('7400102', '15:40:22', '2024-11-18', 'INCOMPLETE', '6788112', '102', 9),
       ('7400103', '09:12:54', '2025-07-02', 'COMPLETED', '6788130', '103', 10),
       ('7400104', '18:55:13', '2024-09-21', 'COMPLETED', '6788291', '104', 12),
       ('7400105', '14:01:08', '2025-04-14', 'INCOMPLETE', '6788921', '105', 12),
       ('7400106', '07:25:34', '2024-06-10', 'COMPLETED', '6788371', '106', 15),
       ('7400107', '16:19:45', '2023-12-19', 'COMPLETED', '6788026', '107', 3),
       ('7400108', '10:10:10', '2025-10-12', 'COMPLETED', '6788145', '108', 22),
       ('7400109', '20:45:59', '2024-03-28', 'INCOMPLETE', '6788131', '109', 21),
       ('7400110', '12:33:18', '2025-11-03', 'COMPLETED', '6788200', '110', 8),
       ('7400111', '13:22:44', '2024-05-12', 'COMPLETED', '6788023', '101', 3),
       ('7400112', '17:58:01', '2025-01-30', 'COMPLETED', '6788112', '102', 6),
       ('7400113', '19:49:33', '2025-08-18', 'INCOMPLETE', '6788130', '103', 4),
       ('7400114', '08:20:47', '2024-10-06', 'COMPLETED', '6788291', '104', 32),
       ('7400115', '22:11:39', '2025-09-09', 'COMPLETED', '6788921', '105', 12),
       ('7400116', '06:59:11', '2024-07-25', 'COMPLETED', '6788371', '106', 14),
       ('7400117', '21:30:07', '2023-11-09', 'INCOMPLETE', '6788026', '107', 18),
       ('7400118', '15:13:21', '2025-06-16', 'COMPLETED', '6788145', '108', 13),
       ('7400119', '09:44:55', '2024-04-04', 'COMPLETED', '6788131', '109', 3),
       ('7400120', '18:18:18', '2025-12-05', 'INCOMPLETE', '6788200', '110', 2),
       ('2025212', '09:42:00', '2025-02-12', 'COMPLETED', '6788254', '109', 5),
       ('2020215', '14:18:00', '2025-02-15', 'COMPLETED', '6788254', '107', 1),
       ('2050216', '11:05:00', '2025-02-16', 'COMPLETED', '6788291', '108', 3),
       ('2250223', '15:17:00', '2025-02-23', 'COMPLETED', '6788291', '105', 4),
       ('2250218', '16:33:00', '2025-02-18', 'COMPLETED', '6788320', '104', 2),
       ('2025219', '10:11:00', '2025-02-19', 'COMPLETED', '6788320', '103', 4),
       ('2020220', '13:49:00', '2025-02-20', 'COMPLETED', '6788342', '102', 1),
       ('2050221', '09:58:00', '2025-02-21', 'COMPLETED', '6788342', '102', 3),
       ('2025022', '17:26:00', '2025-02-22', 'COMPLETED', '6788405', '110', 4),
       ('2025224', '18:02:00', '2025-02-24', 'COMPLETED', '6788405', '101', 2),
       ('7392331', '13:01:00', '2024-05-11', 'COMPLETED', '6788023', '101', 89),
       ('1232299', '14:30:00', '2024-05-12', 'COMPLETED', '6788130', '102', 50),
       ('5866662', '09:15:00', '2024-05-13', 'INCOMPLETE', '6788112', '103', 45),
       ('6754356', '18:05:00', '2024-05-14', 'COMPLETED', '6788200', '104', 50),
       ('4092333', '10:00:00', '2024-05-15', 'INCOMPLETE', '6788131', '105', 35);

INSERT INTO Products
VALUES ('4795980', 420, 29.99, 120, 'Yellow Submarine 22oz', '2025-12-01'),
       ('7989971', 990, 15.50, 15, 'Heritage Croissant', '2025-12-14'),
       ('4489972', 890, 40.75, 100, 'Bellinee’s Signature Coffee 16oz', '2025-12-05'),
       ('4434442', 750, 75.00, 225, 'Croissant Nutella', '2025-12-20'),
       ('7324521', 990, 15.50, 75, 'Hot Matcha Latte 12oz', '2025-12-14'),
       ('0829342', 890, 40.75, 100, 'Coconut Blossom Coffee 22oz', '2025-12-05'),
       ('3242344', 750, 95.00, 225, 'Red Velvet Cheese Croissant', '2025-12-20'),
       ('1302933', 990, 35.50, 75, 'Butter Croissant', '2025-12-14'),
       ('9817245', 890, 30.75, 100, 'Iced Chocolate 16oz', '2025-12-05'),
       ('4431442', 750, 75.00, 225, 'Mini Creamy Croissant', '2025-12-20'),
       ('9832742', 677, 30.00, 350, 'Ham Cheese Croissant', '2025-12-03');

INSERT INTO Bill
VALUES ('2025021', '2025-02-12', '09:50:40', '4719663416897', '375642301946900', '0001', '7396713'),
       ('2025022', '2025-02-15', '14:25:50', '2801002557363', NULL, '0002', '6754356'),
       ('2025023', '2025-02-16', '11:12:23', '5449857629536', '4426506860939960', '0003', '7400118'),
       ('2025024', '2025-02-23', '15:25:34', '8490347149997', '371871906048021', '0004', '7400120'),
       ('2025025', '2025-02-18', '16:40:23', '3549535298143', '3569967390400049', '0005', '2025219'),
       ('2025026', '2025-02-19', '10:20:11', '8859221704732', NULL, '0005', '9876543'),
       ('2025027', '2025-02-20', '13:55:34', '9263943350951', NULL, '0001', '4082651'),
       ('2025028', '2025-02-21', '10:05:53', '7298316773550', '4889267867168411', '0002', '7400102'),
       ('2025029', '2025-02-22', '17:32:12', '9806252711671', NULL, '0003', '7400119'),
       ('2025030', '2025-02-24', '18:10:19', '5902084742334', NULL, '0004', '1357924'),
       ('2025031', '2025-02-25', '09:22:31', '6409931028745', NULL, '0001', '7400103'),
       ('2025032', '2025-02-25', '10:41:12', '9045523189074', '4539217601123456', '0002', '2250218'),
       ('2025033', '2025-02-25', '11:58:44', '2198456773012', NULL, '0003', '2250223'),
       ('2025034', '2025-02-26', '12:33:29', '3509941285531', '6011983745562345', '0004', '7400111'),
       ('2025035', '2025-02-26', '13:47:51', '7782015649320', NULL, '0005', '7400119'),
       ('2025036', '2025-02-26', '14:59:40', '9031284796511', '374829174553210', '0001', '2020215'),
       ('2025037', '2025-02-27', '09:15:27', '5598137402249', NULL, '0002', '7400115'),
       ('2025038', '2025-02-27', '10:24:33', '1249855309127', '4539876210456712', '0003', '2025212'),
       ('2025039', '2025-02-27', '11:41:59', '9785442137754', NULL, '0004', '7400109'),
       ('2025040', '2025-02-27', '12:53:18', '6872001458962', '370019284556782', '0005', '7400116'),
       ('2025041', '2025-02-28', '09:09:15', '9015528734102', NULL, '0001', '7400110'),
       ('2025042', '2025-02-28', '10:18:22', '2784159906743', '4620183945567788', '0002', '7400108'),
       ('2025043', '2025-02-28', '11:40:10', '5400928374105', NULL, '0003', '7400104'),
       ('2025044', '2025-03-01', '13:11:47', '7993152048893', '6011123498765432', '0004', '1357924'),
       ('2025045', '2025-03-01', '14:44:20', '6938015249073', NULL, '0005', '7400112'),
       ('2025046', '2025-03-01', '15:59:33', '8224901376412', NULL, '0001', '9876543'),
       ('2025047', '2025-03-02', '09:33:51', '3584197509822', '4867201983471122', '0002', '6767676'),
       ('2025048', '2025-03-02', '10:58:02', '9057732104581', NULL, '0003', '7400101'),
       ('2025049', '2025-03-02', '12:25:40', '1649205783129', '372014598732110', '0004', '4927471'),
       ('2025050', '2025-03-02', '13:47:58', '7305921845013', NULL, '0005', '7400105');

INSERT INTO OrderProduct
VALUES ('7392641', '4795980'),
       ('7396713', '7989971'),
       ('5820582', '4489972'),
       ('6767676', '4434442'),
       ('4927471', '3242344'),
       ('4082651', '4795980'),
       ('1245379', '7989971'),
       ('2018382', '1302933'),
       ('9876543', '7324521'),
       ('1357924', '9832742'),
       ('7400119', '1302933'),
       ('7400120', '9817245'),
       ('2025212', '4431442'),
       ('2020215', '0829342'),
       ('2050216', '7324521'),
       ('2250223', '3242344'),
       ('2250218', '7989971'),
       ('2025219', '4489972'),
       ('2020220', '3242344'),
       ('2050221', '9817245'),
       ('7400101', '9817245'),
       ('7400102', '9817245'),
       ('7400103', '4489972'),
       ('7400104', '0829342'),
       ('7400105', '9832742'),
       ('7400106', '0829342'),
       ('7400107', '7989971'),
       ('7400108', '4489972'),
       ('7400109', '4431442'),
       ('7400110', '9832742'),
       ('7392331', '4795980'),
       ('7400111', '7989971'),
       ('7400117', '4489972'),
       ('5866662', '4434442'),
       ('7400112', '7324521'),
       ('1232299', '0829342'),
       ('7400113', '3242344'),
       ('4092333', '1302933'),
       ('7400118', '9817245'),
       ('6754356', '4431442'),
       ('7400114', '9832742'),
       ('7400116', '4795980'),
       ('2025022', '7989971'),
       ('2025224', '4489972'),
       ('7400115', '4434442');

SELECT *
FROM Branch;
SELECT *
FROM Staff;
SELECT *
FROM Cashier;
SELECT *
FROM Promoter;
SELECT *
FROM Orders;
SELECT *
FROM Customer;
SELECT *
FROM Products;
SELECT *
FROM OrderProduct;
SELECT *
FROM Bill;
SELECT *
FROM Promotion;
SELECT *
FROM PromotionPromoter;



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
Youngest Customer of male and female with the age
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
Display the promotion that was created by the staff who is in charge of designing the promotion
(Promotion + PromotionPromoter + Promoter + Staff)
*/
SELECT StaffID, CONCAT(StaffFirstName, ' ', StaffLastName) AS StaffName, PromotionID, PromotionName, PromoterRole
FROM Staff s
         INNER JOIN Promoter pr ON s.StaffID = pr.PromoterStaffID
         INNER JOIN PromotionPromoter pp ON s.StaffID = pp.PP_PromoterStaffID
         INNER JOIN Promotion p ON pp.PP_PromotionID = p.PromotionID
WHERE PromoterRole = 'Designer'
ORDER BY StaffID;


/*Show all of the customer and product names that they have ordered before Dec 2025 (Customer + Order+OrderProduct+Product)*/
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

/* -----------------------------------------------------
 *     FIXME: `op.OP_ORDERQUANTITY` ตรงนี้ฝากแก้ด้วยครับ
------------------------------------------------------*/
SELECT *
FROM OrderProduct;
SELECT o.OrderID, o.OrderDate, p.Calories, op.OP_ORDERQUANTITY AS Quantity
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

/* =================================================== M QUERIES =================================================== */
-- ...
