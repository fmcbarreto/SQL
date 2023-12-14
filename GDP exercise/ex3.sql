--exercise 3--
with table_total as(
SELECT sum(convert(float,gdp_per_capita)) as total 
from per_capita),

aux_table as(
SELECT case when continent_code ='NA' or continent_code ='EU' then continent_code 
		else 'Rest of the World'
		end continent_code, gdp_per_capita 
		from per_capita p
JOIN continent_map c
on c.country_code = p.country_code),

second_table as(
SELECT continent_code, sum(convert(float,gdp_per_capita)) as total_cont 
from aux_table
GROUP BY continent_code),

final_table as(
SELECT continent_code, total_cont/total*100 as per from second_table
CROSS JOIN table_total)
SELECT
    MAX(CASE WHEN continent_code = 'NA' THEN per END) AS NA,
    MAX(CASE WHEN continent_code = 'EU' THEN per END) AS EU,
    MAX(CASE WHEN continent_code = 'Rest of the World' THEN per END) AS [Rest of the World]
FROM final_table;
