-- Name: Aquel Daley
-- Lesson: Working with Variables
-- Date: 08/16/2022
-- Purpose: Create Flights and HospitalStaff tables, use variables for analysis

-- Drop tables if they exist
IF OBJECT_ID('dbo.Flights', 'U') IS NOT NULL DROP TABLE dbo.Flights;
IF OBJECT_ID('dbo.HospitalStaff', 'U') IS NOT NULL DROP TABLE dbo.HospitalStaff;

-- Create Flights table
CREATE TABLE dbo.Flights (
    flightID INT PRIMARY KEY IDENTITY(100,1),
    flightDateTime DATETIME,
    flightDepartureCity VARCHAR(50),
    flightDestinationCity VARCHAR(50),
    ontime INT CHECK (ontime IN (0, 1))
);

-- Insert data into Flights
INSERT INTO dbo.Flights (flightDateTime, flightDepartureCity, flightDestinationCity, ontime)
VALUES 
    ('2012-01-01', 'Dallas-Texas', 'L.A.', 1),
    ('2012-01-02', 'Austin-Texas', 'New York', 1),
    ('2012-01-03', 'Houston-Texas', 'New Jersey', 0),
    ('2012-01-04', 'San Antonio-Texas', 'Mesquite', 1),
    ('2012-01-05', 'Lewisville-Texas', 'Albany', 0),
    ('2012-01-06', 'Orlando-Florida', 'Atlanta', 1),
    ('2012-01-07', 'Chicago-Illinois', 'Oklahoma City', 1),
    ('2012-01-08', 'New Orleans-Louisiana', 'Memphis', 0),
    ('2012-01-09', 'Miami-Florida', 'Charlotte', 1),
    ('2012-01-10', 'Sacramento-California', 'San Francisco', 1);

-- Create HospitalStaff table
CREATE TABLE dbo.HospitalStaff (
    EmpID INT IDENTITY(1000,1) PRIMARY KEY,
    NameJob VARCHAR(50),
    HireDate DATETIME,
    Location VARCHAR(150)
);

-- Insert data into HospitalStaff
INSERT INTO dbo.HospitalStaff (NameJob, HireDate, Location)
VALUES 
    ('Dr. Johnson_Doctor', '2012-01-01', 'Dallas-Texas'),
    ('Nurse Jackie_Nurse', '2011-10-15', 'Mesquite-Texas'),
    ('Anne_Nurse Assistant', '2010-11-01', 'Denton-Texas'),
    ('Dr. Jackson_Doctor', '2008-04-02', 'Irving-Texas'),
    ('Jamie_Nurse', '2005-02-15', 'San Francisco-California'),
    ('Aesha_Nurse Assistant', '2003-06-30', 'Oakland-California'),
    ('Dr. Ali_Doctor', '1999-07-04', 'L.A.-California'),
    ('Evelyn_Nurse', '2007-01-07', 'Fresno-California'),
    ('James Worthy_Nurse Assistant', '2012-01-01', 'Orlando-Florida'),
    ('Anand_Doctor', '2012-03-01', 'Miami-Florida');

-- Verify data
SELECT * FROM dbo.Flights;
SELECT * FROM dbo.HospitalStaff;

-- Flights variable queries
DECLARE @no_of_lateFlights INT;
SELECT @no_of_lateFlights = COUNT(*)
FROM dbo.Flights
WHERE ontime = 0;
SELECT @no_of_lateFlights AS 'No of Late Flights';

DECLARE @totalamnt_of_lateFlights INT;
SET @totalamnt_of_lateFlights = 1029 * 3; -- Assuming 1029 as avg cost per late flight
SELECT @totalamnt_of_lateFlights AS 'Total Amount of Late Flights';

DECLARE @profitAfterlateFlight INT;
SET @profitAfterlateFlight = 45000 - 3087; -- Assuming 45000 as base profit
SELECT @profitAfterlateFlight AS 'Profit After Loss from Late Flights';

DECLARE @future_flight DATETIME;
SELECT @future_flight = DATEADD(YEAR, 10, MIN(flightDateTime))
FROM dbo.Flights;
SELECT @future_flight AS '10 Years from Earliest Flight';

