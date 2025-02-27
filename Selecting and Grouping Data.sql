-- Name: Aquel Daley
-- Lesson: Selecting and Grouping Data
-- Date: 08/11/2022
-- Purpose: Create BBall_Stats table and perform grouping queries

-- Drop table if it exists
IF OBJECT_ID('dbo.BBall_Stats', 'U') IS NOT NULL DROP TABLE dbo.BBall_Stats;

-- Create BBall_Stats table
CREATE TABLE dbo.BBall_Stats (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(50) NOT NULL,
    PlayerNum INT NOT NULL,
    PlayerPosition VARCHAR(50) NOT NULL,
    Assist INT,
    Rebounds INT,
    GamesPlayed INT,
    Points INT,
    PlayersCoach VARCHAR(50) NOT NULL
);

-- Insert data
INSERT INTO dbo.BBall_Stats (PlayerID, PlayerName, PlayerNum, PlayerPosition, Assist, Rebounds, GamesPlayed, Points, PlayersCoach)
VALUES 
    (1, 'Ali', 2, 'Guard', 200, 70, 16, 43, 'Gary'),
    (2, 'Goku', 34, 'Forward', 150, 85, 50, 15, 'Bob'),
    (3, 'Vegeta', 50, 'Center', 20, 14, 90, 32, 'Steve'),
    (4, 'Aquel', 1, 'Guard', 160, 82, 77, 45, 'Garret'),
    (5, 'Luffy', 13, 'Forward', 40, 101, 63, 95, 'Gary'),
    (6, 'Zoro', 5, 'Center', 43, 32, 42, 66, 'Bob'),
    (7, 'Sanji', 3, 'Guard', 55, 41, 33, 80, 'Steve'),
    (8, 'Jinbe', 33, 'Forward', 61, 55, 19, 86, 'Gary'),
    (9, 'Yamato', 14, 'Center', 170, 65, 20, 55, 'Gary'),
    (10, 'Yuskue', 19, 'Guard', 140, 83, 30, 45, 'Steve'),
    (11, 'Hiei', 23, 'Forward', 75, 112, 25, 89, 'Steve'),
    (12, 'Kurama', 10, 'Center', 63, 133, 12, 110, 'Steve'),
    (13, 'Naruto', 6, 'Guard', 95, 143, 16, 103, 'Steve'),
    (14, 'Saskue', 18, 'Forward', 74, 112, 18, 111, 'Gary'),
    (15, 'Boruto', 0, 'Center', 13, 160, 26, 105, 'Steve');

-- Verify data
SELECT * FROM dbo.BBall_Stats;

-- Number of players by position
SELECT PlayerPosition, COUNT(*) AS NumberOfPlayers
FROM dbo.BBall_Stats
GROUP BY PlayerPosition;

-- Number of players by coach
SELECT PlayersCoach, COUNT(*) AS NumberOfPlayers
FROM dbo.BBall_Stats
GROUP BY PlayersCoach;

-- Most points scored per game by position
SELECT PlayerPosition, MAX(Points) AS MostPoints
FROM dbo.BBall_Stats
GROUP BY PlayerPosition;

-- Total rebounds by coach
SELECT PlayersCoach, SUM(Rebounds) AS TotalRebounds
FROM dbo.BBall_Stats
GROUP BY PlayersCoach;

-- Average assists by coach
SELECT PlayersCoach, AVG(Assist) AS AverageAssist
FROM dbo.BBall_Stats
GROUP BY PlayersCoach;

-- Average assists per game by position
SELECT PlayerPosition, AVG(Assist) AS AverageAssist
FROM dbo.BBall_Stats
GROUP BY PlayerPosition;

-- Total points by position
SELECT PlayerPosition, SUM(Points) AS TotalNumberOfPoints
FROM dbo.BBall_Stats
GROUP BY PlayerPosition;