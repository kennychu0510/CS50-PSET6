SELECT name FROM people WHERE id IN
    (SELECT DISTINCT person_id FROM stars WHERE movie_ID IN
            (SELECT movie_id FROM stars --All movies in which Kevin Bacon starred
                WHERE person_id = (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = 1958)))
                AND NOT (name = "Kevin Bacon" AND birth = 1958)

