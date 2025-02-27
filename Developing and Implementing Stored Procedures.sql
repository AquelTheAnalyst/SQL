-- Name: Aquel Daley
-- Lesson: Developing and Implementing Stored Procedures 1&2 Lab
-- Date: 08/23/2022
-- Purpose: Create stored procedures for sales and employee data analysis
-- Assumes AdventureWorks database context

-- Procedure for Sales by Territory
IF OBJECT_ID('dbo.proc_SalesByTerritory', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_SalesByTerritory;
GO
CREATE PROCEDURE dbo.proc_SalesByTerritory
    @TerritoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.Name, YEAR(OrderDate) AS [Year], SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader S
    LEFT OUTER JOIN Person.StateProvince t ON S.TerritoryID = t.TerritoryID
    WHERE t.Name = @TerritoryName
    GROUP BY t.Name, YEAR(OrderDate)
    ORDER BY YEAR(OrderDate);
END;
GO
EXEC dbo.proc_SalesByTerritory @TerritoryName = 'Georgia';

-- Procedure for Top Sales by Product
IF OBJECT_ID('dbo.proc_TerritoryTopSales_ByProduct', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_TerritoryTopSales_ByProduct;
GO
CREATE PROCEDURE dbo.proc_TerritoryTopSales_ByProduct
    @TerritoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Year INT;
    SELECT @Year = (SELECT TOP 1 YEAR(OrderDate) FROM Sales.SalesOrderHeader);

    -- Temporary tables
    CREATE TABLE #Products (TerName VARCHAR(50), ProdName VARCHAR(50), TotalSales MONEY, [Year] INT);
    INSERT INTO #Products (TerName, ProdName, TotalSales, [Year])
    SELECT t.Name, p.Name, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS [Year]
    FROM Sales.SalesOrderHeader S
    LEFT OUTER JOIN Person.StateProvince t ON S.TerritoryID = t.TerritoryID
    LEFT OUTER JOIN Sales.SalesOrderDetail d ON S.SalesOrderID = d.SalesOrderID
    LEFT OUTER JOIN Production.Product p ON d.ProductID = p.ProductID
    WHERE t.Name = @TerritoryName
    GROUP BY t.Name, p.Name, YEAR(OrderDate);

    CREATE TABLE #YearTopSalesProducts (TerName VARCHAR(50), ProdName VARCHAR(50), TotalSales MONEY, [Year] INT);

    WHILE @Year IS NOT NULL
    BEGIN
        INSERT INTO #YearTopSalesProducts (TerName, ProdName, TotalSales, [Year])
        SELECT TOP 5 TerName, ProdName, TotalSales, [Year]
        FROM #Products
        WHERE [Year] = @Year
        ORDER BY TotalSales DESC;
        
        DELETE FROM #Products WHERE [Year] = @Year;
        SET @Year = (SELECT TOP 1 [Year] FROM #Products);
    END;

    SELECT * FROM #YearTopSalesProducts ORDER BY [Year];
    DROP TABLE #Products;
    DROP TABLE #YearTopSalesProducts;
END;
GO
EXEC dbo.proc_TerritoryTopSales_ByProduct @TerritoryName = 'Georgia';

-- Procedure to find ManagerID (corrected to return ManagerID)
IF OBJECT_ID('dbo.proc_findHerID', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_findHerID;
GO
CREATE PROCEDURE dbo.proc_findHerID
    @empID INT,
    @mgrID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @mgrID = ManagerID
    FROM HumanResources.Employee
    WHERE BusinessEntityID = @empID;
END;
GO
DECLARE @emp INT = 4;
DECLARE @ManagerID INT;
EXEC dbo.proc_findHerID @emp, @mgrID = @ManagerID OUTPUT;
SELECT @ManagerID AS ManagerID;
SELECT EmpName
FROM HumanResources.Employee -- Assuming Name column exists; adjust if needed
WHERE BusinessEntityID = @ManagerID;

-- Procedure for Sales Order details
IF OBJECT_ID('dbo.proc_5', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_5;
GO
CREATE PROCEDURE dbo.proc_5
    @SalesOrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT s.SalesOrderID, s.OrderDate, s.ShipDate, a.City, st.Name
    FROM Sales.SalesOrderHeader s
    INNER JOIN Person.Address a ON s.ShipToAddressID = a.AddressID
    INNER JOIN Person.StateProvince st ON s.TerritoryID = st.TerritoryID
    WHERE s.SalesOrderID = @SalesOrderID;
END;
GO

-- Procedure for Territory Sales Counts
IF OBJECT_ID('dbo.proc_6', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_6;
GO
CREATE PROCEDURE dbo.proc_6
    @TerritoryName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ST.[Group] AS TerritoryGroup, ST.CountryRegionCode,
           COUNT(DISTINCT SOD.SalesOrderID) AS CountOfSalesHeaders,
           COUNT(SOH.SalesOrderID) AS CountOfSalesDetails
    FROM Sales.SalesTerritory ST
    INNER JOIN Sales.SalesOrderHeader SOH ON ST.TerritoryID = SOH.TerritoryID
    INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE YEAR(SOH.OrderDate) = 2001 AND ST.Name = @TerritoryName
    GROUP BY ST.[Group], ST.CountryRegionCode;
END;
GO

-- Procedure for Product Sales Summary
IF OBJECT_ID('dbo.proc_7', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_7;
GO
CREATE PROCEDURE dbo.proc_7
    @ProductName VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT P.Name AS ProductName, MIN(SOD.UnitPrice) AS LowestPrice,
           MAX(SOD.UnitPrice) AS HighestPrice,
           COUNT(SOH.SalesOrderID) AS CountOfSalesDetails,
           SUM(SOD.LineTotal) AS SumOfLineTotal
    FROM Production.Product P
    INNER JOIN Sales.SalesOrderDetail SOD ON P.ProductID = SOD.ProductID
    INNER JOIN Sales.SalesOrderHeader SOH ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE P.Name = @ProductName
    GROUP BY P.ProductID, P.Name;
END;
GO

-- Procedure for Yearly Sales Counts
IF OBJECT_ID('dbo.proc_8', 'P') IS NOT NULL DROP PROCEDURE dbo.proc_8;
GO
CREATE PROCEDURE dbo.proc_8
    @OrderYear INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT YEAR(OrderDate) AS OrderYear,
           COUNT(DISTINCT SOD.SalesOrderID) AS CountOfSalesHeaders,
           COUNT(SOH.SalesOrderID) AS CountOfSalesDetails
    FROM Sales.SalesOrderHeader SOH
    INNER JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE YEAR(OrderDate) = @OrderYear
    GROUP BY YEAR(OrderDate);
END;
GO