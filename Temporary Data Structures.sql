-- Name: Aquel Daley
-- Lesson: Temporary Data Structures
-- Date: 08/20/2022
-- Purpose: Demonstrate temporary tables, CTEs, and table variables with HR, sales, and product data
-- Assumes AdventureWorks database context

-- Temporary table for Design Engineers
SELECT BusinessEntityID, LoginID, JobTitle, HireDate
INTO #Employee
FROM HumanResources.Employee
WHERE JobTitle LIKE 'Design Engineer'
AND BusinessEntityID BETWEEN 1 AND 10;
SELECT * FROM #Employee;
DROP TABLE #Employee;

-- CTE for Design Engineers
WITH CTE_Employee AS (
    SELECT BusinessEntityID, LoginID, JobTitle, HireDate
    FROM HumanResources.Employee
    WHERE JobTitle LIKE 'Design Engineer'
    AND BusinessEntityID BETWEEN 1 AND 10
)
SELECT * FROM CTE_Employee;

-- Table variable for Design Engineers
DECLARE @Employee TABLE (BusinessEntityID INT, LoginID NVARCHAR(256), JobTitle NVARCHAR(50), HireDate DATE);
INSERT INTO @Employee (BusinessEntityID, LoginID, JobTitle, HireDate)
SELECT BusinessEntityID, LoginID, JobTitle, HireDate
FROM HumanResources.Employee
WHERE JobTitle LIKE 'Design Engineer'
AND BusinessEntityID BETWEEN 1 AND 10;
SELECT * FROM @Employee;

-- Temporary table for Products
SELECT ProductID, Name, SafetyStockLevel
INTO #Product
FROM Production.Product
WHERE Color IN ('Red', 'Black')
AND SafetyStockLevel NOT IN (100, 500);
SELECT * FROM #Product;
DROP TABLE #Product;

-- CTE for Products
WITH CTE_Product AS (
    SELECT ProductID, Name, SafetyStockLevel
    FROM Production.Product
    WHERE Color IN ('Red', 'Black')
    AND SafetyStockLevel NOT IN (100, 500)
)
SELECT * FROM CTE_Product;

-- Table variable for Products
DECLARE @Product TABLE (ProductID INT, Name NVARCHAR(50), SafetyStockLevel SMALLINT);
INSERT INTO @Product
SELECT ProductID, Name, SafetyStockLevel
FROM Production.Product
WHERE Color IN ('Red', 'Black')
AND SafetyStockLevel NOT IN (100, 500);
SELECT * FROM @Product;

-- Temporary table for Sales
SELECT SalesOrderID, COUNT(ProductID) AS NumberOfProducts, SUM(UnitPrice) AS TotalPrice
INTO #Sales
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;
SELECT * FROM #Sales;
DROP TABLE #Sales;

-- CTE for Sales
WITH CTE_Sales AS (
    SELECT SalesOrderID, COUNT(ProductID) AS NumberOfProducts, SUM(UnitPrice) AS TotalPrice
    FROM Sales.SalesOrderDetail
    GROUP BY SalesOrderID
)
SELECT * FROM CTE_Sales;

-- Table variable for Sales
DECLARE @Sales TABLE (SalesOrderID INT, NumberOfProducts INT, TotalPrice MONEY);
INSERT INTO @Sales
SELECT SalesOrderID, COUNT(ProductID) AS NumberOfProducts, SUM(UnitPrice) AS TotalPrice
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;
SELECT * FROM @Sales;

-- Temporary table for SalesTerritory with UNION
SELECT TerritoryID, Name, CountryRegionCode, [Group]
INTO #SalesTerritory
FROM Sales.SalesTerritory
WHERE TerritoryID > 10
UNION
SELECT TerritoryID, Name, CountryRegionCode, [Group]
FROM Sales.SalesTerritory;
SELECT * FROM #SalesTerritory;
DROP TABLE #SalesTerritory;

