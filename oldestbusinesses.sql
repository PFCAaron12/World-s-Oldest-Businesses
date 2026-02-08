--The range of the founding years of the oldest companies in the world
SELECT 
	MIN(year_founded) as start_year,
	MAX(year_founded) as end_year
FROM businesses;

--The oldest company in the world and the industry it belongs to
SELECT 
	b. business AS business,
	c. category AS industry
FROM businesses AS b
LEFT JOIN categories AS c
ON b.category_code = c.category_code
ORDER BY b.year_founded
LIMIT 1;

--How many companies — and which ones — were founded before 1000 AD
SELECT
	business
FROM businesses
WHERE year_founded < 1000;

--The most common industries to which the oldest companies belong to
SELECT
	c.category,
	COUNT(*) AS businesses_count
FROM categories AS c
LEFT JOIN businesses AS b
ON c.category_code = b.category_code
GROUP BY c.category
ORDER BY businesses_count DESC
LIMIT 5;
	
--The oldest companies by continent
SELECT 
	continent,
	COUNT(*) AS businesses_count
FROM countries AS co
LEFT JOIN businesses AS b
ON co.country_code = b.country_code
GROUP BY continent;

--The most common industries for the oldest companies on each continent
WITH IndustryCounts AS (
    SELECT
        co.continent,
        c.category,
        COUNT(b.business) AS businesses_count,
        ROW_NUMBER() OVER (
            PARTITION BY co.continent
            ORDER BY COUNT(b.business) DESC, c.category ASC
        ) AS row_num
    FROM
        countries AS co
    INNER JOIN
        businesses AS b ON co.country_code = b.country_code
    INNER JOIN
        categories AS c ON b.category_code = c.category_code
    GROUP BY
        co.continent, c.category
)
SELECT
    continent,
    category AS most_common_industry,
    businesses_count
FROM
    IndustryCounts
WHERE
    row_num = 1
ORDER BY
    continent ASC;




