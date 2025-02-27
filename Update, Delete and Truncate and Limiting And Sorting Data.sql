-- Name: Aquel Daley
-- Lesson: Update, Delete and Truncate and Limiting And Sorting Data
-- Date: 08/15/2022
-- Purpose: Create Menu table, modify data, and perform sorted queries

-- Drop table if it exists
IF OBJECT_ID('dbo.Menu', 'U') IS NOT NULL DROP TABLE dbo.Menu;

-- Create Menu table with constraints
CREATE TABLE dbo.Menu (
    ItemID INT PRIMARY KEY IDENTITY(1000,1),
    ItemName VARCHAR(50),
    ItemType VARCHAR(50) NOT NULL,
    CostToMake MONEY CHECK (CostToMake > 0),
    Price MONEY,
    WeeklySales INT,
    MonthlySales INT,
    YearlySales INT
);

-- Insert data
INSERT INTO dbo.Menu (ItemName, ItemType, CostToMake, Price, WeeklySales, MonthlySales, YearlySales)
VALUES 
    ('Big Mac', 'Hamburger', 1.25, 3.24, 1015, 5000, 15853),
    ('Quarter Pounder / Cheese', 'Hamburger', 1.15, 3.24, 1000, 4589, 16095),
    ('Half Pounder / Cheese', 'Hamburger', 1.35, 3.50, 500, 3500, 12589),
    ('Whopper', 'Hamburger', 1.55, 3.99, 989, 4253, 13000),
    ('Kobe Cheeseburger', 'Hamburger', 2.25, 5.25, 350, 1500, 5000),
    ('Grilled Stuffed Burrito', 'Burrito', 0.75, 5.00, 2000, 7528, 17896),
    ('Bean Burrito', 'Burrito', 0.50, 1.00, 1750, 7000, 18853),
    ('7 layer Burrito', 'Burrito', 0.78, 2.50, 350, 1000, 2563),
    ('Dorrito Burrito', 'Burrito', 0.85, 1.50, 600, 2052, 9857),
    ('Turkey and Cheese Sub', 'Sub Sandwich', 1.75, 5.50, 1115, 7878, 16853),
    ('Philly Cheese Steak Sub', 'Sub Sandwich', 2.50, 6.00, 726, 2785, 8000),
    ('Tuna Sub', 'Sub Sandwich', 1.25, 4.50, 825, 3214, 13523),
    ('Meatball Sub', 'Sub Sandwich', 1.95, 6.50, 987, 4023, 15287),
    ('Italian Sub', 'Sub Sandwich', 2.25, 7.00, 625, 1253, 11111),
    ('3 Cheese Sub', 'Sub Sandwich', 0.25, 6.00, 815, 3000, 11853);

-- Verify data
SELECT * FROM dbo.Menu;

-- Create backup table
SELECT * INTO dbo.Menu_backup FROM dbo.Menu;

-- Verify backup
SELECT * FROM dbo.Menu_backup;

-- Update operations
UPDATE dbo.Menu_backup
SET ItemName = '4 Cheese Sub'
WHERE ItemName = '3 Cheese Sub';

UPDATE dbo.Menu_backup
SET MonthlySales = 1353
WHERE MonthlySales = 1253;

UPDATE dbo.Menu_backup
SET Price = 4.25
WHERE Price = 3.99;

UPDATE dbo.Menu_backup
SET CostToMake = 2.75
WHERE CostToMake = 0.78;

UPDATE dbo.Menu_backup
SET Price = Price + (0.1 * Price)
WHERE ItemType = 'Burrito';

-- Delete operations
DELETE FROM dbo.Menu_backup
WHERE (Price - CostToMake) < 1;

DELETE FROM dbo.Menu_backup
WHERE YearlySales < 10000;

-- Truncate table
TRUNCATE TABLE dbo.Menu_backup;

-- Limiting and sorting queries
SELECT ItemID, ItemName, ItemType, CostToMake, WeeklySales, MonthlySales, YearlySales, Price
FROM dbo.Menu
WHERE ItemType = 'Burrito'
ORDER BY Price DESC;

SELECT ItemID, ItemName, ItemType, CostToMake, WeeklySales, MonthlySales, YearlySales, Price
FROM dbo.Menu
WHERE CostToMake > 1
ORDER BY WeeklySales;

SELECT ItemType, SUM(Price - CostToMake) AS TotalProfit
FROM dbo.Menu
GROUP BY ItemType;

SELECT ItemType, SUM(WeeklySales) AS TotalWeeklySales
FROM dbo.Menu
GROUP BY ItemType
HAVING SUM(WeeklySales) > 3000
ORDER BY TotalWeeklySales;

SELECT ItemName, WeeklySales * (Price - CostToMake) AS WeeklyProfit,
       MonthlySales * (Price - CostToMake) AS MonthlyProfit,
       YearlySales * (Price - CostToMake) AS YearlyProfit
FROM dbo.Menu
WHERE ItemName = 'Big Mac';

SELECT ItemName, ItemType, (MonthlySales * Price) AS Monthly_Sales
FROM dbo.Menu
WHERE (MonthlySales * Price) > 20000;

SELECT ItemType, MAX(MonthlySales * (Price - CostToMake)) AS MonthlyBestProfit
FROM dbo.Menu
GROUP BY ItemType;