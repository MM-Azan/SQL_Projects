-- DATA CLEANING PROJECT: NETFLIX_TITLES


-- THIS PROJECT WILL SHOWCASE THE FOLLOWING THINGS DONE TO CLEAN THE DATA --

SELECT * 
FROM netflix_titles;


CREATE TABLE netflix_titles_staging
LIKE netflix_titles;

INSERT netflix_titles_staging
SELECT * 
FROM netflix_titles;

SELECT * 
FROM netflix_titles_staging;


-- STEP 1: REMOVING UNECESSARY COLUMNS ie BLANK COLUMNS --
ALTER TABLE netflix_titles_staging
DROP `MyUnknownColumn_[12]`;

-- 2nd STEP CHECKING FOR DUPLICATE ENTRIES -- 
-- This line of query checks for the row number of all the rows in the table and partitioning them by all their unique columns --

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY show_id, `type`, title, director, cast, country, date_added, release_year, duration, listed_in, `description`) AS row_num
FROM netflix_titles_staging;


-- let's convert this query into a CTE table so that we can perform more complex query with it -- 
-- we are trying to find the row_num that is greater than 1 which indicates that there are duplicates --
WITH cte_table AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY show_id, `type`, title, director, cast, country, date_added, release_year, duration, listed_in, `description`) AS row_num
FROM netflix_titles_staging
)
SELECT *
FROM cte_table
WHERE row_num > 1;

-- NO DUPLICATE ENTRIES FOUND --

SELECT * 
FROM netflix_titles_staging;
-- Since there are no duplicate entries found in the table, we can proceed into standardizing the data -- 


-- STEP 2: STANDARDIZING THE DATA --
-- TRIM -- 
-- we use the TRIM function to remove the white spaces in the beginning of the characters for the uniformity and cleaner visuals --
UPDATE netflix_titles_staging
SET 
	title = TRIM(title),
    director = TRIM(director),
    cast = TRIM(cast),
    country = TRIM(COUNTRY),
    rating = TRIM(rating),
    listed_in = TRIM(listed_in),
    `description` = TRIM(`description`);
    
-- CONVERTING THE DATE FROM TEXT TO DATE --
-- we can create another column that can convert the existing text date_added column into date format so that we can extract more information easily --
SELECT `date_added`
FROM netflix_titles_staging;

ALTER TABLE netflix_titles_staging 
ADD COLUMN clean_date_added DATE;

UPDATE netflix_titles_staging 
SET clean_date_added = STR_TO_DATE(date_added, '%M %d, %Y');

SELECT clean_date_added
FROM netflix_titles_staging;


-- STEP 3: FINDING OUT NULLS OR BLANKS --
-- we use this case query to find the number of missing entries in our table, this will show how much data we lack -- 
-- We use the string THEN 1 ELSE 0 to see if the results are true otherwise false --
SELECT 
	COUNT(*) AS total_rows,
    SUM(CASE WHEN title IS NULL or title = '' THEN 1 ELSE 0 END) AS missing_titles,
    SUM(CASE WHEN director IS NULL or director = '' THEN 1 ELSE 0 END) AS missing_directors,
    SUM(CASE WHEN cast IS NULL or cast = '' THEN 1 ELSE 0 END) AS missing_cast,
    SUM(CASE WHEN country IS NULL or country = '' THEN 1 ELSE 0 END) AS missing_country
FROM netflix_titles_staging;


-- FILLING OUT BLANKS AND NULLS TO STANDARDIZE THE DATA --
-- We update the table to unknown when the values are unknown to remove nulls or blanks that can interfere with the data and filter the data better --
UPDATE netflix_titles_staging
SET title = 'Unknown'
WHERE title IS NULL OR title = '';

UPDATE netflix_titles_staging
SET director = 'Unknown'
WHERE director IS NULL OR director = '';

UPDATE netflix_titles_staging
SET cast = 'Unknown'
WHERE cast IS NULL OR cast = '';

UPDATE netflix_titles_staging
SET country = 'Unknown'
WHERE country IS NULL OR country = '';

SELECT * 
FROM netflix_titles_staging;

-- ADDING USEFUL COLUMNS FOR BETTER FILTERING --
-- now we can see that the there is a duration column. However, there are two types of duration we can find in it, one is for min and one is for seasons which comparatively are lengths apart--
-- we can create useful columns that can separate the numerical aspects and unit aspects of this duration namely duration_int and duration_unit--
-- we can do this so we can filter the table better in terms of it's duration ie: finding out movies that are more than 99 mins duration or tv shows with more than 1 season --

ALTER TABLE netflix_titles_staging 
ADD COLUMN duration_int INT;

ALTER TABLE netflix_titles_staging 
ADD COLUMN duration_unit VARCHAR(50);

UPDATE netflix_titles_staging
SET duration_int = CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED);
-- here we are extracting the value or character before the 1st(1) space (' ') and using cast to convert it into integer such as 1 or 90 or 2 

UPDATE netflix_titles_staging
SET duration_unit = SUBSTRING_INDEX(duration, ' ', -1);
-- here we are extracting the value or character after(-) the 1st(1) space (' ') and returning all the results such as min or season
-- now we can filter them as such for the length of the duration of the movie or how many seasons it aired

-- STEP 4: CREATING FINALIZED TABLE FOR CLEANER VERSION--

CREATE TABLE netflix_final
LIKE netflix_titles_staging;


INSERT netflix_final
SELECT * 
FROM netflix_titles_staging;

SELECT * 
FROM netflix_final;

-- SUMMARY -- 
-- STEP 1: REMOVING UNNECESSARY COLUMNS --
-- STEP 2: STANDARDIZING THE DATA -- 
-- STEP 3: FINDING OUT NULLS OR BLANKS --
-- STEP 4: CREATING FINALIZED TABLE FOR CLEANER VERSION--
