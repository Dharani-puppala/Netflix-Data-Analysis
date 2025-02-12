DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id	VARCHAR(8),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts  VARCHAR(1000),	
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,	
	rating VARCHAR(10),	
	duration VARCHAR(15),	
	listed_in VARCHAR(100),	
	description VARCHAR(250)
);

SELECT * FROM 	netflix;
-- total columns
SELECT 
	COUNT(*) AS total_content
FROM netflix;
-- total columns in type
SELECT 
	COUNT(type) AS  total_type
FROM netflix;

--Distinct values of column
SELECT 
	DISTINCT type
FROM netflix;

--NULL VALUES OF A COLUMNS
SELECT casts, title
FROM netflix
WHERE casts IS NULL;

-- 1 count number of tv shows vs movie
SELECT type, COUNT(type) as movie_count
FROM netflix
GROUP BY type;

-- common ratings for tvshows and movies
SELECT type, COUNT(type) as rd,rating
FROM netflix
GROUP BY type,rating
ORDER BY rd DESC;
-- LIST ALL THE MOVIES REALESD IN YEAR 2020
SELECT * FROM netflix
WHERE type='Movie' AND release_year=2020;

-- Top 5 countires which has most content in netflix
SELECT country,COUNT(*) as con_count FROM netflix
GROUP BY country
ORDER BY con_count DESC;

-- since we have mutliple countries clubbed together we will change it to individual using array
SELECT STRING_TO_ARRAY(country,',') as new_country
FROM netflix
-- since we have an arrya we array change it in to individual by unnesting it
SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country
FROM netflix;

--
SELECT UNNEST(STRING_TO_ARRAY(country,',')) as new_country , COUNT(*) AS new_count
FROM netflix
GROUP BY new_country
ORDER BY new_count DESC
LIMIT 5;

-- Identify the longest movi

-- this gives all movies of all duration
SELECT title,type, duration FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY duration DESC;
-- this gives only one moviwe with highest duration
SELECT title,type, duration FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY duration DESC
LIMIT 1;

-- to get all movies of highest duration 
SELECT title,type,duration FROM netflix
WHERE type='Movie' AND duration= (SELECT MAX(duration) FROM netflix);


-- Find content added in the last 5 years
-- gives years greathan we give
SELECT  CAST(RIGHT(date_added, 4) AS INT)  AS years FROM netflix
WHERE  CAST(RIGHT(date_added, 4) AS INT)  >= 2019;

--
SELECT * FROM netflix
WHERE  TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL'5 years'

-- ALL movies directed by Yoshiyuki Tomino
SELECT* FROM netflix
WHERE  director LIKE'%Rajiv Chilaka%'
SELECT* FROM netflix
WHERE  director LIKE'%Marcus Raboy%'
SELECT* FROM netflix
WHERE  director ILIKE'%Yoshiyuki Tomino%';


SELECT director, COUNT(*) AS SUJ FROM netflix
GROUP BY director
ORDER BY SUJ DESC;

-- all tv showsmore than 5 seasons
SELECT*FROM netflix
WHERE type='TV Show' AND CAST(SPLIT_PART(duration, ' ' ,1) AS INT) >=5;
-- count no of content items in each gerne
SELECT  UNNEST(STRING_TO_ARRAY(listed_in,',')) as gerne, COUNT(show_id)
FROM netflix
GROUP BY gerne;
--FIND EACH YEAR AND AVERAGE NO OF CONTENT EREALSE IN INDIA
SELECT
		EXTRACT(YEAR FROM(TO_DATE(date_added,'Month,DD,YYYY'))) AS years,
		COUNT(*),
		ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric*100,2) AS avg_content
FROM netflix
WHERE country ILIKE'%India%'
GROUP BY years
ORDER BY avg_content DESC;

-- LIST ALL MOVIE STHAT ARE DOCUMENTARIES
SELECT* FROM netflix
WHERE type='Movie' and listed_in ILIKE'%Documentaries%'

-- all content with out dierector
SELECT*FROM netflix
WHERE director IS NULL

-- HOW MANY MOVIES ACTOR   John Cleese APPEARED IN LAST 10 YEARS
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS CRUE,COUNT(*) AS cnt FROM netflix
GROUP BY CRUE
ORDER BY cnt  DESC

SELECT * FROM netflix
WHERE casts ILIKE('%John Cleese%') AND release_year >EXTRACT(YEAR FROM CURRENT_DATE) - 10

--  Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS CST, COUNT(*) AS CNT FROM netflix
WHERE country ILIKE('%India%')
GROUP BY CST
ORDER BY CNT DESC
LIMIT 10
-- ALL MOVIES RESALED IN 2020
SELECT* FROM netflix
WHERE release_year= 2020;
-- top5 countires with most content in india
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;