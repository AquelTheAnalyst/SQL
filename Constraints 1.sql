-- Name: Aquel Daley
-- Lesson: Constraints Lab
-- Date: 08/11/2022
-- Purpose: Create tables with constraints and populate with sample data
-- Target: SQL Server

-- Drop tables if they exist
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID('dbo.SalesReps', 'U') IS NOT NULL DROP TABLE dbo.SalesReps;
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;

-- Create Customer table
CREATE TABLE dbo.Customer (
    CustID INT PRIMARY KEY,
    CustName VARCHAR(5) NOT NULL,
    EntryDate DATETIME DEFAULT GETDATE()
);

-- Create SalesReps table
CREATE TABLE dbo.SalesReps (
    RepID INT PRIMARY KEY,
    RepName VARCHAR(50) NOT NULL,
    HireDate DATETIME DEFAULT GETDATE()
);

-- Create Sales table with constraints
CREATE TABLE dbo.Sales (
    SalesID INT PRIMARY KEY,
    CustID INT FOREIGN KEY REFERENCES dbo.Customer(CustID),
    RepID INT FOREIGN KEY REFERENCES dbo.SalesReps(RepID),
    SalesDate DATETIME DEFAULT GETDATE(),
    UnitCount INT,
    VerificationCode VARCHAR(50) UNIQUE
);

-- Insert data into Customer
INSERT INTO dbo.Customer (CustID, CustName)
VALUES 
    (100, 'Ali'),
    (102, 'Anand'),
    (104, 'Alex'),
    (106, 'Jack'),
    (108, 'Nina'),
    (110, 'Joel'),
    (112, 'Keon'),
    (114, 'James'),
    (116, 'Mike'),
    (118, 'Sai'),
    (120, 'Terry');

-- Insert data into SalesReps
INSERT INTO dbo.SalesReps (RepID, RepName)
VALUES 
    (100, 'Joseph'),
    (102, 'Jermaine'),
    (104, 'Marshall'),
    (106, 'Marvin'),
    (108, 'Mitchell'),
    (110, 'Johnson'),
    (112, 'Robert'),
    (114, 'Rachel'),
    (116, 'Rene'),
    (118, 'Brandy'),
    (120, 'Dirk');

-- Insert data into Sales
INSERT INTO dbo.Sales (SalesID, CustID, RepID, UnitCount, VerificationCode)
VALUES 
    (1, 100, 120, 1, 'Ver01'),
    (2, 102, 118, 2, 'Ver02'),
    (3, 104, 116, 3, 'Ver03'),
    (4, 106, 114, 4, 'Ver04'),
    (5, 108, 112, 5, 'Ver05'),
    (6, 110, 110, 1, 'Ver06'),
    (7, 112, 108, 2, 'Ver07'),
    (8, 114, 106, 3, 'Ver08'),
    (9, 116, 104, 4, 'Ver09'),
    (10, 118, 102, 5, 'Ver10'),
    (11, 120, 100, 6, 'Ver11');

-- Verify data
SELECT * FROM dbo.Customer;
SELECT * FROM dbo.SalesReps;
SELECT * FROM dbo.Sales;