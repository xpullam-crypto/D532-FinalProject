-- Author: Xavier Pullam
-- Since I am doing this project solo, this author applies to all below

DROP DATABASE IF EXISTS videogames;

-- Drops all tables if tables need to be reset but not whole database
-- SET foreign_key_checks = 0;
-- DROP TABLE IF EXISTS Years;
-- DROP TABLE IF EXISTS Countries;
-- DROP TABLE IF EXISTS Genres;
-- DROP TABLE IF EXISTS Platforms;
-- DROP TABLE IF EXISTS Esports;
-- DROP Table IF EXISTS Gaming;
-- DROP TABLE IF EXISTS Statistics;
-- SET foreign_key_checks = 1;

-- Creates the database to put tables in and sets to schema
CREATE DATABASE videogames;
USE videogames;

-- Load dataset to global_gaming_esports_2010_2025 table here

-- Creates and constrains the Years table
CREATE TABLE Years (
ID INT PRIMARY KEY AUTO_INCREMENT,
Year INT NOT NULL,
UNIQUE(Year)
);

-- Creates and constrains the Countries table
CREATE TABLE Countries (
ID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(30) NOT NULL,
Region VARCHAR(20),
UNIQUE(Name)
);

CREATE TABLE Genres (
ID INT PRIMARY KEY AUTO_INCREMENT,
Genre VARCHAR(20) NOT NULL,
UNIQUE(Genre)
);

-- Creates and constrains the Platforms table
CREATE TABLE Platforms (
ID INT PRIMARY KEY AUTO_INCREMENT,
Platform VARCHAR(15) NOT NULL,
UNIQUE(Platform)
);

-- Creates and constrains the Esports table
CREATE TABLE Esports (
ID INT PRIMARY KEY AUTO_INCREMENT,
YearID INT NOT NULL,
CountryID INT NOT NULL,
TournamentCount INT,
Viewers DOUBLE,
ProPlayerCount INT,
Revenue DOUBLE,
Prize DOUBLE,
CONSTRAINT FK_Esports_Countries FOREIGN KEY (CountryID) REFERENCES  Countries (ID),
CONSTRAINT FK_Esports_Years FOREIGN KEY (YearID) REFERENCES Years (ID)
);

-- Creates and constrains the Gaming table
CREATE TABLE Gaming (
ID INT PRIMARY KEY AUTO_INCREMENT,
YearID INT NOT NULL,
CountryID INT NOT NULL,
Companies INT,
Revenue DOUBLE,
TopGenreID INT NOT NULL,
TopPlatformID INT NOT NULL,
ActivePlayers DOUBLE,
AverageSpending DOUBLE,
CONSTRAINT FK_Gaming_Countries FOREIGN KEY (CountryID) REFERENCES  Countries (ID),
CONSTRAINT FK_Gaming_Years FOREIGN KEY (YearID) REFERENCES Years (ID),
CONSTRAINT FK_Gaming_Genres FOREIGN KEY (TopGenreID) REFERENCES Genres (ID),
CONSTRAINT FK_Gaming_Platforms FOREIGN KEY (TopPlatformID) REFERENCES Platforms (ID)
);


-- Creates and constrains the Statistics table
CREATE TABLE Statistics (
ID INT PRIMARY KEY AUTO_INCREMENT,
YearID INT NOT NULL,
CountryID INT NOT NULL,
InternetPenetration DOUBLE,
AvgLatency DOUBLE,
ARVR DOUBLE,
StreamingInfluence DOUBLE,
CovidImpact DOUBLE,
FemaleGamer DOUBLE,
MobileGaming DOUBLE,
CONSTRAINT FK_Statistics_Countries FOREIGN KEY (CountryID) REFERENCES  Countries (ID),
CONSTRAINT FK_Statistics_Years FOREIGN KEY (YearID) REFERENCES Years (ID)
);

-- Add data to individual fields
INSERT INTO years (Year)
SELECT DISTINCT(Year)
FROM global_gaming_esports_2010_2025;

INSERT INTO countries (Name,Region)
SELECT DISTINCT Country, Region
FROM global_gaming_esports_2010_2025;

INSERT INTO genres (Genre)
SELECT DISTINCT Top_Genre
FROM global_gaming_esports_2010_2025;

INSERT INTO platforms (platform)
SELECT DISTINCT Top_Platform
FROM global_gaming_esports_2010_2025;

-- Overwrite for easier merging

UPDATE global_gaming_esports_2010_2025, years
SET global_gaming_esports_2010_2025.Year = years.ID
WHERE global_gaming_esports_2010_2025.Year = years.Year;

UPDATE global_gaming_esports_2010_2025, countries
SET global_gaming_esports_2010_2025.Country = countries.ID
WHERE global_gaming_esports_2010_2025.Country = countries.Name;

UPDATE global_gaming_esports_2010_2025, genres
SET global_gaming_esports_2010_2025.Top_Genre = genres.ID
WHERE global_gaming_esports_2010_2025.Top_Genre = genres.Genre;

UPDATE global_gaming_esports_2010_2025, platforms
SET global_gaming_esports_2010_2025.Top_Platform = platforms.ID
WHERE global_gaming_esports_2010_2025.Top_Platform = platforms.Platform;

-- Finish adding all data
INSERT INTO esports (YearID,CountryID,TournamentCount,Viewers,ProPlayerCount,Revenue,Prize)
SELECT Year, Country, Esports_Tournaments_Count, Esports_Viewers_Million,Pro_Players_Count,Esports_Revenue_MillionUSD,Esports_PrizePool_MillionUSD
FROM global_gaming_esports_2010_2025;

INSERT INTO gaming (YearID,CountryID,Companies,Revenue,TopGenreID,TopPlatformID,ActivePlayers,AverageSpending)
SELECT Year, Country, Gaming_Companies_Count, Gaming_Revenue_BillionUSD,Top_Genre,Top_Platform,Active_Players_Million,Avg_Spending_USD
FROM global_gaming_esports_2010_2025;

INSERT INTO statistics (YearID,CountryID,InternetPenetration,AvgLatency,ARVR,StreamingInfluence,CovidImpact,FemaleGamer,MobileGaming)
SELECT Year, Country, Internet_Penetration_Percent, Avg_Latency_ms, AR_VR_Adoption_Index, Streaming_Influence_Index, Covid_Impact_Index, Female_Gamer_Percent, Mobile_Gaming_Share
FROM global_gaming_esports_2010_2025;

-- Drop the original dataset as it is no longer needed
DROP TABLE global_gaming_esports_2010_2025;

-- Insert another country and some data for it
INSERT INTO countries (Name,Region)
VALUES ("Micronesia","Oceania");

-- Adds new data to gaming table for Micronesia
INSERT INTO gaming (YearID, CountryID, Companies, Revenue, TopGenreID, TopPlatformID, ActivePlayers,AverageSpending)
VALUES 
	(7,26,1,100,3,1,2.1,NULL),
    (8,26,2,200,6,2,8,60);

-- Returns the maximum revenue by country
SELECT MAX(Revenue) As "Maximum Revenue", Name, Region
FROM gaming g
INNER JOIN countries c
ON c.ID = g.CountryID
GROUP BY Name;

-- Returns the average viewers by year (important for advertising)
SELECT Year, AVG(Viewers) As "Average Viewers in Millions"
FROM esports e
INNER JOIN years y
ON y.ID = e.YearID
GROUP BY Year;