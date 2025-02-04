-- ECD Database

-- Find which county had the most months with unemployment rates above the state average

-- Write a query to calculate the state average unemployment rate.
-- 7.1036513157894737
SELECT AVG(value) AS avg_unemployment_rate
FROM unemployment;

-- Use this query in the WHERE clause of an outer query to filter for months above the average.
-- 4307
SELECT count (period)
FROM unemployment
WHERE value > (SELECT AVG(value) AS avg_unemployment_rate
FROM unemployment);


-- Use Select to count the number of months each county was above the average. Which country had the most?
-- Jefferson
SELECT county, count (period) AS months_above_avg
FROM unemployment
WHERE value > (SELECT AVG(value) AS avg_unemployment_rate
FROM unemployment)
GROUP BY county;

SELECT county, count (period) AS months_above_avg
FROM unemployment
WHERE value > (SELECT AVG(value) AS avg_unemployment_rate
FROM unemployment)
GROUP BY county
LIMIT 1;
-- Find the average number of jobs created for each county based on projects involving the largest capital investment by each company:
SELECT county, AVG(new_jobs) AS avg_new_jobs,capital_investment
FROM ecd
WHERE capital_investment IS NOT NULL
Group by county,capital_investment
ORDER BY capital_investment DESC;

-- Write a query to find each company’s largest capital investment, returning the company name along with the relevant capital investment amount for each.
SELECT company, MAX(capital_investment) AS largest_capital_investment
FROM ecd
WHERE capital_investment IS NOT NULL
GROUP BY company;

-- Use this query in the FROM clause of an outer query, alias it, and join it with the original table.
-- Use Select * in the outer query to make sure your join worked properly
SELECT * 
FROM ecd
JOIN (
    SELECT company, MAX(capital_investment) AS largest_capital_investment
    FROM ecd
    WHERE capital_investment IS NOT NULL
    GROUP BY company
) max_investments ON ecd.company = max_investments.company;


-- Adjust the SELECT clause to calculate the average number of jobs created by county.
SELECT ecd.county, AVG(ecd.new_jobs) AS avg_new_jobs, ecd.company, largest_capital_investment
FROM ecd
JOIN (
    SELECT company, MAX(capital_investment) AS largest_capital_investment
    FROM ecd
    WHERE capital_investment IS NOT NULL
    GROUP BY company) max_investments ON ecd.company = max_investments.company
WHERE ecd.capital_investment = max_investments.largest_capital_investment
GROUP BY ecd.county, ecd.company, largest_capital_investment 
ORDER BY avg_new_jobs DESC;

WITH max_investments AS (
    SELECT company, MAX(capital_investment) AS largest_capital_investment
    FROM ecd
    WHERE capital_investment IS NOT NULL
    GROUP BY company)
SELECT ecd.county, 
    AVG(ecd.new_jobs) AS avg_new_jobs
FROM ecd
JOIN max_investments ON ecd.company = max_investments.company
WHERE ecd.capital_investment = max_investments.largest_capital_investment
GROUP BY ecd.county
ORDER BY avg_new_jobs DESC;


SELECT ecd.county, ROUND(AVG(ecd.new_jobs),2) AS avg_nmbr_new_jobs
FROM ecd,
(SELECT company, MAX(capital_investment) AS max_cap_inv
FROM ecd
GROUP BY company) AS sub
WHERE ecd.company = sub.company
GROUP BY ecd.county
ORDER BY avg_nmbr_new_jobs DESC;
