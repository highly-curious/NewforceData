-- Utilizing the Olympic database:

-- Write a CTE called top_gold_winter to find the top 5 gold-medal-winning countries for Winter Olympics.
WITH top_gold_winter AS (
    SELECT c.country, COUNT(wg.gold) AS gold_medal_count
    FROM winter_games wg
	JOIN countries c ON c.id = wg.country_id
    GROUP BY c.country
    ORDER BY gold_medal_count DESC
    LIMIT 5
)
SELECT * 
FROM top_gold_winter;

-- Query the CTE to select countries and their medal counts where gold medals won are ≥ 5.
WITH top_gold_winter AS (
    SELECT c.country, COUNT(wg.gold) AS gold_medal_count
    FROM winter_games wg
	JOIN countries c ON c.id = wg.country_id
    GROUP BY c.country
    ORDER BY gold_medal_count DESC
    LIMIT 5
)
SELECT * 
FROM top_gold_winter WHERE gold_medal_count >= 5;

-- Write a CTE called tall_athletes to find athletes taller than the average height for athletes in the database.
WITH tall_athletes AS (
    SELECT *
    FROM athletes
    WHERE height > (SELECT AVG(height) FROM athletes)
)
SELECT name, height 
FROM tall_athletes
ORDER BY height;

-- Query the CTE to return only female athletes over age 30 who meet the criteria.
WITH tall_athletes AS (
    SELECT *
    FROM athletes
    WHERE height > (SELECT AVG(height) FROM athletes)
)
SELECT * 
FROM tall_athletes
WHERE gender = 'F' AND age >= 30;

-- Average Weight of Female Athletes

-- Write a CTE called tall_over30_female_athletes for the results of Exercise 2.
WITH tall_athletes AS (
    SELECT *
    FROM athletes
    WHERE height > (SELECT AVG(height) FROM athletes)
),
tall_over30_female_athletes AS (
    SELECT * 
    FROM tall_athletes
    WHERE gender = 'F' AND age > 30
)
SELECT *
FROM tall_over30_female_athletes;

-- Query the CTE to find the average weight of these athletes.
-- 72.2244897959183673
WITH tall_athletes AS (
    SELECT *
    FROM athletes
    WHERE height > (SELECT AVG(height) FROM athletes)
),
tall_over30_female_athletes AS (
    SELECT * 
    FROM tall_athletes
    WHERE gender = 'F' AND age > 30
)
SELECT AVG(weight) AS average_weight
FROM tall_over30_female_athletes;
