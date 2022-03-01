SELECT title FROM movies
JOIN ratings ON movies.id = ratings.movie_id
WHERE id IN (SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Johnny Depp"))
AND id IN (SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Helena Bonham Carter"))
ORDER BY rating DESC;