-- Use a window function to add columns showing:
-- The maximum population (max_pop) for each county.
-- The minimum population (min_pop) for each county.
-- Rank counties from largest to smallest population for each year.

WITH RankedPopulations AS (
    SELECT
        county,
        year,
        population,
        MAX(population) OVER (PARTITION BY county, year) AS max_pop,
        MIN(population) OVER (PARTITION BY county, year) AS min_pop,
        ROW_NUMBER() OVER (PARTITION BY county ORDER BY population DESC) AS rank
    FROM population
)
SELECT DISTINCT
    county,
    year,
    population,
    max_pop,
    min_pop,
    rank
FROM RankedPopulations
ORDER BY population DESC;



-- Use the unemployment table:
-- Calculate the rolling 12-month average unemployment rate using the unemployment table.
-- Include the current month and the preceding 11 months.
-- Hint: Reference two columns in the ORDER BY argument (county and period).
WITH MonthlyUnemployment AS (
    SELECT
        county,
        year,
        period,
        value AS unemployment_rate
    FROM unemployment
)
SELECT
    county,
    year,
    period,
    unemployment_rate,
    AVG(unemployment_rate) OVER (PARTITION BY county ORDER BY year, period ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS rolling_12_month_avg
FROM MonthlyUnemployment
ORDER BY period, rolling_12_month_avg DESC;
