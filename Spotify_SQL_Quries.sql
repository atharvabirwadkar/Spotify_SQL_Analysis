select*
from spotify;

SELECT artist, track, views, likes, stream
FROM spotify
ORDER BY stream DESC;

SELECT DISTINCT album_type
FROM spotify;

select *
from spotify
ORDER BY duration_min;

-- ----------------------------------------------------------------------
-- BUSINESS PROBLEMS

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT *
FROM spotify
WHERE stream > 1000000000;

-- 2. List all albums along with their respective artists.

SELECT DISTINCT album, artist
FROM spotify
ORDER BY 1;

-- 3. Get the total number of comments for tracks where licensed = TRUE

SELECT SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';

-- 4. Find all tracks that belong to the album type single.

SELECT *
FROM spotify
WHERE album_type = 'single';

-- 5. Count the total number of tracks by each artist.

SELECT artist, count(*) as total_track
FROM spotify
GROUP BY artist;
 
-- 6. Calculate the average danceability of tracks in each album.

SELECT album, AVG(danceability) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;

-- 7. Find the top 5 tracks with the highest energy values.

SELECT track, MAX(energy)
FROM spotify
GROUP BY track
ORDER BY MAX(energy) DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.

SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'True'
GROUP BY track
ORDER BY total_views DESC
LIMIT 5;

-- 9. For each album, calculate the total views of all associated tracks.

SELECT album, track, SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(
SELECT track,
-- most_playedon, 
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_Spotify,
    COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_Youtube
FROM spotify
GROUP BY track
) AS t1
WHERE streamed_on_Spotify > streamed_on_Youtube
	AND streamed_on_Youtube <> 0 ;	
    
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist AS 
(
SELECT artist, track, 
	SUM(views) ,
	RANK()OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as ranked
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE ranked <=3;

-- 12. Write a query to find tracks where the liveness score is above the average.

SELECT artist, track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY 3 DESC;

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte AS
(
	SELECT 
		album,
        MIN(energy) AS min_energy,
        MAX(energy) AS max_energy
	FROM spotify
    GROUP BY album
)
SELECT 
	album,
	max_energy - min_energy AS energy_difference
FROM cte
ORDER BY 2 DESC;
	
