-- DATA CLEANING PROJECT: WORLD_LAYOFFS

-- IN THIS PROJECT WILL SHOWCASE THE FOLLOWING THINGS DONE TO CLEAN THE DATA

-- THINGS TO DO --
-- 1) REMOVE DUPLICATES
-- 2) STANDARDIZE THE DATA
-- 3) NULL VALUES OR BLANK VALUES
-- 4) REMOVE ANY COLUMNS

select *
FROM layoffs;

-- CREATE DUPLICATE TABLE IN CASE THERE IS A PROBLEM DOWN THE LINE --

CREATE TABLE layoffs_staging
LIKE layoffs;

select *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1) REMOVE DUPLICATES -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Identify which companies first have duplicate entries by finding the row number on every row --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- converting this query to CTE to do more complex queries --

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- once we  Identified which companies have duplicate entries, we can delete them from the table-- 

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;
-- the result of this query says "the target table duplicate_cte of the DELETE is not updatable" --
-- what workaround we can do is to create another table that will not include the duplicate entries as such:
-- CREATE ANOTHER TABLE BY RIGHT CLICKING ON TABLES > COPY TO CLIPBOARD > CREATE STATEMENT -- 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- CHANGE THE NAME OF THE TABLE TO 'layoffs_staging3' so we can Identify that this is the most update table
-- INSERT row_num INTO THE TABLE SO THAT ROW_NUM WILL BE THE FILTER IDENTIFIER OF THE TABLE--

SELECT *
FROM layoffs_staging2;

-- INSERT THE INFORMATION INTO THE SECOND STAGING TABLE -- 
INSERT layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- NOW THAT WE CREATED A TABLE THAT HAS AN IDENTIFIER WHICH ROWS HAVE DUPLICATE ENTRY, NOW WE CAN REMOVE THEM FROM THE TABLE--
SELECT *
FROM layoffs_staging2
WHERE row_num >1;

-- PROMPT A SELECT QUERIE FIRST TO IDENTIFY WHAT TO DELETE AND CHANGE SELECT TO DELETE

DELETE
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;


-- STEP 2: STANDARDIZING THE DATA --
-- in this step, we are using the TRIM function to remove the white spaces that are before the strings in the tables, this makes the table neat looking visually--
UPDATE layoffs_staging2
SET
	company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage = TRIM(stage),
    country = TRIM(country);
    
-- CHECKING FOR SIMILAR NAMES BUT DIFFERENT FORMATS --
-- we use the the DISTINCT function to identify what rows have the same entries but different format or shape--
-- we do this to standardize the data and for the data to not have multiple returns even if they belong to the same category--

SELECT DISTINCT(industry)
FROM  layoffs_staging2;
-- here we can see that there are entries that are similar but have different format or typing namely CRYPTO or CRYPTO % --
-- we want to change that into the same category so that when we filter it they will belong together--

SELECT DISTINCT(country)
FROM  layoffs_staging2;
-- Similarly in this column country, United States has another formatting Which is (United States.) which has a period at the end--
-- we also want to change that into the same category so that when we filter it they will belong together --

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto %';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE industry LIKE 'United States%';

-- CHANGING THE DATE FORMAT --
-- looking at the schema, on the lower left we can notice that the date is in TEXT format instead of date, we have to change that into a proper DATE format--
-- we can change it at the table importing window when we first import the data to sql however if it's already set like this we can only change it manually through query--

SELECT `date`
FROM layoffs_staging2;
-- we will use the function STR_TO_DATE to convert the string into a DATE format--
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;
-- Now update it --

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%M/%d/%Y');

SELECT *
FROM layoffs_staging2;

-- STEP 3: FINDING NULLS AND BLANKS --
-- We use this query to find out in our overall data what datas have nulls or blanks in them and we can identify properly which columns or rows to standardize--
SELECT count(*) AS total_rows,
	SUM(CASE WHEN industry IS NULL or industry = '' THEN 1 ELSE 0 END) as Missing_industry,
    SUM(CASE WHEN company IS NULL or company = '' THEN 1 ELSE 0 END) as Missing_company,
    SUM(CASE WHEN location IS NULL or location = '' THEN 1 ELSE 0 END) as Missing_location,
    SUM(CASE WHEN total_laid_off IS NULL or total_laid_off = '' THEN 1 ELSE 0 END) as Missing_total_laid_off,
    SUM(CASE WHEN percentage_laid_off IS NULL or percentage_laid_off = '' THEN 1 ELSE 0 END) as Missing_percentage_laid_off,
	SUM(CASE WHEN stage IS NULL or stage = '' THEN 1 ELSE 0 END) as Missing_stage,
    SUM(CASE WHEN country IS NULL or country = '' THEN 1 ELSE 0 END) as Missing_country,
	SUM(CASE WHEN funds_raised_millions IS NULL or funds_raised_millions = '' THEN 1 ELSE 0 END) as Missing_funds
FROM layoffs_staging2;
-- now that we have identified which columns have nulls or blanks in them, we can change them into UNKNOWN or other identifiers so that we can filter them better -- 
UPDATE layoffs_staging2
SET industry = 'Unknown'
WHERE industry IS NULL or industry = '';

UPDATE layoffs_staging2
SET stage = 'Unknown'
WHERE stage IS NULL or stage = '';

-- Now, we cannot change the total_laid_off or percentage_laid_off into unknown because they are in INT format --
-- We can change the format of the column into string or text however since numbers are generally what's in these columns, that would be improper--


-- STEP 4: REMOVING UNECESSARY COLUMNS --
-- Now that we cleaned this table, we can drop some unnecessary columns like row_num since it is not needed anymore--

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- STEP 5: CREATING A FINAL TABLE--
-- we can create a final table so for more clean and refined visuals--

CREATE TABLE world_layoffs_final
LIKE layoffs_staging2;

INSERT world_layoffs_final
SELECT *
FROM layoffs_staging2;

SELECT *
FROM world_layoffs_final;