DECLARE @latestDate INT;
SELECT @latestDate = DAY(MAX(flightDateTime))
FROM dbo.Flights;
SELECT @latestDate AS 'Day of Latest Flight';

-- Flights table variables
DECLARE @Table1 TABLE (departureState VARCHAR(50), departureCity VARCHAR(50), destinationCity VARCHAR(50), ontime INT);
INSERT INTO @Table1
SELECT SUBSTRING(flightDepartureCity, CHARINDEX('-', flightDepartureCity) + 1, LEN(flightDepartureCity) - CHARINDEX('-', flightDepartureCity)) AS departureState,
       LEFT(flightDepartureCity, CHARINDEX('-', flightDepartureCity) - 1) AS departureCity,
       flightDestinationCity, ontime
FROM dbo.Flights;
SELECT * FROM @Table1;

DECLARE @Table2 TABLE (flightID INT PRIMARY KEY, flightDateTime DATETIME, flightDepartureCity VARCHAR(50), flightDestinationCity VARCHAR(50), ontime INT);
INSERT INTO @Table2
SELECT flightID, flightDateTime, flightDepartureCity, flightDestinationCity, ontime
FROM dbo.Flights
WHERE ontime = 1;
SELECT * FROM @Table2;

DECLARE @Table3 TABLE (flightID INT, flightDateTime DATETIME, departureState VARCHAR(50), departureCity VARCHAR(50), flightDestinationCity VARCHAR(50), ontime INT);
INSERT INTO @Table3
SELECT flightID, flightDateTime,
       SUBSTRING(flightDepartureCity, CHARINDEX('-', flightDepartureCity) + 1, LEN(flightDepartureCity) - CHARINDEX('-', flightDepartureCity)) AS departureState,
       LEFT(flightDepartureCity, CHARINDEX('-', flightDepartureCity) - 1) AS departureCity,
       flightDestinationCity, ontime
FROM dbo.Flights
WHERE SUBSTRING(flightDepartureCity, CHARINDEX('-', flightDepartureCity) + 1, LEN(flightDepartureCity) - CHARINDEX('-', flightDepartureCity)) <> 'Texas';
SELECT * FROM @Table3;

-- HospitalStaff variable queries
DECLARE @three_yrs_plus_from_hireDate INT;
SELECT @three_yrs_plus_from_hireDate = COUNT(*)
FROM dbo.HospitalStaff
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 3;
SELECT @three_yrs_plus_from_hireDate AS 'No of Employees Working 3+ Years';

DECLARE @employeeTx INT;
SELECT @employeeTx = COUNT(NameJob)
FROM dbo.HospitalStaff
WHERE Location LIKE '%Texas%';
SELECT @employeeTx AS 'No of Texas Employees';

DECLARE @TexasDoctors INT;
SELECT @TexasDoctors = COUNT(NameJob)
FROM dbo.HospitalStaff
WHERE Location LIKE '%Texas%' AND NameJob LIKE '%Doctor%';
SELECT @TexasDoctors AS 'No of Doctors in Texas';

-- HospitalStaff table variables
DECLARE @Table7 TABLE (name VARCHAR(50), job VARCHAR(50), hiredate DATETIME, city VARCHAR(50), state VARCHAR(50));
INSERT INTO @Table7
SELECT LEFT(NameJob, CHARINDEX('_', NameJob) - 1) AS name,
       SUBSTRING(NameJob, CHARINDEX('_', NameJob) + 1, LEN(NameJob) - CHARINDEX('_', NameJob)) AS job,
       HireDate,
       LEFT(Location, CHARINDEX('-', Location) - 1) AS city,
       SUBSTRING(Location, CHARINDEX('-', Location) + 1, LEN(Location) - CHARINDEX('-', Location)) AS state
FROM dbo.HospitalStaff;
SELECT * FROM @Table7;

DECLARE @Table12 TABLE (namejob VARCHAR(50), dateyear INT, datemonth INT, dateday INT);
INSERT INTO @Table12
SELECT NameJob, YEAR(HireDate), MONTH(HireDate), DAY(HireDate)
FROM dbo.HospitalStaff;
SELECT * FROM @Table12;