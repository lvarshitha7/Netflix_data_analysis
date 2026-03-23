--netflix Project 
DROP TABLE if EXISTS netflix;
CREATE TABLE netflix( 
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT ,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);
select * from netflix;

--netflix Project 
DROP TABLE if EXISTS netflix;
CREATE TABLE netflix( 
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT ,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);
select * from netflix;

select count(*) as total_count from netflix;

-- Count the Number of Movies vs TV Shows
select type,count(*) from netflix group by type;

--Find the Most Common Rating for Movies and TV Shows
select 
	type, 
	rating
	from 
(
select type ,rating , count(*),
RANK() over(partition by TYPE order by COUNT(*) desc) as ranking
from netflix 
group by 1, 2 
) as q1

where ranking = 1;


--List all movies released in a specific year (e.g . 2020)
select * from netflix 
where type= 'Movie' and 
release_year = 2020; 


-- Top 5 countries with the most content on Netflix

select UNNEST(STRING_TO_ARRAY(country,',')) as new_country, count(show_id) as total_content
from netflix 
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5

-- select UNNEST(STRING_TO_ARRAY(country,',')) as new_country from netflix 


--Indentify longest movie

select * from netflix 
WHERE 
	type='Movie'
	and
	duration= (SELECT MAX(duration) FROM netflix)

--Find content added in last 5 years
SELECT *, date_added 
from netflix 
where 
	date_added >= CURRENT_DATE - INTERVAL '5 years'
	
-- Content added in last 5 years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')
>= CURRENT_DATE - INTERVAL '5 years';

--Find all the movies /Tv shows by director 'Rajiv Chilaka'

select * from netflix where director ILIKE '%Rajiv Chilaka%'


--List all TV Shows with more than 5 Seasons

SELECT 
	*	
FROM netflix 
WHERE 
	type='TV Show'
	AND
	SPLIT_PART(duration , ' ',1)::numeric > 5 

-- Count the number of content items in each genre
SELECT 
	
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

--Find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT(Year FROM TO_DATE(date_added,'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India')::numeric * 100
	,2) as avg_content_per_year
FROM netflix 
WHERE country ='India'
GROUP By 1

--List all movies that are documentries

SELECT * FROM netflix 
where 
	listed_in LIKE '%Documentaries%'

--Find all content without a director
 Select * from netflix 
 WHERE 
 	director IS NULL

--Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT * FROM netflix 
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(Year FROM CURRENT_DATE) - 10

--Find the top 10 actors who have appeared in the highest number of 
-- movies produced in India

SELECT 

UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
where country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC

--Categorize the content based on the presence of the keywords
-- 'Kill' and 'Violence' in the description field. Label content containg 
-- these keywords as 'Bad' and all other content as 'Good'. Count 
-- how many items fall into each category


WITH new_table
as
(
SELECT 
*,
	CASE
	WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good Content'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT(*) as total_content 
FROM new_table
GROUP BY 1




