-- Data Cleaning
	
    create database layoff_database;
    
    use layoff_database;
    
    -- select data
    
select * from LAYOFFS;

-- 1. Remove Dublicates
-- 2. Standardize the Data
-- 3. Null values And Black 
-- 4. Remove Any Columns

create table LAYOFFS2
like LAYOFFS;

select * from LAYOFFS2;

insert LAYOFFS2
select * from LAYOFFS;

select *,
row_number () over(
partition by location,industry,total_laid_off,percentage_laid_off , 'date',stage,country,funds_raised_millions) as ROW_NUM
from LAYOFFS;


with DUBLICATE_CTE AS
(
select *,
row_number () over(
partition by location,industry,total_laid_off,percentage_laid_off , 'date',stage,country,funds_raised_millions) as ROW_NUM
from LAYOFFS)
select * from DUBLICATE_CTE 
where row_num > 1;

select * from layoffs2
where company = 'olist';

CREATE TABLE `clean_layoffs` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from CLEAN_LAYOFFS;



insert into CLEAN_LAYOFFS
select *,
row_number () over(
partition by location,industry,total_laid_off,percentage_laid_off , 'date',stage,country,funds_raised_millions) as ROW_NUM
from LAYOFFS;

select * from CLEAN_LAYOFFS
where ROW_NUM > 1;

set sql_safe_updates = 0;

delete  from CLEAN_LAYOFFS
where ROW_NUM > 1;

select * from CLEAN_LAYOFFS;

-- Standardizing Data

select distinct (trim(COMPANY)),COMPANY
from CLEAN_LAYOFFS;

update CLEAN_LAYOFFS
SET COMPANY = trim(COMPANY);


select  trim(INDUSTRY),INDUSTRY
from CLEAN_LAYOFFS;


update CLEAN_LAYOFFS
SET INDUSTRY = trim(INDUSTRY);


select  distinct(INDUSTRY)
from CLEAN_LAYOFFS
order by INDUSTRY asc;

select * 
from CLEAN_LAYOFFS
WHERE INDUSTRY  LIKE 'CRYPTO%'
order by INDUSTRY;

update CLEAN_LAYOFFS
SET INDUSTRY = 'CRYPTO'
WHERE INDUSTRY  LIKE 'CRYPTO%';

select distinct INDUSTRY
from CLEAN_LAYOFFS;

select * 
FROM CLEAN_LAYOFFS;

select  distinct(LOCATION)
from CLEAN_LAYOFFS
order by LOCATION asc;


select  distinct(COUNTRY)
from CLEAN_LAYOFFS
order by COUNTRY asc;

update CLEAN_LAYOFFS
set COUNTRY = 'United States'
where COUNTRY = 'United States.';

select `date`,str_to_date(`date`,'%m/%d/%Y')
FROM CLEAN_LAYOFFS;

update CLEAN_LAYOFFS
set `DATE` = str_to_date(`date`,'%m/%d/%Y');

alter table CLEAN_LAYOFFS
modify `date` date;





select * from CLEAN_LAYOFFS
where INDUSTRY is null
or INDUSTRY = '';

select * from CLEAN_LAYOFFS
where COMPANY like 'bally%';

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
    
    select *  from CLEAN_LAYOFFS
where TOTAL_lAID_OFF is null
and PERCENTAGE_LAID_OFF is null;
        
	delete from CLEAN_LAYOFFS
where TOTAL_lAID_OFF is null
and PERCENTAGE_LAID_OFF is null;  

select * from CLEAN_LAYOFFS;

alter table CLEAN_LAYOFFS
drop column ROW_NUM;


select * from CLEAN_LAYOFFS;




    