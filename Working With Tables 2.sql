-- Name: Aquel Daley
-- Lesson: Working With Tables
-- Date: 08/10/2022
-- Purpose: Create and populate Players and Coaches tables with basic filtering and backups
-- Target: MySQL

-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Coaches;

-- Create Players table with constraints
CREATE TABLE Players (
    playerid INT PRIMARY KEY,
    position VARCHAR(50) NOT NULL,
    jerseynumber INT NOT NULL,
    startdate DATETIME NOT NULL
);

-- Create Coaches table with constraints
CREATE TABLE Coaches (
    coachid INT PRIMARY KEY,
    coachname VARCHAR(50) NOT NULL,
    coachtype VARCHAR(50) NOT NULL,
    startdate DATETIME NOT NULL
);

-- Insert initial data into Players
INSERT INTO Players (playerid, position, jerseynumber, startdate)
VALUES (1, 'Running Back', 22, '2012-01-01');

-- Insert initial data into Coaches
INSERT INTO Coaches (coachid, coachname, coachtype, startdate)
VALUES (1, 'John Starks', 'RunningBackCoach', '2012-01-01');

-- Insert additional Players data
INSERT INTO Players (playerid, position, jerseynumber, startdate)
VALUES 
    (2, 'Quarter Back', 52, '2021-01-13'),
    (3, 'Full Back', 30, '2022-01-16'),
    (4, 'Line Back', 26, '2022-01-15'),
    (5, 'Full Back', 24, '2016-01-05'),
    (6, 'Tight End', 14, '2016-01-06'),
    (7, 'Tight End', 18, '2018-01-19'),
    (8, 'Wide Receiver', 24, '2015-01-12'),
    (9, 'Defensive End', 15, '2019-01-11'),
    (10, 'Defensive Back', 22, '2019-01-12'),
    (11, 'Running Back', 6, '2020-01-15');

-- Insert additional Coaches data
INSERT INTO Coaches (coachid, coachname, coachtype, startdate)
VALUES 
    (2, 'Aquel Daley', 'QuarterBack', '2021-01-13'),
    (3, 'Monkey D', 'Full Back', '2022-01-16'),
    (4, 'Roc Lee', 'Full Back', '2016-01-05'),
    (5, 'Saskue Uchiha', 'Tight End', '2016-01-06'),
    (6, 'Naruto Uzumaki', 'Tight End', '2018-01-19'),
    (7, 'Son Goku', 'Wide Receiver', '2015-01-12'),
    (8, 'Prince Vegeta', 'Defensive End', '2019-01-11'),
    (9, 'Yusuke Urameshi', 'Defensive Back', '2019-01-12'),
    (10, 'Yoko Kurama', 'Running Back', '2020-01-15');

-- Query Players with jersey numbers between 20 and 29
SELECT * FROM Players WHERE jerseynumber BETWEEN 20 AND 29;

-- Query Coaches with ID < 5
SELECT * FROM Coaches WHERE coachid < 5;

-- Query Players starting in 2022
SELECT * FROM Players WHERE startdate BETWEEN '2022-01-01' AND '2022-12-20';

-- Query Coaches starting in 2021
SELECT * FROM Coaches WHERE startdate BETWEEN '2021-01-01' AND '2021-12-31';

-- Query Players with ID > 5
SELECT * FROM Players WHERE playerid > 5;

-- Query Running Backs
SELECT * FROM Players WHERE position = 'Running Back';

-- Query Quarterback Coaches
SELECT * FROM Coaches WHERE coachtype = 'QuarterBack';

-- Create backup tables (MySQL uses CREATE TABLE ... SELECT)
CREATE TABLE Coaches_backup AS SELECT * FROM Coaches;
CREATE TABLE Players_backup AS SELECT * FROM Players;

-- Verify backups
SELECT * FROM Coaches_backup;
SELECT * FROM Players_backup;