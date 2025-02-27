-- Name: Aquel Daley
-- Lesson: SQL Review
-- Date: 08/25/2022
-- Purpose: Review basic SQL concepts and queries

-- Q1: T-SQL stands for Transact-Structured Query Language (Microsoft/Sybase extension)

-- Q2: Keyword to extract data: SELECT

-- Q3: Keyword to modify data: UPDATE (corrected from ALTER, which modifies schema)

-- Q4: Keyword to add data: INSERT

-- Q5: Join differences
-- a. LEFT JOIN: All rows from left table, NULLs if no match in right
-- b. INNER JOIN: Only rows with matches in both tables
-- c. RIGHT JOIN: All rows from right table, NULLs if no match in left

-- Q6: Table vs View
-- Table: Physical storage of rows/columns
-- View: Virtual table from a query

-- Q7: Temp Table vs Table Variable
-- Temp Table: Physical, multi-user, easy to create
-- Table Variable: Session-scoped, less overhead

-- Create sample tables for queries
IF OBJECT_ID('dbo.TableA', 'U') IS NOT NULL DROP TABLE dbo.TableA;
IF OBJECT_ID('dbo.TableB', 'U') IS NOT NULL DROP TABLE dbo.TableB;
CREATE TABLE dbo.TableA (Field1 INT PRIMARY KEY);
CREATE TABLE dbo.TableB (Field1 INT PRIMARY KEY);
INSERT INTO dbo.TableA VALUES (1), (2), (3), (4), (5), (6);
INSERT INTO dbo.TableB VALUES (3), (5), (6), (7), (9);

-- Q8: Display matching values
SELECT a.Field1, b.Field1
FROM dbo.TableA a
INNER JOIN dbo.TableB b ON a.Field1 = b.Field1;

-- Q9: Display TableA values not in TableB
SELECT a.Field1, b.Field1
FROM dbo.TableA a
LEFT JOIN dbo.TableB b ON a.Field1 = b.Field1
WHERE b.Field1 IS NULL;

-- Q10: Display TableB values not in TableA
SELECT a.Field1, b.Field1
FROM dbo.TableA a
RIGHT JOIN dbo.TableB b ON a.Field1 = b.Field1
WHERE a.Field1 IS NULL;

-- Q11: Display unique values from TableA
SELECT DISTINCT Field1
FROM dbo.TableA;

-- Q12: Display total records per unique value in TableA
SELECT Field1, COUNT(Field1) AS Count
FROM dbo.TableA
GROUP BY Field1;

-- Q13: Display unique values from TableA occurring more than once
SELECT Field1, COUNT(Field1) AS Count
FROM dbo.TableA
GROUP BY Field1
HAVING COUNT(Field1) > 1; -- Note: Sample data has no duplicates

-- Q16: Declare variable
DECLARE @Variable1 VARCHAR(50) = 'Welcome to planet earth';
SELECT @Variable1 AS SampleVariable;

-- Q17 & Q18: Create and populate Table1
IF OBJECT_ID('dbo.Table1', 'U') IS NOT NULL DROP TABLE dbo.Table1;
CREATE TABLE dbo.Table1 (
    Field1 INT,
    Field2 DATETIME,
    Field3 VARCHAR(500)
);
INSERT INTO dbo.Table1 (Field1, Field2, Field3)
VALUES 
    (34, '2012-01-19 08:00:00', 'Mars Saturn'),
    (65, '2012-02-15 10:30:00', 'Big Bright Sun'),
    (89, '2012-03-31 09:15:00', 'Red Hot Mercury');
SELECT * FROM dbo.Table1;