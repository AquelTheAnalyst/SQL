-- Name: Aquel Daley
-- Lesson: User Defined Function
-- Date: 08/20/2022
-- Purpose: Create UDFs for HR analytics
-- Assumes AdventureWorks database context

-- Scalar UDF to get LoginID
IF OBJECT_ID('dbo.GetUserLoginID', 'FN') IS NOT NULL DROP FUNCTION dbo.GetUserLoginID;
GO
CREATE FUNCTION dbo.GetUserLoginID (@EmployeeID INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @UserLoginID VARCHAR(50);
    SELECT @UserLoginID = LoginID -- Corrected from LogID
    FROM HumanResources.Employee
    WHERE BusinessEntityID = @EmployeeID;
    RETURN ISNULL(@UserLoginID, 'Not Found');
END;
GO

-- Scalar UDF to get Age (years since hire)
IF OBJECT_ID('dbo.GetAge', 'FN') IS NOT NULL DROP FUNCTION dbo.GetAge;
GO
CREATE FUNCTION dbo.GetAge (@EmployeeID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SELECT @Age = DATEDIFF(YEAR, HireDate, GETDATE())
    FROM HumanResources.Employee
    WHERE BusinessEntityID = @EmployeeID;
    RETURN ISNULL(@Age, -1); -- Returns -1 if not found
END;
GO

-- Scalar UDF to get average vacation hours by gender
IF OBJECT_ID('dbo.GetAvgVacationHours', 'FN') IS NOT NULL DROP FUNCTION dbo.GetAvgVacationHours;
GO
CREATE FUNCTION dbo.GetAvgVacationHours (@Gender CHAR(1))
RETURNS INT
AS
BEGIN
    DECLARE @AvgVacationHours INT;
    SELECT @AvgVacationHours = AVG(VacationHours)
    FROM HumanResources.Employee
    WHERE Gender = @Gender;
    RETURN ISNULL(@AvgVacationHours, 0);
END;
GO

-- Table-valued UDF to get employees by ManagerID
IF OBJECT_ID('dbo.GetEmployees', 'TF') IS NOT NULL DROP FUNCTION dbo.GetEmployees;
GO
CREATE FUNCTION dbo.GetEmployees (@ManagerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT LoginID, Gender, HireDate
    FROM HumanResources.Employee
    WHERE ManagerID = @ManagerID -- Corrected from JobTitle
);
GO

-- Test the functions
SELECT dbo.GetUserLoginID(1) AS LoginID;
SELECT dbo.GetAge(1) AS YearsEmployed;
SELECT dbo.GetAvgVacationHours('M') AS AvgVacationMale;
SELECT * FROM dbo.GetEmployees(3);