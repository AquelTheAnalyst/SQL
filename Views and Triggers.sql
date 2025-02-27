-- Name: Aquel Daley
-- Lesson: Views and Triggers
-- Date: 08/25/2022
-- Purpose: Create triggers and views for HR, inventory, and sales data
-- Assumes AdventureWorks database context

-- Create Emp_triggers table
IF OBJECT_ID('dbo.Emp_triggers', 'U') IS NOT NULL DROP TABLE dbo.Emp_triggers;
CREATE TABLE dbo.Emp_triggers (
    EmpID INT PRIMARY KEY IDENTITY(1000,1),
    EmpName VARCHAR(50),
    DeptID INT
);

-- Create Emphistory table
IF OBJECT_ID('dbo.Emphistory', 'U') IS NOT NULL DROP TABLE dbo.Emphistory;
CREATE TABLE dbo.Emphistory (
    EmpID INT,
    DeptID INT,
    ISACTIVE INT
);

-- Trigger for INSERT
IF OBJECT_ID('dbo.TrgEmpAfterInsert', 'TR') IS NOT NULL DROP TRIGGER dbo.TrgEmpAfterInsert;
GO
CREATE TRIGGER dbo.TrgEmpAfterInsert
ON dbo.Emp_triggers
AFTER INSERT
AS
BEGIN
    DECLARE @EmpID INT, @DptID INT, @ISACTIVE INT;
    SELECT @EmpID = i.EmpID, @DptID = i.DeptID FROM inserted i;
    SET @ISACTIVE = 1;
    INSERT INTO dbo.Emphistory (EmpID, DeptID, ISACTIVE)
    VALUES (@EmpID, @DptID, @ISACTIVE);
    PRINT 'After INSERT trigger fired';
END;
GO

-- Trigger for UPDATE
IF OBJECT_ID('dbo.TrgEmpAfterUpdate', 'TR') IS NOT NULL DROP TRIGGER dbo.TrgEmpAfterUpdate;
GO
CREATE TRIGGER dbo.TrgEmpAfterUpdate
ON dbo.Emp_triggers
AFTER UPDATE
AS
BEGIN
    DECLARE @EmpID INT, @DptID INT;
    SELECT @EmpID = i.EmpID, @DptID = i.DeptID FROM inserted i;
    INSERT INTO dbo.Emphistory (EmpID, DeptID)
    VALUES (@EmpID, @DptID);
    PRINT 'After UPDATE trigger fired';
END;
GO

-- Trigger for DELETE
IF OBJECT_ID('dbo.TrgEmpAfterDelete', 'TR') IS NOT NULL DROP TRIGGER dbo.TrgEmpAfterDelete;
GO
CREATE TRIGGER dbo.TrgEmpAfterDelete
ON dbo.Emp_triggers
AFTER DELETE
AS
BEGIN
    DECLARE @EmpID INT, @DptID INT, @ISACTIVE INT;
    SELECT @EmpID = d.EmpID, @DptID = d.DeptID FROM deleted d;
    SET @ISACTIVE = 0;
    INSERT INTO dbo.Emphistory (EmpID, DeptID, ISACTIVE)
    VALUES (@EmpID, @DptID, @ISACTIVE);
    PRINT 'After DELETE trigger fired';
END;
GO

-- Insert data to test triggers
INSERT INTO dbo.Emp_triggers (EmpName, DeptID)
VALUES 
    ('Ali', 1000),
    ('Buba', 1000),
    ('Cat', 1001),
    ('Doggy', 1001),
    ('Elephant', 1002),
    ('Fish', 1002),
    ('George', 1003),
    ('Mike', 1003),
    ('Anand', 1004),
    ('Kishan', 1004);

-- Verify data and history
SELECT * FROM dbo.Emp_triggers;
SELECT * FROM dbo.Emphistory;

-- Update to test trigger
UPDATE dbo.Emp_triggers SET DeptID = 1005 WHERE EmpID = 1000;

-- Delete to test trigger
DELETE FROM dbo.Emp_triggers WHERE EmpID = 1000;

-- Create HR view
IF OBJECT_ID('dbo.VW_HumanResourceDepdetel', 'V') IS NOT NULL DROP VIEW dbo.VW_HumanResourceDepdetel;
GO
CREATE VIEW dbo.VW_HumanResourceDepdetel
AS
SELECT D.DepartmentID, H.BusinessEntityID, D.Name, D.GroupName, H.StartDate, H.EndDate, E.LoginID, E.JobTitle, E.Gender
FROM HumanResources.Department D
INNER JOIN HumanResources.EmployeeDepartmentHistory H ON D.DepartmentID = H.DepartmentID
INNER JOIN HumanResources.Employee E ON H.BusinessEntityID = E.BusinessEntityID
WHERE H.EndDate IS NOT NULL;
GO
SELECT * FROM dbo.VW_HumanResourceDepdetel;

-- Create Address view
IF OBJECT_ID('dbo.VW_AddressDetail', 'V') IS NOT NULL DROP VIEW dbo.VW_AddressDetail;
GO
CREATE VIEW dbo.VW_AddressDetail
AS
SELECT P.StateProvinceCode, P.CountryRegionCode, P.Name,
       LEN(A.AddressLine1) AS LengthOfAddressChar, UPPER(A.City) AS CITY, A.PostalCode
FROM Person.StateProvince P
INNER JOIN Person.Address A ON