-- Data cleaning
select *
from world_layoffs.layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blanck Values
-- 4. Remove Any Columns or Rows

-- 1. Remove Duplicates

CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from world_layoffs.layoffs;

select *,
Row_Number() Over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) row_num
from layoffs_staging;

With duplicate_cte AS
(
select *,
Row_Number() Over(
partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) row_num
from layoffs_staging
)
select *
from duplicate_cte
Where row_num >1;

select *
from layoffs_staging
Where company='Casper';


With duplicate_cte AS
(
select *,
Row_Number() Over(
partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) row_num
from layoffs_staging
)
Delete 
from duplicate_cte
Where row_num >1;



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

select *
from layoffs_staging2;

Insert into layoffs_staging2
select *,
Row_Number() Over(
partition by company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
from layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

Delete
from layoffs_staging2
Where row_num >1;

select *
from layoffs_staging2
Where row_num >1;

select *
from layoffs_staging2

-- 2. Standardize the Data

select company, Trim(company)
from layoffs_staging2;

Update layoffs_staging2
Set company = trim(company);

select *
from layoffs_staging2
Where industry like 'Crypto%';

Update layoffs_staging2
Set industry = 'Crypto'
Where industry like 'Crypto%';

select *
from layoffs_staging2
Where country like 'United States%'
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united States%';

select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%Y-%m-%d');
------------------------
Alter table layoffs_staging2
add column `date_temp` DATE;

UPDATE layoffs_staging2
SET `date_temp` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE layoffs_staging2
DROP COLUMN `date`;

ALTER TABLE layoffs_staging2
RENAME COLUMN `date_temp` TO `date`;

DESCRIBE layoffs_staging2;
---------------------------------------
select *
from layoffs_staging2;

-- 3. Null Values or Blanck Values
select *
from layoffs_staging2
where total_laid_off is null
And percentage_laid_off is null;

update layoffs_staging2
set industry = NULL
where industry = '';


select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2 as t1
join layoffs_staging2 as t2
	on t1.company=t2.company
    And t1.location=t2.location
where (t1.industry is null Or t1.industry='')
And t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where (t1.industry is null)
AND t2.industry is not null;


Alter table layoffs_staging2;

-- 4. Remove Any Columns or Rows
select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

