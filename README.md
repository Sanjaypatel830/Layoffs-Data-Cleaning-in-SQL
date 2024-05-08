# Layoffs-Data-Cleaning-in-SQL
This project involves the cleaning and standardization of layoffs data using MySQL. The data cleaning process is organized into several steps, each aimed at improving the quality and consistency of the dataset.



Here's a structured breakdown of the queries 

**Step 1: Database Setup**

create database layoff_database;

use layoff_database;

**Step 2: Initial Data Exploration**

select * from LAYOFFS;
  

**Step 3: Remove Duplicates**


with DUBLICATE_CTE AS (
    select *,
    row_number() over (
        partition by location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
    ) as ROW_NUM
    from LAYOFFS
)
select * from DUBLICATE_CTE where row_num > 1;

**Step 4: Create a Clean Table**

-- Create a clean table for further processing

create table CLEAN_LAYOFFS (
  company text,
  location text,
  industry text,
  total_laid_off int DEFAULT NULL,
  percentage_laid_off text,
  date text,
  stage text,
  country text,
  funds_raised_millions int DEFAULT NULL
);

**Step 5: Standardize Data**
-- Standardize company names

update CLEAN_LAYOFFS set company = trim(company);

-- Standardize industry names

update CLEAN_LAYOFFS set industry = 'CRYPTO' where industry like 'CRYPTO%';

-- Standardize date format

update CLEAN_LAYOFFS set date = str_to_date(date, '%m/%d/%Y');

-- Alter date column to date type

alter table CLEAN_LAYOFFS modify date date;

**Step 6: Handle Null Values**

select * from CLEAN_LAYOFFS T1
join CLEAN_LAYOFFS T2
         on T1.COMPANY = T2.COMPANY
		and T1.LOCATION = T2.LOCATION
	where (T1.INDUSTRY is null or T1.INDUSTRY = '')
    and T2.INDUSTRY is not null;
    
   update CLEAN_LAYOFFS
    set INDUSTRY = null
    where INDUSTRY = '';
    
    update   CLEAN_LAYOFFS T1 
    join CLEAN_LAYOFFS T2
     on T1.COMPANY = T2.COMPANY
		and T1.LOCATION = T2.LOCATION
        set T1.INDUSTRY = T2.INDUSTRY
        where (T1.INDUSTRY is null or T1.INDUSTRY = '')
    and T2.INDUSTRY is not null;
    
    
   ``select *  from CLEAN_LAYOFFS
where TOTAL_lAID_OFF is null
and PERCENTAGE_LAID_OFF is null;```
        
        
        delete from CLEAN_LAYOFFS
where TOTAL_lAID_OFF is null
and PERCENTAGE_LAID_OFF is null;

-- Remove rows with null values in specific columns

delete from CLEAN_LAYOFFS where total_laid_off is null and percentage_laid_off is null;

**Step 7: Final Cleanup**

-- Drop temporary row number column

alter table CLEAN_LAYOFFS drop column ROW_NUM;

select * from CLEAN_LAYOFFS;

