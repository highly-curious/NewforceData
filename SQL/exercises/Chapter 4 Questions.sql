-- How many rows are in the athletes table? 
--4216
SELECT COUNT (*)
FROM athletes;

-- How many distinct athlete ids?
-- 4215
SELECT COUNT (DISTINCT id)
FROM athletes;

-- Which years are represented in the summer_games, winter_games, and country_stats tables?
-- 2000
-- 2001
-- 2002
-- 2003
-- 2004
-- 2005
-- 2006
-- 2007
-- 2008
-- 2009
-- 2010
-- 2011
-- 2012
-- 2013
-- 2014
-- 2015
-- 2016

SELECT DISTINCT TO_CHAR(year::DATE, 'YYYY') AS year
FROM (
    SELECT year::DATE FROM summer_games
    UNION ALL
    SELECT year::DATE FROM winter_games
    UNION ALL
    SELECT year::DATE FROM country_stats
) AS combined_years
ORDER BY year ASC;

-- How many distinct countries are represented in the countries and country_stats table?
-- 203
SELECT COUNT(DISTINCT country) FROM (
    SELECT id AS country FROM countries
    UNION ALL
    SELECT country_id AS country FROM country_stats);


-- How many distinct events are in the winter_games and summer_games table?
-- 127
SELECT COUNT(DISTINCT event) AS total_events FROM (
	SELECT event FROM winter_games
    UNION ALL
    SELECT event FROM summer_games);

-- Count the number of athletes who participated in the summer games for each country. Your output should have country name and number of athletes in their own columns. Did any country have no athletes?
SELECT c.country AS country_name,
       COUNT(DISTINCT sg.athlete_id) AS unique_athletes_count
FROM countries c
   LEFT JOIN summer_games sg ON c.id = sg.country_id
GROUP BY c.id, c.country
ORDER BY unique_athletes_count DESC;

  
-- Write a query to list countries by total bronze medals, with the highest totals at the top and nulls at the bottom.
SELECT c.country AS country_name,
       COUNT(bronze) AS total_bronze
FROM countries c
   LEFT JOIN summer_games sg ON c.id = sg.country_id
GROUP BY c.id, c.country
ORDER BY total_bronze DESC;

-- Adjust the query to only return the country with the most bronze medals
    -- CAN - Canada 21
SELECT c.country AS country_name,
       COUNT(bronze) AS total_bronze
FROM countries c
   LEFT JOIN summer_games sg ON c.id = sg.country_id
GROUP BY c.id, c.country
ORDER BY total_bronze DESC 
LIMIT 1;


-- Calculate the average population in the country_stats table for countries in the winter_games. This will require 2 joins.                                  
-- First query gives you country names and the average population
SELECT c.country, AVG(CAST(cs.pop_in_millions AS NUMERIC)) as avg_pop
FROM countries c
LEFT JOIN winter_games wg ON c.id = wg.country_id
JOIN country_stats cs ON c.id = cs.country_id
WHERE pop_in_millions IS NOT NULL
GROUP BY c.country
ORDER By avg_pop DESC;

SELECT country, AVG(pop_in_millions::numeric *1000000) AS avg_pop
FROM country_stats
INNER JOIN countries
ON country_stats.country_id = countries.id
WHERE pop_in_millions IS NOT NULL
GROUP BY countries.country
ORDER By avg_pop DESC;

-- Second query returns only countries that participated in the winter_games
SELECT DISTINCT c.country AS WG_participation_only
FROM countries c
INNER JOIN winter_games wg ON c.id = wg.country_id
LEFT JOIN summer_games sg ON c.id = sg.country_id
WHERE sg.country_id IS NOT NULL;


-- Identify countries where the population decreased from 2000 to 2006.
SELECT c.country,
    CAST(cs2006.pop_in_millions AS NUMERIC) AS pop_2006,
    CAST(cs2000.pop_in_millions AS NUMERIC) AS pop_2000,
    (CAST(cs2006.pop_in_millions AS NUMERIC) - CAST(cs2000.pop_in_millions AS NUMERIC)) AS population_change
FROM countries c
JOIN country_stats cs2006 ON c.id = cs2006.country_id AND EXTRACT(YEAR FROM cs2006.year::DATE) = 2006
JOIN country_stats cs2000 ON c.id = cs2000.country_id AND EXTRACT(YEAR FROM cs2000.year::DATE) = 2000
WHERE cs2006.pop_in_millions IS NOT NULL 
    AND cs2000.pop_in_millions IS NOT NULL
    AND (CAST(cs2006.pop_in_millions AS NUMERIC) - CAST(cs2000.pop_in_millions AS NUMERIC)) < 0
	ORDER BY population_change ASC;
-- Population decreased from 2000 to 2006 if population_change is negative.