-- CTE for SalesTerritory with UNION
WITH CTE_SalesTerritory AS (
    SELECT TerritoryID, Name, CountryRegionCode, [Group]
    FROM Sales.SalesTerritory
    WHERE TerritoryID > 10
    UNION
    SELECT TerritoryID, Name, CountryRegionCode, [Group]
    FROM Sales.SalesTerritory
)
SELECT * FROM CTE_SalesTerritory;

-- Table variable for SalesTerritory with UNION
DECLARE @SalesTerritory TABLE (TerritoryID INT, Name NVARCHAR(50), CountryRegionCode NVARCHAR(3), [Group] NVARCHAR(50));
INSERT INTO @SalesTerritory
SELECT TerritoryID, Name, CountryRegionCode, [Group]
FROM Sales.SalesTerritory
UNION
SELECT TerritoryID, Name, CountryRegionCode, [Group]
FROM Sales.SalesTerritory;
SELECT * FROM @SalesTerritory;

-- Temporary table for Person
CREATE TABLE #Person (
    BusinessEntityID INT PRIMARY KEY IDENTITY(1,1),
    PersonType NCHAR(2),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
INSERT INTO #Person (PersonType, FirstName, LastName)
SELECT PersonType, FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID <= 15;
SELECT * FROM #Person;
DROP TABLE #Person;

-- CTE for Person
WITH CTE_Person AS (
    SELECT BusinessEntityID, PersonType, FirstName, LastName
    FROM Person.Person
    WHERE BusinessEntityID <= 15
)
SELECT * FROM CTE_Person;

-- Table variable for Person
DECLARE @Person TABLE (BusinessEntityID INT PRIMARY KEY IDENTITY(1,1), PersonType NCHAR(2), FirstName NVARCHAR(50), LastName NVARCHAR(50));
INSERT INTO @Person (PersonType, FirstName, LastName)
SELECT PersonType, FirstName, LastName
FROM Person.Person
WHERE BusinessEntityID <= 15;
SELECT * FROM @Person;

-- Temporary table for SalesTerritory by Country
SELECT TerritoryID, Name, CountryRegionCode, [Group], SalesLastYear
INTO #SalesTerritory_US
FROM Sales.SalesTerritory
WHERE CountryRegionCode = 'US';
SELECT * FROM #SalesTerritory_US;
DROP TABLE #SalesTerritory_US;

-- CTE for SalesTerritory by Country with TOP
WITH CTE_SalesTerritory_US AS (
    SELECT TOP 5 SalesLastYear, TerritoryID, Name, CountryRegionCode, [Group]
    FROM Sales.SalesTerritory
    WHERE CountryRegionCode = 'US'
    ORDER BY SalesLastYear ASC
)
SELECT * FROM CTE_SalesTerritory_US;

-- Table variable for SalesTerritory by Country
DECLARE @SalesTerritory_US TABLE (TerritoryID INT, Name NVARCHAR(50), CountryRegionCode NVARCHAR(3), [Group] NVARCHAR(50), SalesLastYear MONEY);
INSERT INTO @SalesTerritory_US
SELECT TerritoryID, Name, CountryRegionCode, [Group], SalesLastYear
FROM Sales.SalesTerritory
WHERE CountryRegionCode = 'US';
SELECT * FROM @SalesTerritory_US;

-- Temporary table for SalesTerritory aggregation
SELECT [Group], SUM(SalesLastYear) AS SalesLastYear
INTO #SalesTerritoryTwo
FROM Sales.SalesTerritory
GROUP BY [Group]
HAVING SUM(SalesLastYear) > 3500000;
SELECT * FROM #SalesTerritoryTwo;
DROP TABLE #SalesTerritoryTwo;

-- CTE for SalesTerritory aggregation
WITH CTE_SalesTerritoryTwo AS (
    SELECT [Group], SUM(SalesLastYear) AS SalesLastYear
    FROM Sales.SalesTerritory
    GROUP BY [Group]
    HAVING SUM(SalesLastYear) > 3500000
)
SELECT * FROM CTE_SalesTerritoryTwo;

