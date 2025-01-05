Select *
From toyota_data;

create database toyota_stock;
DROP DATABASE `toyota-stock`;


-- 1. Find duplicate rows

create table toyota_stock.toyota_staging
like toyota_stock.toyota_data;

select *
from toyota_staging;

insert toyota_staging
select *
from toyota_data;


select *,
Row_Number() Over( 
partition by `date`  , adj_close, close, high) row_num
from toyota_staging;

With duplicate_cte AS
(
select *,
Row_Number() Over( 
partition by `date`  , adj_close, close) row_num
from toyota_staging
)
select *
from duplicate_cte
Where row_num >1;

-- No Duplication

-- 2. Standardize the Data
-- Rename the Columns

Alter table toyota_staging
Rename column `Date` to date,
Rename column `Adj Close` to adj_close,
Rename column Close to close,
Rename column High to high,
Rename column Low to low,
Rename column Open to open,
Rename column Volume to volume;

select *
from toyota_staging;

-- 3. Null Values or Blanck Values
select *
from toyota_staging
where adj_close is null
-- And close is null
-- And high is null
-- And low is null
And open is null
And volume is null;
-- No null values! But missing values for open and volume columns.
select *
from toyota_staging
where volume =0;

Delete from toyota_staging
Where volume =0;

select *
from toyota_staging
where open =0;

-- Using the Close price of the previous trading day as a substitute

update toyota_staging
SET Open = (SELECT Close FROM toyota_staging t2 WHERE t2.Date < toyota_staging.Date ORDER BY t2.Date DESC LIMIT 1)
WHERE Open = 0 OR Open IS NULL;

-- 4.  Remove Any Columns or Rows

delete from toyota_staging
where `date` ='1980-03-17';

select *
from toyota_staging;














