create database project

use project

--import the dataset--

select * from netflix_titles

-- 1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS count FROM netflix_titles GROUP BY type;

-- 2. Find the most common rating for movies and TV shows
SELECT type, rating, COUNT(*) AS count 
FROM netflix_titles 
WHERE rating IS NOT NULL
GROUP BY type, rating 
ORDER BY count DESC;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix_titles WHERE type = 'Movie' AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT TOP 5 country, COUNT(*) AS count 
FROM netflix_titles 
WHERE country IS NOT NULL
GROUP BY country 
ORDER BY count DESC;

-- 5. Identify the longest movie (assuming 'duration' is in 'NN min' format)
SELECT TOP 1 * FROM netflix_titles 
WHERE type = 'Movie' 
AND duration LIKE '%min%'
ORDER BY CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) DESC;

-- 6. Find content added in the last 5 years
SELECT * FROM netflix_titles 
WHERE date_added IS NOT NULL 
AND YEAR(CAST(date_added AS DATE)) >= YEAR(GETDATE()) - 5;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * FROM netflix_titles WHERE director = 'Rajiv Chilaka';

-- 8. List all TV shows with more than 5 seasons
SELECT * FROM netflix_titles 
WHERE type = 'TV Show' 
AND duration LIKE '%Season%' 
AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;

-- 9. Count the number of content items in each genre
SELECT listed_in, COUNT(*) AS count 
FROM netflix_titles 
GROUP BY listed_in 
ORDER BY count DESC;

-- 10. Find the top 5 years with the highest average content released in India
SELECT TOP 5 release_year, AVG(count) AS avg_content 
FROM (
    SELECT release_year, COUNT(*) AS count 
    FROM netflix_titles 
    WHERE country = 'India' 
    GROUP BY release_year
) AS yearly_counts
GROUP BY release_year 
ORDER BY avg_content DESC;

-- 11. List all movies that are documentaries
SELECT * FROM netflix_titles 
WHERE type = 'Movie' 
AND listed_in LIKE '%Documentary%';

-- 12. Find all content without a director
SELECT * FROM netflix_titles 
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in the last 10 years
SELECT COUNT(*) AS movie_count 
FROM netflix_titles 
WHERE type = 'Movie' 
AND cast LIKE '%Salman Khan%' 
AND release_year >= YEAR(GETDATE()) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT TOP 10 c.actor, COUNT(*) AS movie_count 
FROM (
    SELECT TRIM(value) AS actor 
    FROM netflix_titles 
    CROSS APPLY STRING_SPLIT(cast, ',') 
    WHERE type = 'Movie' AND country = 'India'
) AS c
GROUP BY c.actor 
ORDER BY movie_count DESC;

-- 15. Categorize content based on keywords 'kill' and 'violence' in description
SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad' 
        ELSE 'Good' 
    END AS category,
    COUNT(*) AS count 
FROM netflix_titles 
GROUP BY 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad' 
        ELSE 'Good' 
    END;