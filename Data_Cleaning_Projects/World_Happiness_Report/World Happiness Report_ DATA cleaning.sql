-- World Happiness Report : DATA Cleaning Project --

-- Project Objectives --
	-- 1) Identify common columns across all years
    -- 2) Clean and Standardize Each table Individually
    -- 3) Drop columns that are inconsistent (ie not included in other tables)
    -- 4) Create a common format for all the tables
    -- 5) Join All / Union All in one single table
    
    
-- COLUMN MAPPING --
-- | Unified Column Name             | 2015                          | 2016                               | 2017                          | 2018                         | 2019                         |
-- | ------------------------------- | ----------------------------- | ---------------------------------- | ----------------------------- | ---------------------------- | ---------------------------- |
-- | `Country`                       | Country                       | Country                            | Country                       | country or region            | country or region            |
-- | `Region`                        | Region                        | Region                             | *Not Available*               | *Not Available*              | *Not Available*              |
-- | `Happiness Rank`                | Happiness Rank                | Happiness Rank                     | Happiness Rank                | Overall Rank                 | Overall Rank                 |
-- | `Happiness Score`               | Happiness Score               | Happiness Score                    | Happiness Score               | Score                        | Score                        |
-- | `Economy (GDP per Capita)`      | Economy (GDP per capita)      | Economy (GDP per capita)           | Economy (GDP per capita)      | GDP per Capita               | GDP per Capita               |
-- | `Family / Social Support`       | Family                        | Family                             | Family                        | Social Support               | Social Support               |
-- | `Health (Life Expectancy)`      | Health (life expectancy)      | Health (life expectancy)           | Health (life expectancy)      | Health Life Expectancy       | Health Life Expectancy       |
-- | `Freedom`                       | Freedom                       | Freedom                            | Freedom                       | Freedom to make life choices | Freedom to make life choices |
-- | `Trust (Government Corruption)` | Trust (government corruption) | Trust (government corruption)      | Trust (government corruption) | Perceptions of Corruptions   | Perceptions of Corruptions   |
-- | `Generosity`                    | Generosity                    | Generosity                         | Generosity                    | Generosity                   | Generosity                   |
-- | `Dystopia Residual`             | Dystopia Residual             | Dystopia Residual                  | Dystopia Residual             | *Not Available*              | *Not Available*              |
-- | `Standard Error / Confidence`   | Standard Error                | Lower & Upper Confidence Intervals | Whisker High / Whisker Low    | *Not Available*              | *Not Available*              |

-- Thought Process : 
-- 1) We can fill in the Region for the tables with country column but no Region column.
-- 2) Rename Columns so that they will be uniformed
-- 3) Drop Columns that cannot be supplemented by current data at hand (ie dystopia residual)
-- 4) Drop columns that cannot be compared directly to one another (ie Standard error, Lower & Upper Confidence Intervals, Whisker High / Whisker Low ) 
-- 5) Add a Year column to identify when is the data gathered


-- FOR YEAR 2015 -- 
-- Let us first create a duplicate for our raw data so that the raw will be safe just in case errors occur down the line --

SELECT * FROM `2015`;

CREATE TABLE clean_2015 LIKE `2015`;

INSERT clean_2015 SELECT *
FROM `2015`;

SELECT * 
FROM clean_2015;

-- STEP 1: CHECKING FOR DUPLICATE ENTRIES --
-- Using the row_number function, we can partition across all rows the entries in the table, row_num > 1 indicates that there are duplicate entries in the table and we have to fix that --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2015;

-- Converting this select statement into CTE for more complex query --

WITH cte_2015 AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2015
)
SELECT *
FROM cte_2015
WHERE row_num > 1;

-- No duplicate entries found in this table, we can proceed to standardizing the data -- 

-- STEP 2: STANDARDIZING THE DATA --
-- Renaming columns --
-- we will rename all column headers first so that it will be easier to write and will not interfere with the queries --

ALTER TABLE clean_2015
CHANGE `Happiness Rank` happiness_rank INT;

ALTER TABLE clean_2015
CHANGE `Happiness Score` happiness_score DECIMAL(10, 3);

ALTER TABLE clean_2015
CHANGE `Economy (GDP per Capita)` Economy DECIMAL(10, 5);

ALTER TABLE clean_2015
CHANGE `Health (Life Expectancy)` Health DECIMAL(10, 5);

ALTER TABLE clean_2015
CHANGE `Trust (Government Corruption)` Trust DECIMAL(10, 5);

ALTER TABLE clean_2015
CHANGE `Freedom` Freedom DECIMAL(10, 5);

