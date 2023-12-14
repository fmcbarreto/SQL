--exercise 2--	

SELECT TOP 10 *, rank() OVER(ORDER BY gdp_per desc) as RANK
from(
SELECT first_table.country_code, countries.country_name, continents.continent_name, (convert(float,gdp_per_capita)-convert(float,gdp_per_capita_2011))/convert(float,gdp_per_capita_2011)*100 as gdp_per 
from (
	SELECT * , lag(gdp_per_capita) OVER(Order by country_code) as gdp_per_capita_2011 
	from per_capita 
	where year between 2011 and 2012 AND convert(float,gdp_per_capita)>0
	GROUP BY country_code, year, gdp_per_capita
	) first_table
JOIN countries
ON countries.country_code = first_table.country_code
JOIN continent_map
ON countries.country_code = continent_map.country_code
JOIN continents
ON continent_map.continent_code = continents.continent_code
where	year = 2012) second_table
ORDER BY gdp_per desc, country_code