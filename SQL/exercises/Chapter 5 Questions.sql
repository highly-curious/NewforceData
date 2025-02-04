-- Find Athletes from Summer or Winter Games
-- Write a query to list all athlete names who participated in the Summer or Winter Olympics. Ensure no duplicates appear in the final table using a set theory clause.
SELECT name FROM athletes WHERE id IN (SELECT athlete_id FROM summer_games)
UNION
SELECT name FROM athletes WHERE id IN (SELECT athlete_id FROM winter_games);


-- Write a query to retrieve country_id and country_name for countries in the Summer Olympics.
SELECT DISTINCT c.country AS country_name, sg.country_id AS country_id 
FROM countries c
JOIN summer_games sg ON c.id = sg.country_id
ORDER BY country_name ASC;

	
-- Add a JOIN to include the country’s 2016 population and exclude the country_id from the SELECT statement.
SELECT DISTINCT c.country AS country_name, cs.pop_in_millions::numeric * 1e6 AS population_2016 
FROM countries c
JOIN country_stats cs ON c.id = cs.country_id
JOIN summer_games sg ON c.id = sg.country_id
WHERE EXTRACT(YEAR FROM cs.year::date) = 2016
ORDER BY country_name ASC;



-- Repeat the process for the Winter Olympics.
SELECT DISTINCT c.country AS country_name, cs.pop_in_millions::numeric * 1e6 AS population_2016 
FROM countries c
JOIN country_stats cs ON c.id = cs.country_id
JOIN winter_games wg ON c.id = wg.country_id
WHERE EXTRACT(YEAR FROM cs.year::date) = 2016
ORDER BY country_name ASC;

-- Use a set theory clause to combine the results.
SELECT DISTINCT c.country AS country_name, cs.pop_in_millions::numeric * 1e6 AS population_2016 
FROM countries c
JOIN country_stats cs ON c.id = cs.country_id
JOIN summer_games sg ON c.id = sg.country_id
WHERE EXTRACT(YEAR FROM cs.year::date) = 2016

UNION ALL

SELECT DISTINCT c.country AS country_name, cs.pop_in_millions::numeric * 1e6 AS population_2016 
FROM countries c
JOIN country_stats cs ON c.id = cs.country_id
JOIN winter_games wg ON c.id = wg.country_id
WHERE EXTRACT(YEAR FROM cs.year::date) = 2016

ORDER BY country_name ASC;


-- Identify Countries Exclusive to the Summer Olympics
-- Return the country_name and region for countries present in the countries table but not in the winter_games table.
-- (Hint: Use a set theory clause where the top query doesn’t involve a JOIN, but the bottom query does.)
SELECT country, region 
FROM countries c
WHERE EXISTS (
    SELECT 1 FROM summer_games sg WHERE sg.country_id = c.id)
EXCEPT
SELECT country, region 
FROM countries c
WHERE EXISTS (
    SELECT 1 FROM winter_games wg WHERE wg.country_id = c.id)
	ORDER BY country ASC;

