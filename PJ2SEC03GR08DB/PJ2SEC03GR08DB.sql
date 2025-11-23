-- Bellinee's Bake and Brew SQL Script

DROP DATABASE IF EXISTS PJ2SEC03GR08DB;
CREATE DATABASE IF NOT EXISTS PJ2SEC03GR08DB;
USE PJ2SEC03GR08DB;

DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Cashier;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Bill;
DROP TABLE IF EXISTS Promoter;
DROP TABLE IF EXISTS Promotion;
DROP TABLE IF EXISTS Promotion_Promoter;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS OrderProduct;
DROP TABLE IF EXISTS Promoter_Promotion_Usage;
DROP TABLE IF EXISTS Order_TotalAmount;
DROP TABLE IF EXISTS Promotion_AvailableItem;

-- IDs MUST be CHAR(n) since INT is for numbers that can be processed and calculated to fulfill meaningful tasks
CREATE TABLE Branch (
    BranchID        CHAR(7) PRIMARY KEY,
    BranchLocation  VARCHAR(100) NOT NULL,
    DateEstablished DATE         NOT NULL,
    SupervisorName  VARCHAR(40)  NOT NULL
);

CREATE TABLE Staff (
    StaffID      CHAR(7) PRIMARY KEY,
    Salary       DECIMAL(7, 2),
    `Role`       VARCHAR(20),
    PhoneNum     INT(10),
    Email        VARCHAR(30),
    WorkingDate  DATE        NOT NULL,
    StfFirstName VARCHAR(20) NOT NULL,
    StfLastName  VARCHAR(20) NOT NULL,
    StfBranchID  INT(7),
    CONSTRAINT FK_StfBranchID FOREIGN KEY (StfBranchID) REFERENCES Branch (BranchID)
);


CREATE TABLE Cashier (
    CashierStaffID      CHAR(7),
    CashierServiceSkill VARCHAR(20),
    CashierNumber       INT(5) NOT NULL,
    CONSTRAINT FK_CashierStaffID FOREIGN KEY (CashierStaffID) REFERENCES Staff (StaffID)
);


CREATE TABLE `Order` (
    OrderID             CHAR(7) PRIMARY KEY,
    OrderTime           TIME,
    OrderDate           DATE,
    OrderStatus         VARCHAR(20) NOT NULL,
    OrderCashierStaffID INT(7),
    CONSTRAINT FK_OrderCashierStaffID FOREIGN KEY (OrderCashierStaffID) REFERENCES Cashier (CashierStaffID)
);

CREATE TABLE Customer (
    CustomerID        CHAR(7) PRIMARY KEY,
    CustomerFirstName VARCHAR(20) NOT NULL,
    CustomerLastName  VARCHAR(20) NOT NULL,
    DateOfBirth       DATE,
    Gender            VARCHAR(10),
    CustomerOrderID   INT(7),
    CONSTRAINT FK_CustomerOrderID FOREIGN KEY (CustomerOrderID) REFERENCES `Order` (OrderID)
);

CREATE TABLE Bill (
    BillID      CHAR(7) PRIMARY KEY,
    BillDate    DATE        NOT NULL,
    BranchName  VARCHAR(20) NOT NULL,
    BillTime    TIME        NOT NULL,
    BillOrderID INT(7),
    CONSTRAINT FK_BillOrderID FOREIGN KEY (BillOrderID) REFERENCES `Order` (OrderID)
);


CREATE TABLE Promoter (
    PromoterStaffID CHAR(7),
    PromotionRole   VARCHAR(20),
    CONSTRAINT FK_PromoterStaffID FOREIGN KEY (PromoterStaffID) REFERENCES Staff (StaffID)
);


CREATE TABLE Promotion (
    PromotionID         CHAR(7) PRIMARY KEY,
    EligibilityCriteria VARCHAR(100) NOT NULL,
    PromotionName       VARCHAR(20)  NOT NULL,
    StartDate           DATE         NOT NULL,
    EndDate             DATE         NOT NULL
);

CREATE TABLE Promotion_Promoter (
    PromotionID     CHAR(7),
    PromoterStaffID INT(7),
    CONSTRAINT FK_PromotionID FOREIGN KEY (PromotionID) REFERENCES Promotion (PromotionID),
    CONSTRAINT FK_PromoterStaffID_Promotion_Promoter FOREIGN KEY (PromoterStaffID) REFERENCES Promotion (PromotionID)
);
CREATE TABLE Product (
    ProductID    CHAR(5) PRIMARY KEY,
    Calories     INT,
    ProductPrice DECIMAL(13, 2),
    ProductName  VARCHAR(20),
    ExpiryDate   DATE
);
CREATE TABLE OrderProduct (
    OrderID         CHAR(7),
    AmountOfProduct INT,
    ProductID       INT(7),
    CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES
        `Order` (OrderID),
    CONSTRAINT FK_ProductID FOREIGN KEY (ProductID) REFERENCES Product (ProductID)
);

CREATE TABLE Promoter_Promotion_Usage (
    PromoterStaffID CHAR(7),
    PromotionUsage  INT,
    CONSTRAINT FK_PromoterStaffID_Promoter_Promotion_Usage FOREIGN KEY (PromoterStaffID) REFERENCES
        Promoter (PromoterStaffID)
);

# CREATE TABLE BranchID(
#                          BranchID INT(7),
#                          CONSTRAINT FK_BranID FOREIGN KEY (BranchID) REFERENCES
#                              Branch(BranchID)
# );

CREATE TABLE Order_TotalAmount (
    OrderID     CHAR(7),
    TotalAmount INT,
    CONSTRAINT FK_OrderID_TotalAmount FOREIGN KEY (OrderID) REFERENCES
        `Order` (OrderID)
);

CREATE TABLE Promotion_AvailableItem (
    PromotionID   CHAR(7),
    AvailableTime DATE,
    CONSTRAINT FK_PromotionID_AvailableItem FOREIGN KEY (PromotionID) REFERENCES
        `Order` (OrderID)
);