# LinkedIn Job Data Analysis


# Project Overview
This project involves analyzing LinkedIn job data using SQL for data cleaning and Tableau for visualization. The primary objectives are to clean the dataset, remove duplicates, standardize values, and visualize the insights gained from the cleaned data.

# Data Cleaning with SQL
The data cleaning process was performed using MySQL, involving several key steps:

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





# Data Visualization with Tableau

After cleaning the data using SQL, the next step was to visualize the data using Tableau. The primary goal of the visualizations was to derive meaningful insights from the LinkedIn job postings data. Here are some key visualizations and insights:

**1. Companies with high job postings:**

- Created bar charts to identify the Top 10 companies with maximum number of job postings.
-- **Insight:** Larger companies posted more job openings, indicating robust hiring activities.

**2. Number of Applications per Job posting:**

- Plotted bar graph to identify the job with maximum number of postings.
- **Insight:** Jobs in high-demand fields received a higher number of applications, reflecting their popularity among job seekers.

**3. Job Distribution by Work Type:**

- Plotted pie chart to identify the distribution of job type.
- **Insight:** Remote Roles are very much in-demand in the job market, followed by on-site roles.


**4.Job Postings by Industry:**

- Generated bar charts to showcase the top industries hiring based on the number of job postings.
- **Insight:** IT Services and Consulting is the industry with the major amount job postings.

**5.Job Distribution by Employment Type:**

- Visualized the distribution of employment types (full-time, part-time, internship).
- **Insight:** A significant portion of the job postings were for full-time positions.


# Potiential Bias in the Data

The data used in this project was collected from Kaggle and could be subject to various biases due to the search history and interactions of the data owner. These biases might affect the overall representation and analysis of job market trends. The following are key areas where bias might be introduced:

**1.Personalized Job Recommendations:** Platforms like LinkedIn often personalize job recommendations based on a user's profile, search history, and interactions.

**2. Geographical Focus:** The data owner's location and previous job searches might influence the geographical distribution of job postings.

**3. Industry and Role Preferences:** If the data owner has shown a preference for specific industries or roles through their search history, these sectors might be overrepresented.

**4. Company Engagement:**  Interactions with certain companies (e.g., following company pages, viewing job postings from specific companies) might lead to more job postings from these companies being included in the dataset.
