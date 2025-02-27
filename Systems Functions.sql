-- Name: Aquel Daley
-- Lesson: System Functions
-- Date: 08/16/2022
-- Purpose: Demonstrate string, date, and conversion functions with Loan table

-- String functions
SELECT LEN('Aquel') AS [Length];
SELECT LEN('Extraordinary') AS [Length];
SELECT LEFT('Aquel', 5) AS [Left5];
SELECT LEFT('Extraordinary', 4) AS [Left4];
SELECT RIGHT('Aquel', 5) AS [Right5];
SELECT RIGHT('Extraordinary', 4) AS [Right4];
SELECT SUBSTRING('Aquel', 3, 6) AS [Substring];
SELECT SUBSTRING('Extraordinary', 8, 9) AS [Substring];
SELECT CHARINDEX('u', 'Aquel') AS [CharIndex];
SELECT CHARINDEX('d', 'Extraordinary') AS [CharIndex];
SELECT LTRIM('Aq uel') AS [LTrim];
SELECT LTRIM('Extraor dinary') AS [LTrim];
SELECT RTRIM('Aqu el') AS [RTrim];
SELECT RTRIM('Extra ordinary') AS [RTrim];

-- Date functions
SELECT DATEDIFF(HOUR, '2008-08-10 08:00', GETDATE()) AS [HoursSince];
SELECT DATEDIFF(YEAR, '2008-08-10', GETDATE()) AS [YearsSince];
SELECT DATEPART(MONTH, '1973-07-09') AS [Month];
SELECT DATEPART(MONTH, '1973-07-09') AS [MonthAgain];
SELECT DATEADD(YEAR, 34, '1973-07-09') AS [Add34Years];
SELECT DATEADD(HOUR, 50000, '1950-05-06') AS [Add50000Hours];

-- Conversion functions
SELECT CAST(34.35343431 AS INT) AS [CastToInt];
SELECT CAST('WELCOME' AS CHAR(6)) AS [CastToChar];
SELECT CONVERT(VARCHAR(50), GETDATE(), 101) AS [ConvertDate];
SELECT CONVERT(DATETIME, GETDATE(), 107) AS [ConvertDateTime];

-- NULL and numeric checks
SELECT ISNULL(NULL, 5) AS [IsNull];
SELECT ISNULL(6, 61) AS [IsNotNull];
SELECT ISNUMERIC(10) AS [IsNumeric];
SELECT ISNUMERIC('WELCOME') AS [IsNotNumeric];

-- Create and populate Loan table
IF OBJECT_ID('dbo.Loan', 'U') IS NOT NULL DROP TABLE dbo.Loan;
CREATE TABLE dbo.Loan (
    LoanNumber INT IDENTITY(1000,1) PRIMARY KEY,
    CustomerFname VARCHAR(50),
    CustomerLname VARCHAR(50),
    PropertyAddress VARCHAR(150),
    City VARCHAR(150),
    State VARCHAR(50),
    BankruptcyAttorneyName VARCHAR(50),
    UPB MONEY,
    LoanDate DATETIME
);

INSERT INTO dbo.Loan (CustomerFname, CustomerLname, PropertyAddress, City, State, BankruptcyAttorneyName, UPB, LoanDate)
VALUES 
    ('Mr. Anand', 'Dasari', '1212 Main St.', 'Plano', 'TX', 'Jerry', 85000, '2012-01-01'),
    ('Mr. John', 'Nasari', '1215 Joseph St.', 'Garland', 'TX', 'Jerry', 95000, '2012-04-02'),
    ('Dr. Ali', 'Muwwakkil', '2375 True True St.', 'Atlanta', 'GA', 'Diesel', 115000, '2008-05-03'),
    ('Mr. John', 'Brown', '11532 Chain St.', 'SanFrancisco', 'CA', 'Mora', 350000, '2004-06-13'),
    ('Dr. Kishan', 'Johnson', '4625 Miller Rd.', 'Atlanta', 'GA', 'Diesel', 225000, '2002-08-09'),
    ('Mr. John', 'Jackson', '972 Flower Rd.', 'Dallas', 'TX', 'Jerry', 150000, '2012-03-01'),
    ('Sr. Ralph', 'Jenkins', '1518 Mission Ridge St.', 'SanFrancisco', 'CA', 'Mora', 650000, '2011-12-15'),
    ('Dr. John', 'Howard', '102 Washington', 'Dallas', 'TX', 'Jerry', 450000, '2010-04-05'),
    ('Mrs. Marsha', 'Tamrie', '1301 Solana', 'SanFrancisco', 'CA', 'Mora', 750000, '2000-07-01'),
    ('Mrs. Alexis', 'Gibson', '1111 Phillips Rd.', 'Atlanta', 'GA', 'Diesel', 99000, '2012-06-01');

-- Verify data
SELECT * FROM dbo.Loan;

-- Queries with system functions
SELECT LoanNumber, State, City, UPB, GETDATE() AS TODAYSDATE
FROM dbo.Loan;

SELECT LoanNumber, CustomerFname, CustomerLname, PropertyAddress, BankruptcyAttorneyName
FROM dbo.Loan
WHERE BankruptcyAttorneyName IS NOT NULL
ORDER BY BankruptcyAttorneyName ASC, CustomerLname DESC;

SELECT LoanNumber, State, City, CustomerFname
FROM dbo.Loan
WHERE State IN ('CA', 'TX', 'FL', 'NV', 'NM')
AND City IN ('Dallas', 'SanFrancisco', 'Oakland')
AND CustomerFname LIKE '%John';

SELECT DATEDIFF(DAY, LoanDate, GETDATE()) AS LOADDATE
FROM dbo.Loan;

SELECT TOP 1 State, AVG(UPB) AS AVERAGE
FROM dbo.Loan
GROUP BY State;

SELECT LoanNumber, BankruptcyAttorneyName, 30 - DATEDIFF(YEAR, LoanDate, GETDATE()) AS LOANDATEREMAING
FROM dbo.Loan;

SELECT SUBSTRING(CustomerFname, 1, CHARINDEX('.', CustomerFname) - 1) AS TITLE,
       CustomerFname, CustomerLname, City, State, DATEDIFF(YEAR, LoanDate, GETDATE()) AS MORETHANYEAR
FROM dbo.Loan
WHERE DATEDIFF(YEAR, LoanDate, GETDATE()) > 1;

SELECT SUM(UPB) AS TotalUPB FROM dbo.Loan;