ALTER TABLE clean_2015
CHANGE `Family` Family DECIMAL(10, 5);

-- I set up the happiness_score, Economy, Health, and Trust as decimal to retain the decimals and not INT --
-- because if we change it into INT, it will round it off to a whole number and we don't want that when presenting scores --

-- STEP 3: Dropping Unnecessary Columns --
-- Since we established from the table that Standard error, Lower & Upper Confidence Intervals, Whisker High / Whisker Low cannot be compared to one another --
-- and dystopia residual cannot be supplemented from the current data at hand, we will drop these tables to standardize the data --

ALTER TABLE clean_2015
DROP COLUMN `Standard Error`;

ALTER TABLE clean_2015
DROP COLUMN `Dystopia Residual`;


-- Adding YEAR column into the table --
-- We do this so that we can Identify what year is the data from when we merge all the data into one big table -- 
ALTER TABLE clean_2015
ADD COLUMN YEAR INT;

UPDATE clean_2015
SET YEAR = 2015; 

SELECT *
FROM clean_2015;

-- Since we cleaned 2015, this will be our standard for the following years that we will clean
-- END OF 2015 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- FOR YEAR 2016 -- 

SELECT *
FROM `2016`;

CREATE TABLE clean_2016 LIKE `2016`;

INSERT clean_2016 SELECT *
FROM `2016`;

SELECT * 
FROM clean_2016;

-- STEP 1: CHECKING FOR DUPLICATE ENTRIES --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2016;

-- Converting this select statement into CTE for more complex query --

WITH cte_2016 AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2016
)
SELECT *
FROM cte_2016
WHERE row_num > 1;

-- STEP 2: STANDARDIZING THE DATA --

-- Renaming columns --
ALTER TABLE clean_2016
CHANGE `Happiness Rank` happiness_rank INT;

ALTER TABLE clean_2016
CHANGE `Happiness Score` happiness_score DECIMAL(10, 3);

ALTER TABLE clean_2016
CHANGE `Economy (GDP per Capita)` Economy DECIMAL(10, 5);

ALTER TABLE clean_2016
CHANGE `Health (Life Expectancy)` Health DECIMAL(10, 5);

ALTER TABLE clean_2016
CHANGE `Trust (Government Corruption)` Trust DECIMAL(10, 5);

ALTER TABLE clean_2016
CHANGE `Freedom` Freedom DECIMAL(10, 5);

ALTER TABLE clean_2016
CHANGE `Family` Family DECIMAL(10, 5);

-- STEP 3: Dropping Unnecessary Columns --

SELECT *
FROM clean_2016; 

ALTER TABLE clean_2016
DROP column `Lower Confidence Interval`;

ALTER TABLE clean_2016
DROP column `Upper Confidence Interval`;

ALTER TABLE clean_2016
DROP column `Dystopia Residual`;

-- Adding YEAR column into the table --
ALTER TABLE clean_2016
ADD COLUMN YEAR INT;

UPDATE clean_2016
SET YEAR = 2016; 
-- END OF 2016 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FOR YEAR 2017 --

SELECT *
FROM `2017`; 

CREATE TABLE clean_2017 LIKE `2017`;

INSERT clean_2017 SELECT *
FROM `2017`;

SELECT * 
FROM clean_2017;

-- STEP 1: CHECKING FOR DUPLICATE, BLANKS, AND NULL ENTRIES --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2017;

-- Converting this select statement into CTE for more complex query --
-- Finding out if there are nulls or blanks in the table
WITH cte_2017 AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2017
)
SELECT *
FROM cte_2017
WHERE Region is NULL OR Region = '';

-- STEP 2: STANDARDIZING THE DATA --

-- Renaming columns --
SELECT *
FROM clean_2017; 

ALTER TABLE clean_2017
CHANGE `Happiness.Rank` happiness_rank INT;

ALTER TABLE clean_2017
CHANGE `Happiness.Score` happiness_score DECIMAL(10, 3);

ALTER TABLE clean_2017
CHANGE `Economy..GDP.per.Capita.` Economy DECIMAL(10, 5);

ALTER TABLE clean_2017
CHANGE `Health..Life.Expectancy.` Health DECIMAL(10, 5);

ALTER TABLE clean_2017
CHANGE `Trust..Government.Corruption.` Trust DECIMAL(10, 5);

ALTER TABLE clean_2017
CHANGE `Freedom` Freedom DECIMAL(10, 5);

ALTER TABLE clean_2017
CHANGE `Family` Family DECIMAL(10, 5);


