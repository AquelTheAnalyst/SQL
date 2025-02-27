-- Name: Aquel Daley
-- Lesson: Welcome to Joins & Combining Data from Multiple Sources
-- Date: 08/21/2022
-- Purpose: Demonstrate INNER and LEFT OUTER joins with sample data
-- Assumes AdventureWorks database context for some tables

-- Create and populate staging table
IF OBJECT_ID('dbo.stg_emp2', 'U') IS NOT NULL DROP TABLE dbo.stg_emp2;
CREATE TABLE dbo.stg_emp2 (
    EmdID INT PRIMARY KEY, -- Corrected typo from EmdID
    EmpName VARCHAR(50) NOT NULL
);
INSERT INTO dbo.stg_emp2 (EmdID, EmpName)
VALUES 
    (1, 'JohnDoe'),
    (2, 'JaneDoe'),
    (3, 'SallyMae');
SELECT * FROM dbo.stg_emp2;

-- Assuming Emp_List exists; simulating it here for completeness
IF OBJECT_ID('dbo.Emp_List', 'U') IS NOT NULL DROP TABLE dbo.Emp_List;
CREATE TABLE dbo.Emp_List (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL
);
INSERT INTO dbo.Emp_List (EmpID, EmpName)
VALUES 
    (1, 'JohnDoe'),
    (4, 'MikeSmith');
SELECT * FROM dbo.Emp_List;

-- LEFT OUTER JOIN to find new employees
SELECT stg.EmdID, stg.EmpName AS "New Employee", E.EmpID AS "Seniority Level"
FROM dbo.stg_emp2 stg
LEFT OUTER JOIN dbo.Emp_List E ON stg.EmdID = E.EmpID
WHERE E.EmpID IS NULL;

-- LEFT OUTER JOIN to find former employees
SELECT E.EmpID AS "Current Status", E.EmpName AS "Former Employees"
FROM dbo.Emp_List E
LEFT OUTER JOIN dbo.stg_emp2 stg ON E.EmpID = stg.EmdID
WHERE stg.EmdID IS NULL;

-- INNER JOIN for Vista card sales
SELECT S.SalesOrderID, S.CreditCardID, C.CardType
FROM Sales.SalesOrderHeader S
INNER JOIN Sales.CreditCard C ON S.CreditCardID = C.CreditCardID
WHERE C.CardType = 'Vista'
AND S.OrderDate BETWEEN '2012-10-01' AND '2012-10-31';

-- Variable to count Vista card sales
DECLARE @SalesOrders INT;
SELECT @SalesOrders = COUNT(*)
FROM Sales.SalesOrderHeader a
INNER JOIN Sales.CreditCard b ON a.CreditCardID = b.CreditCardID
WHERE b.CardType = 'Vista'
AND a.OrderDate BETWEEN '2012-10-01' AND '2012-10-31';
SELECT @SalesOrders AS SalesOrder;

-- Table-valued UDF for Vista card sales
IF OBJECT_ID('dbo.fx_VistaCardSalesOrders', 'TF') IS NOT NULL DROP FUNCTION dbo.fx_VistaCardSalesOrders;
GO
CREATE FUNCTION dbo.fx_VistaCardSalesOrders (
    @OrderStartDate DATE = '2012-10-01',
    @OrderEndDate DATE = '2012-10-31'
)
RETURNS TABLE
AS
RETURN (
    SELECT cc.CreditCardID, COUNT(so.SalesOrderID) AS NumberOfSales, cc.CardType, so.OrderDate
    FROM Sales.SalesOrderHeader so
    INNER JOIN Sales.CreditCard cc ON so.CreditCardID = cc.CreditCardID
    WHERE cc.CardType = 'Vista'
    AND so.OrderDate BETWEEN @OrderStartDate AND @OrderEndDate
    GROUP BY cc.CreditCardID, cc.CardType, so.OrderDate
);
GO
SELECT * FROM dbo.fx_VistaCardSalesOrders('2012-10-01', '2012-10-31') ORDER BY CardType;

-- INNER JOIN for territory sales
SELECT so.TerritoryID, st.[Group], SUM(so.TotalDue) AS NATGroupTotalRevenue, DATEPART(YEAR, so.DueDate) AS DueDate
FROM Sales.SalesOrderHeader so
INNER JOIN Sales.SalesTerritory st ON so.TerritoryID = st.TerritoryID
WHERE st.[Group] = 'North America'
AND DATEPART(YEAR, so.DueDate) BETWEEN 2012 AND 2014
GROUP BY so.TerritoryID, st.[Group], DATEPART(YEAR, so.DueDate)
ORDER BY so.TerritoryID, DueDate ASC;

-- INNER JOIN for Texas tax rates
SELECT st.TaxRate, sp.StateProvinceCode, sp.CountryRegionCode
FROM Sales.SalesTaxRate st
INNER JOIN Person.StateProvince sp ON st.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'Texas';

-- Table variable for Texas tax rates
DECLARE @TexasTaxRate TABLE (TaxRate SMALLMONEY, StateProvinceCode NCHAR(3), CountryRegionCode NCHAR(3));
INSERT INTO @TexasTaxRate
SELECT st.TaxRate, sp.StateProvinceCode, sp.CountryRegionCode
FROM Sales.SalesTaxRate st
INNER JOIN Person.StateProvince sp ON st.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'Texas';
SELECT * FROM @TexasTaxRate;

-- UDF for state tax info
IF OBJECT_ID('dbo.Fx_StateProvTaxInfo', 'TF') IS NOT NULL DROP FUNCTION dbo.Fx_StateProvTaxInfo;
GO
CREATE FUNCTION dbo.Fx_StateProvTaxInfo (@Name VARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT st.TaxRate, sp.StateProvinceCode, sp.CountryRegionCode
    FROM Sales.SalesTaxRate st
    INNER JOIN Person.StateProvince sp ON st.StateProvinceID = sp.StateProvinceID
    WHERE sp.Name = @Name
);
GO
SELECT * FROM dbo.Fx_StateProvTaxInfo('Texas');

-- INNER JOIN for product sales by color
SELECT p.Color, COUNT(p.Color) AS SalesCnt, SUM(s.OrderQty * s.UnitPrice) AS SalesAmt
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail s ON p.ProductID = s.ProductID
WHERE p.Color IS NOT NULL
GROUP BY p.Color
HAVING SUM(s.OrderQty * s.UnitPrice) > 5000;

-- Multi-table INNER JOIN for inventory
SELECT pr.ProductID, pr.Name AS ProductName, ps.Name AS SubCategoryName, pr.Color, loc.Name AS LocationName, COUNT(pi.Quantity) AS InventoryQuantity
FROM Production.Product pr
INNER JOIN Production.ProductSubcategory ps ON pr.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductInventory pi ON pr.ProductID = pi.ProductID
INNER JOIN Production.Location loc ON loc.LocationID = pi.LocationID
WHERE pr.Color IS NOT NULL
GROUP BY pr.ProductID, pr.Name, ps.Name, loc.Name, pr.Color
ORDER BY pr.ProductID;