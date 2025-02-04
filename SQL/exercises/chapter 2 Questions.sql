---How many counties are represented? How many companies?
SELECT count (distinct company)
from ecd;
---How many companies did not get ANY Economic Development grants (ed) for any of their projects? (Hint, you will probably need a couple of steps to figure this one out)
SELECT count (distinct company)
from ecd
Where ed is null;
-- 608

---What is the total capital_investment, in millions, when there was a grant received from the fjtap? Call the column fjtap_cap_invest_mil.
SELECT SUM (capital_investment)AS fjtap_cap_invest_mil
from ecd
Where fjtap is not null;
-- $12,634,623,829.00

---What is the average number of new jobs for each county_tier?
SELECT 
   county_tier, 
    CAST(AVG(NEW_JOBS) AS INT) AS avg_new_jobs
FROM ECD
GROUP BY county_tier;

---How many companies are LLCs? Call this value llc_companies. (Hint, combine COUNT() and DISTINCT(). Also, consider that LLC may not always be capitalized the same in company names. Find a SQL keyword that can help you with this.)
SELECT COUNT(DISTINCT company) AS llc_companies
FROM ecd
WHERE UPPER(company) LIKE '%LLC%';
--114

-- -- SELECT COUNT(DISTINCT company) AS llc_companies
-- FROM ecd
-- WHERE LOWER(company) LIKE '%llc%'
-- or company like '%LLC%'
-- or company like '%Llc%';