-- STEP 3: Dropping Unnecessary Columns --

ALTER TABLE clean_2017
DROP column `Whisker.high`;

ALTER TABLE clean_2017
DROP column `Whisker.low`;

ALTER TABLE clean_2017
DROP column `Dystopia.Residual`;

-- Adding YEAR column into the table --
ALTER TABLE clean_2017
ADD COLUMN YEAR INT;

UPDATE clean_2017
SET YEAR = 2017; 

-- Adding Region column into the table--
-- Since 2017 does not have a column for region, we want to standardize it the same as the previous years that's why we will add this column--

ALTER TABLE clean_2017
ADD COLUMN Region TEXT;

-- By using JOINS, we can make it so that the region for the year 2016 can be used to supplement the missing values for the region column in 2017 --
UPDATE clean_2017 as c17
JOIN clean_2016 as c16
	ON c17.country = c16.country
SET c17.region = c16.region;

-- Inserting Data Into Blank and Null--
SELECT *
FROM clean_2017;

UPDATE clean_2017
SET Region = 'Central Africa'
WHERE Country LIKE 'Central African Republic';

UPDATE clean_2017
SET Region = 'Eastern Asia'
WHERE Country LIKE 'Hong Kong S.A.R., China';

UPDATE clean_2017
SET Country = 'Hong Kong'
WHERE Country LIKE 'Hong Kong S.A.R., China';

UPDATE clean_2017
SET Region = 'Southern Africa'
WHERE Country LIKE 'Lesotho';

UPDATE clean_2017
SET Region = 'Eastern Africa'
WHERE Country LIKE 'Mozambique';

UPDATE clean_2017
SET Region = 'Eastern Asia'
WHERE Country LIKE 'Taiwan Province of China';

UPDATE clean_2017
SET Country = 'Taiwan'
WHERE Country LIKE 'Taiwan Province of China';


SELECT *
FROM clean_2017; 
-- END of 2017 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FOR 2018--
SELECT *
FROM `2018`;

CREATE TABLE clean_2018 LIKE `2018`;

INSERT clean_2018 SELECT *
FROM `2018`;

SELECT * 
FROM clean_2018;

-- STEP 1: CHECKING FOR DUPLICATE, BLANKS, AND NULL ENTRIES --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2018;

-- Converting this select statement into CTE for more complex query --

WITH cte_2018 AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2018
)
SELECT *
FROM cte_2018
WHERE Region IS NULL or Region ='';

-- STEP 2: STANDARDIZING THE DATA --

-- Renaming columns --
SELECT *
FROM clean_2018; 

ALTER TABLE clean_2018
CHANGE `Overall rank` happiness_rank INT;

ALTER TABLE clean_2018
CHANGE `Score` happiness_score DECIMAL(10, 3);

ALTER TABLE clean_2018
CHANGE `GDP per capita` Economy DECIMAL(10, 5);

ALTER TABLE clean_2018
CHANGE `Healthy life expectancy` Health DECIMAL(10, 5);

ALTER TABLE clean_2018
CHANGE `Perceptions of corruption` Trust DECIMAL(10, 5);

ALTER TABLE clean_2018
CHANGE `Social support` Family DECIMAL(10, 5);

ALTER TABLE clean_2018
CHANGE `Country or region` Country TEXT;

ALTER TABLE clean_2018
CHANGE `Freedom to make life choices` Freedom DECIMAL(10, 5);

-- STEP 3: Adding Necessary Columns --

-- Adding YEAR column into the table --
ALTER TABLE clean_2018
ADD COLUMN YEAR INT;

UPDATE clean_2018
SET YEAR = 2018; 

SELECT *
FROM clean_2018; 

-- Adding Region column into the table --
ALTER TABLE clean_2018
ADD COLUMN Region Text;

UPDATE clean_2018 c18
JOIN clean_2017 c17
	ON c18.country = c17.country
SET c18.region = c17.region;


-- Inserting Data Into Blank and Null--
SELECT *
FROM clean_2018;

UPDATE clean_2018
SET Region = 'Southeast Asia'
WHERE Country LIKE 'Laos';

UPDATE clean_2018
SET Region = 'Southern Europe'
WHERE Country LIKE 'Northern Cyprus';

UPDATE clean_2018
SET Region = 'Caribbean'
WHERE Country LIKE 'Trinidad & Tobago';

-- END of 2018-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FOR 2019--
SELECT *
FROM `2019`;

CREATE TABLE clean_2019 LIKE `2019`;

INSERT clean_2019 SELECT *
FROM `2019`;

SELECT * 
FROM clean_2019;

