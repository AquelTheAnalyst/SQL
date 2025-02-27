-- Name: Aquel Daley
-- Lesson: Constraints Lab
-- Date: 08/11/2022
-- Purpose: Create tables with constraints and populate with sample data
-- Target: MySQL

-- Drop tables if they exist
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS SalesReps;
DROP TABLE IF EXISTS Sales;

-- Create Customer table
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    CustName VARCHAR(5) NOT NULL,
    EntryDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create SalesReps table
CREATE TABLE SalesReps (
    RepID INT PRIMARY KEY,
    RepName VARCHAR(50) NOT NULL,
    HireDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Sales table with constraints
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    CustID INT,
    RepID INT,
    SalesDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UnitCount INT,
    VerificationCode VARCHAR(50) UNIQUE,
    FOREIGN KEY (CustID) REFERENCES Customer(CustID),
    FOREIGN KEY (RepID) REFERENCES SalesReps(RepID)
);

-- Insert data into Customer
INSERT INTO Customer (CustID, CustName)
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
INSERT INTO SalesReps (RepID, RepName)
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
INSERT INTO Sales (SalesID, CustID, RepID, UnitCount, VerificationCode)
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
SELECT * FROM Customer;
SELECT * FROM SalesReps;
SELECT * FROM Sales;