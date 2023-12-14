--exercise 5--

WITH ContinentMedian AS (
    SELECT
        year,
        continent_code,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY convert(float,gdp_per_capita)) OVER (PARTITION BY continent_code, year) AS median_gdp_per_capita
    FROM
        per_capita p
    JOIN
        continent_map c ON p.country_code = c.country_code
    WHERE
        year BETWEEN 2004 AND 2012
)
SELECT DISTINCT
    year,
    continent_code AS Continent,
    median_gdp_per_capita AS [Median GDP Per Capita]
FROM
    ContinentMedian
ORDER BY
    continent_code,year