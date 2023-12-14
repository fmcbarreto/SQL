--exercise 1--

with continent_map_case as (
SELECT 
case when len(country_code) > 0 
then country_code 
else 'N/A' 
end col
from continent_map),

first_querie as(
SELECT * , count(col) as total from continent_map_case 
WHERE col = 'N/A'
GROUP BY col),

second_querie as(
SELECT * , count(col) as total from continent_map_case 
WHERE col <> 'N/A'
GROUP BY col)
SELECT * from first_querie 
UNION 
SELECT * from second_querie