-- STEP 1: CHECKING FOR DUPLICATE, BLANKS, AND NULL ENTRIES --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2019;

-- Converting this select statement into CTE for more complex query --

WITH cte_2019 AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Country, Region, happiness_rank, happiness_score, Economy, Family, Health , Freedom, Trust , Generosity) AS row_num
FROM clean_2019
)
SELECT *
FROM cte_2019
WHERE Region IS NULL or Region ='';

-- STEP 2: STANDARDIZING THE DATA --

-- Renaming columns --
SELECT *
FROM clean_2019; 

ALTER TABLE clean_2019
CHANGE `Overall rank` happiness_rank INT;

ALTER TABLE clean_2019
CHANGE `Score` happiness_score DECIMAL(10, 3);

ALTER TABLE clean_2019
CHANGE `GDP per capita` Economy DECIMAL(10, 5);

ALTER TABLE clean_2019
CHANGE `Healthy life expectancy` Health DECIMAL(10, 5);

ALTER TABLE clean_2019
CHANGE `Perceptions of corruption` Trust DECIMAL(10, 5);

ALTER TABLE clean_2019
CHANGE `Social support` Family DECIMAL(10, 5);

ALTER TABLE clean_2019
CHANGE `Country or region` Country TEXT;

ALTER TABLE clean_2019
CHANGE `Freedom to make life choices` Freedom DECIMAL(10, 5);

-- STEP 3: Adding Necessary Columns --

-- Adding YEAR column into the table --
ALTER TABLE clean_2019
ADD COLUMN YEAR INT;

UPDATE clean_2019
SET YEAR = 2019; 

SELECT *
FROM clean_2019; 

-- Adding Region column into the table --
ALTER TABLE clean_2019
ADD COLUMN Region Text;

UPDATE clean_2019 c19
JOIN clean_2018 c18
	ON c19.country = c18.country
SET c19.region = c18.region;

-- Inserting Data Into Blank and Null--
SELECT *
FROM clean_2019;

UPDATE clean_2019
SET Region = 'Eastern Africa'
WHERE Country LIKE 'Comoros';

UPDATE clean_2019
SET Region = 'Western Africa'
WHERE Country LIKE 'Gambia';

UPDATE clean_2019
SET Region = 'Southern Europe'
WHERE Country LIKE 'North Macedonia';

UPDATE clean_2019
SET Region = 'Southern Africa'
WHERE Country LIKE 'Swaziland';

UPDATE clean_2019
SET Region = 'Western Asia'
WHERE Country LIKE 'United Arab Emirates';
-- End of 2019 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STEP 4: Combining Into One Table --
-- Now that we have finished cleaning the tables individually, we will combine them in one table --

CREATE TABLE clean_all_years (
Country TEXT,
Region TEXT,
Happiness_Rank INT,
Happiness_Score DECIMAL(10,5),
Economy DECIMAL(10,5),
Family DECIMAL(10,5),
Health DECIMAL(10,5),
Freedom DECIMAL(10,5),
Generosity DECIMAL(10,3),
Trust DECIMAL(10,5),
YEAR INT
);


SELECT * 
FROM clean_all_years;


INSERT INTO clean_all_years (Country, Region, Happiness_Rank, Happiness_Score, Economy, Family, Health, Freedom, Generosity, Trust, YEAR)

SELECT 
	Country, 
    Region, 
    happiness_rank, 
    happiness_score, 
    Economy, 
    Family, 
    Health, 
    Freedom, 
    Generosity, 
    Trust, 
    YEAR 
FROM clean_2015

UNION ALL

SELECT Country, 
	Region, 
	happiness_rank, 
	happiness_score, 
	Economy, 
	Family, 
	Health, 
	Freedom, 
	Generosity, 
	Trust, 
	YEAR 
FROM clean_2016

UNION ALL

SELECT 
	Country,
    Region, 
    happiness_rank, 
    happiness_score, 
    Economy, 
    Family, 
    Health, 
    Freedom, 
    Generosity, 
    Trust, 
    YEAR 
FROM clean_2017

UNION ALL

SELECT 
	Country, 
    Region, 
    happiness_rank, 
    happiness_score, 
    Economy, 
    Family, 
    Health, 
    Freedom, 
    Generosity, 
    Trust, 
    YEAR 
FROM clean_2018

UNION ALL

SELECT 
	Country, 
    Region, 
    happiness_rank, 
    happiness_score, 
    Economy, 
    Family, 
    Health, 
    Freedom, 
    Generosity, 
    Trust, 
    YEAR 
FROM clean_2019;

