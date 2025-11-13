-- Waris Sripatoomrak 6788112, Section 3
-- Lecture 14

DROP DATABASE IF EXISTS L14_6788112;
CREATE DATABASE IF NOT EXISTS L14_6788112;
USE L14_6788112;

DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS PhoneNum;
DROP TABLE IF EXISTS Cashier;
DROP TABLE IF EXISTS Promoter;

CREATE TABLE Branch (
    BranchID        CHAR(2) PRIMARY KEY NOT NULL UNIQUE,
    BranchLocation  VARCHAR(200)        NOT NULL,
    DateEstablished DATE                NOT NULL,
    SupervisorName  VARCHAR(100)        NOT NULL
);

CREATE TABLE Staff (
    StaffID     CHAR(4) PRIMARY KEY NOT NULL UNIQUE,
    FirstName   VARCHAR(50)         NOT NULL,
    LastName    VARCHAR(50)         NOT NULL,
    WorkingDate DATE                NOT NULL,
    StfRole     VARCHAR(20)         NOT NULL,
    Salary      DECIMAL(7, 2)       NOT NULL,
    StfBranchID CHAR(2)             NOT NULL,
    CONSTRAINT FK_StfBranchID
        FOREIGN KEY (StfBranchID)
            REFERENCES Branch (BranchID),
    CONSTRAINT CHK_StfRole
        CHECK (StfRole IN ('Cashier', 'Promoter'))
);

CREATE TABLE Address (
    AddrStaffID CHAR(4) NOT NULL,
    StfAddress  VARCHAR(200),
    CONSTRAINT PK_Address
        PRIMARY KEY (AddrStaffID, StfAddress),
    CONSTRAINT FK_AddrStaffID
        FOREIGN KEY (AddrStaffID)
            REFERENCES Staff (StaffID)
);

CREATE TABLE Email (
    EmailStaffID CHAR(4)     NOT NULL,
    StfEmail     VARCHAR(68) NOT NULL,
    CONSTRAINT PK_Email
        PRIMARY KEY (EmailStaffID, StfEmail),
    CONSTRAINT FK_EmailStaffID
        FOREIGN KEY (EmailStaffID)
            REFERENCES Staff (StaffID)
);

CREATE TABLE PhoneNum (
    PhoneStaffID CHAR(4)     NOT NULL,
    StfPhoneNum  VARCHAR(12) NOT NULL,
    CONSTRAINT PK_PhoneNum
        PRIMARY KEY (PhoneStaffID, StfPhoneNum),
    CONSTRAINT FK_PhoneStaffID
        FOREIGN KEY (PhoneStaffID)
            REFERENCES Staff (StaffID)
);

CREATE TABLE Cashier (
    CashierStaffID      CHAR(4) NOT NULL,
    CashierServiceSkill VARCHAR(20),
    CashierNumber       CHAR(4) NOT NULL,
    CONSTRAINT FK_CashierStaffID
        FOREIGN KEY (CashierStaffID)
            REFERENCES Staff (StaffID)
);

CREATE TABLE Promoter (
    PromoterStaffID CHAR(4) NOT NULL,
    PromoterRole    VARCHAR(20),
    CONSTRAINT FK_PromoterStaffID
        FOREIGN KEY (PromoterStaffID)
            REFERENCES Staff (StaffID),
    CONSTRAINT CHK_PromoterRole
        CHECK (PromoterRole IN
               ('Designer',
                'Coordinator',
                'Maintainer'))
);

INSERT INTO Branch
VALUES (1, 'Bangkok Central', '2015-03-01', 'Somchai Chaiyaporn'),
       (2, 'Chiang Mai', '2017-07-15', 'Nattawut Phongsa'),
       (3, 'Phuket', '2016-11-20', 'Supaporn Rattanakorn'),
       (4, 'Khon Kaen', '2018-01-05', 'Anuwat Srisuk'),
       (5, 'Hat Yai', '2019-06-10', 'Kanya Charoen');

INSERT INTO Staff
VALUES (101, 'Waris', 'Sripatoomrak', '2020-01-10', 'Cashier', 15000.00, 1),
       (102, 'Nussavas', 'Horchatnukul', '2021-03-20', 'Promoter', 18000.00, 2),
       (103, 'Warawuth', 'Ngamluea', '2019-05-15', 'Cashier', 16000.00, 3),
       (104, 'Pongrawee', 'Thepchai', '2022-07-01', 'Promoter', 17000.00, 4),
       (105, 'Wachiravich', 'Thaosiri', '2020-11-30', 'Cashier', 15500.00, 5),
       (106, 'Sunan', 'Wattana', '2023-08-21', 'Promoter', 18000.00, 1),
       (107, 'Somchit', 'Bunnag', '2019-05-05', 'Cashier', 16000.00, 2),
       (108, 'Kaew', 'Wattana', '2021-07-09', 'Promoter', 17000.00, 3),
       (109, 'Somjit', 'Bunnag', '2019-07-11', 'Promoter', 17000.00, 4),
       (110, 'Amphon', 'Metharom', '2025-11-12', 'Cashier', 15500.00, 5);

