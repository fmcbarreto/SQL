--exercise 4-- 
with first_table as(
SELECT continent_code, count(c.country_code) pais_por_cont from countries c
JOIN continent_map con
on c.country_code =con.country_code
GROUP BY continent_code),

second_table as(
SELECT continent_code, year, sum(convert(float,gdp_per_capita)) as soma_cont_ano from countries c
JOIN continent_map con
on c.country_code =con.country_code
JOIN per_capita p
on p.country_code = c.country_code
GROUP BY continent_code,year),

final_table as(
SELECT s.*,pais_por_cont from second_table s
JOIN first_table f
on s.continent_code = f.continent_code)
SELECT continent_code,year , soma_cont_ano/pais_por_cont as average_per_cont_year from final_table
ORDER BY continent_code, year
