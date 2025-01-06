-- Exploratory Data Analysis

select *
from layoffs_staging2;

select *
from layoffs_staging2
Where percentage_laid_off=1
Order by funds_raised_millions desc;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select  min(`date`), max(`date`)
from layoffs_staging2;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;


select substring(`date`, 1,7) AS 'Month', sum(total_laid_off)
From layoffs_staging2
Where substring(`date`, 1,7) is not null
group by substring(`date`, 1,7)
order by 1 asc;

With Rolling_Total As
(
select substring(`date`, 1,7) AS 'Month', sum(total_laid_off) As total_off
From layoffs_staging2
Where substring(`date`, 1,7) is not null
group by substring(`date`, 1,7)
order by 1 asc
)
select Month,total_off, sum(total_off) over (order by Month asc) as rolling_total
from Rolling_Total;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

-- Let's find the highest ranking of companies in terms of lay offs in each year
With company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
)
select *, dense_rank() over(partition by years order by total_laid_off desc) As ranking
from company_year
where years is not null
order by ranking asc;

-- Let's find the highest top 5
With company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank As 
(select *, 
dense_rank() over(partition by years order by total_laid_off desc) As ranking
from company_year
where years is not null
)
select *
from company_year_rank
Where ranking <=5;