INSERT INTO Address
VALUES (101, '123 Sukhumvit Rd, Bangkok'),
       (102, '45/33 Chang Klan Rd, Chiang Mai'),
       (103, '78/67 Patong Beach, Phuket'),
       (104, '56/420 Mittraphap Rd, Khon Kaen'),
       (104, '104, 33 Khon Kaen Rd, Khon Kaen'),
       (105, '90 Hat Yai Rd, Hat Yai'),
       (105, '12 Songkhla Rd, Hat Yai'),
       (106, '90 Hat Yai Rd, Hat Yai'),
       (107, '24 Srinakarint Road, Nongbon'),
       (108, '757/8 Rachadaphisek 18 Sam Saen Nork Huai Khwang'),
       (109, 'Walking Street, Pattaya, Bang Lamung'),
       (110, '80/40 Soi Sukhaphibal 5 Ramintra Tha Rang Bangkhen');

INSERT INTO Email
VALUES (101, 'waris.sri@bellinees.com'),
       (102, 'nussavas.hor@bellinees.com'),
       (103, 'warawuth.nga@bellinees.com'),
       (104, 'pongrawee.the@bellinees.com'),
       (105, 'wachiravich.tha@bellinees.com'),
       (106, 'sunan.wat@bellinees.com'),
       (107, 'somchit.bun@bellinees.com'),
       (108, 'kaew.wat@bellinees.com'),
       (109, 'somjit.bun@bellinees.com'),
       (110, 'amphon.met@bellinees.com');

INSERT INTO PhoneNum
VALUES (101, '081-234-5678'),
       (102, '089-876-5432'),
       (103, '082-345-6789'),
       (104, '086-543-2198'),
       (105, '080-123-4567'),
       (106, '097-531-1371'),
       (107, '061-006-6377'),
       (108, '014-242-4593'),
       (109, '089-672-6631'),
       (110, '084-233-5567');

-- staff ID = 101 103 105 107 110 = cashiers
-- staff ID = 102 104 106 108 109 = promoters
INSERT INTO Cashier
VALUES (101, 'VIP Service', 1),
       (103, 'POS System', 2),
       (105, 'Cash Handling', 3),
       (103, 'Customer Service', 2),
       (105, 'Trilingual', 3),
       (107, 'Sales', 4),
       (101, 'Computer Literacy', 5),
       (105, 'Problem Solving', 6),
       (105, 'Communication', 7),
       (110, 'Product Knowledge', 8);

INSERT INTO Promoter
VALUES (102, 'Designer'),
       (104, 'Coordinator'),
       (106, 'Maintainer'),
       (108, 'Designer'),
       (109, 'Maintainer');

SELECT *
FROM Address;
SELECT *
FROM Branch;
SELECT *
FROM Cashier;
SELECT *
FROM Email;
SELECT *
FROM PhoneNum;
SELECT *
FROM Promoter;
SELECT *
FROM Staff;

/*
Query 1:
Retrieve all full names of the staff members who work in branches established before 2018 and earn a salary greater than 16000,
filtering by branch establishment date and salary threshold.
*/

SELECT CONCAT(FirstName, ' ', LastName) AS StaffFullName,
       YEAR(b.DateEstablished)          AS BranchEstablished,
       s.Salary                         AS StaffSalary,
       s.StfBranchID
FROM Staff s
         INNER JOIN Branch b ON s.StfBranchID = b.BranchID
WHERE YEAR(b.DateEstablished) < 2018
  AND s.Salary >= 16000
ORDER BY BranchEstablished;

/*
Query 2:
Retrieve all cashiers along with their branch location and supervisor name by joining the
Staff, Cashier, and Branch tables, filtering for staff with the Cashier role.
*/

SELECT DISTINCT CONCAT(FirstName, ' ', LastName) AS FullName,
                BranchLocation,
                SupervisorName
FROM Cashier c
         INNER JOIN Staff s ON s.StaffID = c.CashierStaffID
         INNER JOIN Branch b ON s.StfBranchID = b.BranchID;