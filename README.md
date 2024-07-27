# LinkedIn Job Data Analysis


# Project Overview
This project involves analyzing LinkedIn job data using SQL for data cleaning and Tableau for visualization. The primary objectives are to clean the dataset, remove duplicates, standardize values, and visualize the insights gained from the cleaned data.

# Data Cleaning with SQL
The data cleaning process was performed using SQL, involving several key steps:

**1. Removing Duplicates:**
- Identified and removed duplicate job postings based on the job_ID.

**2. Standardizing Values:**
- Standardized job titles by removing text within parentheses, yearly package information, and values after commas.
- Split the location column into city, state, and country.
- Standardized company names by capitalizing the first letter.
- Extracted employment type and job level from the full_time_remote column.
- Extracted industry information from the no_of_employ column.
- Cleaned the no_of_application, alumni, Hiring_person, and linkedin_followers columns by removing invalid characters and text, and converting to appropriate data types.
- Cleaned job descriptions by removing the leading 'About the job' text.
  
**3. Handling Null Values:**
- Removed rows with null values in critical columns such as job, company_name.
  
**4. Deleting Unnecessary Columns:**
- Removed columns that were either empty or redundant after cleaning.

**5. Renaming Columns:**
- Renamed columns to improve readability and understanding of the data.