-- Table variable for SalesTerritory aggregation
DECLARE @SalesTerritoryOne TABLE ([Group] NVARCHAR(50), SalesLastYear MONEY);
INSERT INTO @SalesTerritoryOne
SELECT [Group], SUM(SalesLastYear) AS SalesLastYear
FROM Sales.SalesTerritory
GROUP BY [Group]
HAVING SUM(SalesLastYear) > 3500000;
SELECT * FROM @SalesTerritoryOne;

-- CTE for Territory Sales with TOP 3
WITH CTE_TerritorySales3 AS (
    SELECT TOP 3 SUM(SalesLastYear) AS SalesLastYear, CountryRegionCode, [Group]
    FROM Sales.SalesTerritory
    WHERE [Group] IN ('North America', 'Europe')
    GROUP BY CountryRegionCode, [Group]
    HAVING SUM(SalesLastYear) > 1400000
    ORDER BY SalesLastYear DESC
)
SELECT * FROM CTE_TerritorySales3;

-- Table variable for Territory Sales
DECLARE @TerritorySales3 TABLE (CountryRegionCode NVARCHAR(3), [Group] NVARCHAR(50), SalesLastYear MONEY);
INSERT INTO @TerritorySales3
SELECT CountryRegionCode, [Group], SUM(SalesLastYear) AS SalesLastYear
FROM Sales.SalesTerritory
WHERE [Group] IN ('North America', 'Europe')
GROUP BY CountryRegionCode, [Group]
HAVING SUM(SalesLastYear) > 1400000;
SELECT * FROM @TerritorySales3;

-- Temporary table for Vendor with string manipulation
SELECT BusinessEntityID, AccountNumber, [Name],
       SUBSTRING(AccountNumber, CHARINDEX('0', AccountNumber), LEN(AccountNumber)) AS AccNumberLastFour
INTO #Vendor
FROM Purchasing.Vendor;
SELECT * FROM #Vendor;
DROP TABLE #Vendor;

-- CTE for Vendor with string manipulation
WITH CTE_Vendor AS (
    SELECT BusinessEntityID, AccountNumber, [Name],
           SUBSTRING(AccountNumber, CHARINDEX('0', AccountNumber), LEN(AccountNumber)) AS AccNumberLastFour
    FROM Purchasing.Vendor
)
SELECT * FROM CTE_Vendor;

-- Table variable for Vendor with string manipulation
DECLARE @Vendor TABLE (BusinessEntityID INT, AccountNumber NVARCHAR(15), [Name] NVARCHAR(50), AccNumberLastFour NVARCHAR(15));
INSERT INTO @Vendor (BusinessEntityID, AccountNumber, [Name], AccNumberLastFour)
SELECT BusinessEntityID, AccountNumber, [Name],
       SUBSTRING(AccountNumber, CHARINDEX('0', AccountNumber), LEN(AccountNumber)) AS AccNumberLastFour
FROM Purchasing.Vendor;
SELECT * FROM @Vendor;

-- Temporary table for Person with string manipulation
SELECT BusinessEntityID, PersonType, UPPER(CONCAT(FirstName, ' ', LastName)) AS Name
INTO #PersonInfo
FROM Person.Person
WHERE BusinessEntityID <= 30;
SELECT * FROM #PersonInfo;
DROP TABLE #PersonInfo;

-- CTE for Person with string manipulation
WITH CTE_PersonInfo AS (
    SELECT BusinessEntityID, PersonType, UPPER(CONCAT(FirstName, ' ', LastName)) AS Name
    FROM Person.Person
    WHERE BusinessEntityID <= 30
)
SELECT * FROM CTE_PersonInfo;

-- Table variable for Person with string manipulation
DECLARE @PersonInfo TABLE (BusinessEntityID INT, PersonType NCHAR(2), Name NVARCHAR(50));
INSERT INTO @PersonInfo (BusinessEntityID, PersonType, Name)
SELECT BusinessEntityID, PersonType, UPPER(CONCAT(FirstName, ' ', LastName)) AS Name
FROM Person.Person
WHERE BusinessEntityID <= 30;
SELECT * FROM @PersonInfo;