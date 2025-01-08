/*
-- World Layoffs Data Exploration
Skills used: CTE's, Windows Functions, Aggregate Functions
-- Ranking the company based on Maximum Number of peopele Laid off Year wise(2020 - 2023)
*/

select *
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc ;

select min(`date`), max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry	
order by 2 desc ;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc ;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc ;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc ;


select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 Asc;

 with Rolling_Total as 
 (
 select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 Asc
)
select `month`, total_off, sum(total_off) over(order by `month`) as rolling_total
from Rolling_total;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc ;

with Company_off_Yearwise as 
(
 select substring(`date`, 1,4) as `year`, company, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,4) is not null
group by `year`, company
order by 1 Asc
)
select `year`, company, total_off, sum(total_off) over(order by `year`)
from Company_off_Yearwise;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with Company_Year(company, `years`, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
),
Company_Ranking as
(select *,
dense_rank() over(partition by years  order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Ranking
where Ranking <= 5
order by Ranking Asc
;
