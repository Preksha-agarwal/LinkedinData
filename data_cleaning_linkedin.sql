-- Open database
USE LinkedInJob;

-- View tables in the database
SHOW TABLES;

-- View all records from the table 'LinkedIn'
SELECT * FROM LinkedIn;

-- Creating a working table LinkedIn1
CREATE TABLE LinkedIn1 AS
SELECT * FROM LinkedIn;

-- Check for number of records in the table
SELECT COUNT(*)
FROM LinkedIn1;


-- DATA CLEANING


-- 1. REMOVAL OF DUPLICATES

-- Check if there are any duplicates
SELECT job_ID, COUNT(job_ID)
FROM LinkedIn1
GROUP BY job_ID
HAVING COUNT(job_ID)>1;
-- There are duplicates in the data

-- Create a new table with for handling duplicates
CREATE TABLE `LinkedIn2` (
  `job_ID` bigint DEFAULT NULL,
  `job` varchar(169) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `company_id` varchar(30) DEFAULT NULL,
  `company_name` varchar(90) DEFAULT NULL,
  `work_type` varchar(7) DEFAULT NULL,
  `full_time_remote` varchar(28) DEFAULT NULL,
  `no_of_employ` varchar(75) DEFAULT NULL,
  `no_of_application` varchar(7) DEFAULT NULL,
  `posted_day_ago` varchar(10) DEFAULT NULL,
  `alumni` varchar(21) DEFAULT NULL,
  `Hiring_person` varchar(63) DEFAULT NULL,
  `linkedin_followers` varchar(26) DEFAULT NULL,
  `hiring_person_link` varchar(101) DEFAULT NULL,
  `job_details` varchar(12549) DEFAULT NULL,
  `Column1` varchar(30) DEFAULT NULL,
  `Row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Enter all the data from table and also the row number(gives unique sequential value based on the required columns)
-- As the numbering is based on job ID, the rows with row_num more than 1 are duplicates
INSERT INTO LinkedIn2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY job_ID) AS Row_num
FROM LinkedIn1;

-- Command that allows to make changes in the table
SET SQL_SAFE_UPDATES=0;

-- Deleting the duplicates
DELETE FROM LinkedIn2
WHERE Row_num>1;


-- 2. STANDARDIZING VALUES

-- i. 'job' column

-- View all job names
SELECT job
FROM LinkedIn2;

-- Remove text within parenthesis
UPDATE LinkedIn2
SET job = CASE
  WHEN LOCATE('(', job) > 0 AND LOCATE(')', job) > LOCATE('(', job) THEN
    TRIM(CONCAT(
        SUBSTRING_INDEX(job, '(', 1),
        SUBSTRING(job, LOCATE(')', job) + 1)))
  ELSE job
END;

-- Remove yearly package information
UPDATE LinkedIn2
SET job = 
   REGEXP_REPLACE(job, '- \\$[0-9,]+/year USD', '');

-- Remove values after comma
UPDATE LinkedIn2
SET job =
		SUBSTRING_INDEX(job,',',1);

-- Remove whitespaces from job column
UPDATE LinkedIn2
SET job =TRIM(job);
            


-- ii. 'location' column

-- Create charcater column city
ALTER TABLE LinkedIn2
ADD COLUMN city VARCHAR(1024);

-- Create character column state
ALTER TABLE LinkedIn2
ADD COLUMN state VARCHAR(1024);

-- Create character column country
ALTER TABLE LinkedIn2
ADD COLUMN country VARCHAR(1024);

-- Divide the values of location column into city, state and country
UPDATE LinkedIn2
SET 
	-- Country contained after last comma
	country=SUBSTRING_INDEX(location,',',-1)
	-- State contained between two commas
    , state=TRIM(TRAILING SUBSTRING_INDEX(location,',',-1)
	FROM SUBSTRING_INDEX(location,',',-2))
	-- City before the first comma
    , city=TRIM(TRAILING SUBSTRING_INDEX(location,',',-2)
	FROM SUBSTRING_INDEX(location,',',-3));
-- Negative indexing is used as there are some records containing only value for country, or state and country.
-- To correctly assign values in the columns, negative indexing was a must

-- Formatting(location)

-- Remove the comma at the end of each record from city column
UPDATE LinkedIn2
SET city= TRIM(TRAILING ',' FROM city);

-- Remove the comma at the end of each record from state column
UPDATE LinkedIn2
SET state= TRIM(TRAILING ',' FROM state);

-- Remove whitespaces form country column
UPDATE LinkedIn2
SET country= TRIM(country);

-- Remove whitespaces form state column
UPDATE LinkedIn2
SET state= TRIM(state);

-- Make sure all empty columns are set to null in the city column
UPDATE LinkedIn2
SET city = NULL
WHERE city IN ('',' ');

-- Make sure all empty columns are set to null in the state column
UPDATE LinkedIn2
SET state = NULL
WHERE state IN ('',' ');


-- iii. 'company_name' column

-- Get the first letter turned to uppercase in each record
SELECT UPPER(SUBSTRING(company_name,1,1))
FROM LinkedIn2;

-- Get all but first letter of each record in compny_name column
SELECT SUBSTRING(company_name,2)
FROM LinkedIn2;

-- Standardize each record in company_name column
-- i.e. Captitalize the first letter of each record
UPDATE LinkedIn2
SET company_name = 
				CONCAT(
                UPPER(SUBSTRING(company_name,1,1)),
                SUBSTRING(company_name,2)
                );
                

-- iv. 'full_time_remote' column

-- View all records for this column in the data
SELECT full_time_remote
FROM LinkedIn2;
-- Some records contain both the values of employement type and level

-- The first part of the string contains information on employement type
SELECT SUBSTRING_INDEX(full_time_remote,'·',1)
FROM LinkedIn2;

-- Fully formated value of level for the jobs
SELECT TRIM( LEADING '· ' FROM
	TRIM(LEADING SUBSTRING_INDEX(full_time_remote,'·',1) FROM SUBSTRING_INDEX(full_time_remote,'·',2)))
FROM LinkedIn2;

-- Create a new column called level
ALTER TABLE LinkedIn2
ADD COLUMN `level` VARCHAR(50);

-- Add records containing information on level
UPDATE 
LinkedIn2
SET `level` = 
				TRIM( LEADING '· ' FROM
				TRIM(LEADING SUBSTRING_INDEX(full_time_remote,'·',1) FROM SUBSTRING_INDEX(full_time_remote,'·',2)));

-- Make sure the original column contains only the required and relevant value                
UPDATE 
LinkedIn2
SET full_time_remote= SUBSTRING_INDEX(full_time_remote,'·',1);

-- Make sure all empty columns are set to null in the level column
UPDATE 
LinkedIn2
SET `level` = NULL
WHERE `level` IN ('',' ');


-- v. 'no_of_employ' column

-- View records of this column in the data
SELECT no_of_employ
FROM LinkedIn2;
-- Some records contain both the values of number of employees and industry of the company

-- The first part of the string contains information on number of employees
SELECT SUBSTRING_INDEX(no_of_employ,'·',1)
FROM LinkedIn2;

-- Fully formated value of industry for the jobs
SELECT TRIM( LEADING '· ' FROM
	TRIM(LEADING SUBSTRING_INDEX(no_of_employ,'·',1) FROM SUBSTRING_INDEX(no_of_employ,'·',2)))
FROM LinkedIn2;

-- Create a new column called industry
ALTER TABLE LinkedIn2
ADD COLUMN industry VARCHAR(100);

-- Add records containing information on industry
UPDATE 
LinkedIn2
SET industry = 
				TRIM( LEADING '· ' FROM
				TRIM(LEADING SUBSTRING_INDEX(no_of_employ,'·',1) FROM SUBSTRING_INDEX(no_of_employ,'·',2)));

-- Make sure the original column contains only the required and relevant value                  
UPDATE 
LinkedIn2
SET no_of_employ= SUBSTRING_INDEX(no_of_employ,'·',1);

-- Make sure all empty columns are set to null in the industry column
UPDATE 
LinkedIn2
SET industry = NULL
WHERE industry IN ('',' ');


-- vi. 'no_of_application' column

-- View records of this column in the data
SELECT no_of_application
FROM LinkedIn2;

SELECT no_of_application
FROM LinkedIn2;
-- The column contains some invalid values like 'minutes', 'days' etc.

-- To view all the records where the column has not-numeric values
SELECT no_of_application
FROM LinkedIn2
WHERE no_of_application
REGEXP '^[^0-9]';

-- To update all the records and change the value to NULL of all the records with non-numeric values
UPDATE LinkedIn2
SET no_of_application = NULL
WHERE no_of_application
REGEXP '^[^0-9]';

-- To change the column to integer type
ALTER TABLE LinkedIn2
MODIFY no_of_application INT;


-- vii. 'alumni' column

-- View records of this column in the data
SELECT alumni
FROM LinkedIn2;
-- We see that records contain the string 'company alumni' at the end and has commas between the numeric values

-- View all the records with the string 'company alumni' removed from the end
SELECT TRIM( TRAILING ' company alumni' FROM alumni)
FROM LinkedIn2;

-- Update the changes
UPDATE LinkedIn2
SET alumni=TRIM( TRAILING ' company alumni' FROM alumni);

-- To remove the commas from the numeric values
SELECT
	CONCAT(
	(
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(alumni,',',-1) FROM SUBSTRING_INDEX(alumni,',',-2)))
    )
    ,SUBSTRING_INDEX(alumni,',',-1))
FROM LinkedIn2;

-- Update the changes
UPDATE 
LinkedIn2
SET alumni = 
	CONCAT(
	(
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(alumni,',',-1) FROM SUBSTRING_INDEX(alumni,',',-2)))
    )
    ,SUBSTRING_INDEX(alumni,',',-1));

-- Change the datatype of alumni column to integer
ALTER TABLE LinkedIn2
MODIFY alumni INT;


-- viii. 'Hiring_person' column

-- View records of this column in the data
SELECT Hiring_person
FROM LinkedIn2;
-- Some records have nickname values at the end of data

-- View the value of records after removing the values after parenthesis
SELECT SUBSTRING_INDEX(Hiring_person,'(',1)
FROM LinkedIn2;

-- Update the changes
UPDATE LinkedIn2
SET Hiring_person=SUBSTRING_INDEX(Hiring_person,'(',1);

-- Remove unnecessary whitespace
UPDATE LinkedIn2
SET Hiring_person=TRIM(Hiring_person);


-- ix. 'linkedin_followers' columns

-- View records of this column in the data
SELECT linkedin_followers
FROM LinkedIn2;
-- There is the string 'followers' at the end of few strings and some invalid text is also present in some records

-- Remove the string 'followers' from the end of each record
UPDATE LinkedIn2
SET linkedin_followers= TRIM(TRAILING ' followers' FROM linkedin_followers);

-- To replace all the records with unnecessary text with NULL
UPDATE LinkedIn2
SET linkedin_followers = NULL
WHERE linkedin_followers
REGEXP '^[^0-9]';

-- Remove the commas in between numeric values
SELECT
	CONCAT(
	(
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(linkedin_followers,',',-2) FROM SUBSTRING_INDEX(linkedin_followers,',',-3)))
    )
	, (
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(linkedin_followers,',',-1) FROM SUBSTRING_INDEX(linkedin_followers,',',-2)))
    )
    ,SUBSTRING_INDEX(linkedin_followers,',',-1))
	,linkedin_followers
FROM LinkedIn2;
-- The above query seems to be working fine. So we assign this value
UPDATE 
LinkedIn2
SET linkedin_followers =
	CONCAT(
	(
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(linkedin_followers,',',-2) FROM SUBSTRING_INDEX(linkedin_followers,',',-3)))
    )
	, (
    TRIM( TRAILING ',' FROM
    TRIM(TRAILING SUBSTRING_INDEX(linkedin_followers,',',-1) FROM SUBSTRING_INDEX(linkedin_followers,',',-2)))
    )
    ,SUBSTRING_INDEX(linkedin_followers,',',-1));

-- Change the datatype of linkedin_followers from character to Big integer
ALTER TABLE LinkedIn2
MODIFY linkedin_followers BIGINT;


-- x. 'job_details' column

-- View records of this column in the data
SELECT job_details
FROM LinkedIn2;

-- From the job description column, remove the string 'About the job' present before each record
UPDATE LinkedIn2
SET job_details= TRIM(LEADING 'About the job ' FROM job_details);


-- 3. DEALING WITH NULLs

-- No need for the columns where there is no information about the job
DELETE
FROM LinkedIn2
WHERE job IS NULL;

-- No need for the columns where there is no information about the company name
DELETE
FROM LinkedIn2
WHERE company_name IS NULL;


-- 4. DELETE UNNECESSARY COLUMNS

-- Row_num is not needed anymore
ALTER TABLE LinkedIn2
DROP COLUMN Row_num;

-- company_id column is empty
ALTER TABLE LinkedIn2
DROP COLUMN company_id;

-- Column1 is empty
ALTER TABLE LinkedIn2
DROP COLUMN Column1;

-- location column has already been dealth with
ALTER TABLE LinkedIn2
DROP COLUMN location;


-- 5. RENAME COLUMNS

-- We rename the columns to improve the understnding of the data
SELECT *
FROM LinkedIn2;

ALTER TABLE LinkedIn2
RENAME COLUMN job_ID TO `job_id`;

ALTER TABLE LinkedIn2
RENAME COLUMN job TO `title`;

ALTER TABLE LinkedIn2
RENAME COLUMN full_time_remote TO `employement_type`;

ALTER TABLE LinkedIn2
RENAME COLUMN no_of_employ TO `number_of_employees`;

ALTER TABLE LinkedIn2
RENAME COLUMN no_of_application TO `number_of_applications`;

ALTER TABLE LinkedIn2
RENAME COLUMN posted_day_ago TO `days_posted_ago`;

ALTER TABLE LinkedIn2
RENAME COLUMN alumni TO `alumni_count`;

ALTER TABLE LinkedIn2
RENAME COLUMN Hiring_person TO `hiring_contact`;