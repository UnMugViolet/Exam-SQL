------------------------------------------------------------
-- 1. Create views for the cinema room reserved sessions plan
------------------------------------------------------------

/* This method is creating a vue, it concatenates multiple thing, first the string and the number of the cinea room. 
Second Groud concat is used to group the results in the same cell. 
Records are separated in a comma then space */
CREATE OR REPLACE VIEW sessions_plan_week AS
SELECT s.slot, GROUP_CONCAT(CONCAT('Salle ', cr.name) SEPARATOR ', ') AS cinema_room
FROM session s
JOIN session_has_movie_screening shms ON s.id = shms.session_id AND shms.is_weekday = 0
JOIN cinema_room cr ON shms.cinema_room_id = cr.id
GROUP BY s.slot, s.time
ORDER BY s.time;

-- Create a view for weekend cinema room reserved sessions
CREATE OR REPLACE VIEW sessions_plan_weekend AS
SELECT s.slot, GROUP_CONCAT(CONCAT('Salle ', cr.name)SEPARATOR ', ') AS cinema_room
FROM session s
JOIN session_has_movie_screening shms ON s.id = shms.session_id AND shms.is_weekday = 1
JOIN cinema_room cr ON shms.cinema_room_id = cr.id
GROUP BY s.slot, s.time
ORDER BY s.time;

------------------------------------------------------------
-- 2. 3. Import data from csv `movies.csv` into the database
------------------------------------------------------------

/*
In case of restriction from MySQL, you can use the following command to allow the import of data from a file:
*/
CREATE TEMPORARY TABLE temp_table_csv
(
    `Titre` VARCHAR(255),
    `Durée(min)` INT,
    `Réalisateur·ice` VARCHAR(255),
    `Acteur·ice` VARCHAR(255),
    `Année de sortie` DATE,
    `Synopsis` TEXT,
    `Commentaire` TEXT,
    `En avant-première` BOOLEAN,
    `Date début d’exploitation` DATE,
    `Date de fin d’exploitation` DATE,
    `Restriction` VARCHAR(255),
    `Réalisateur·ice ID` INT,
    `Catégories` VARCHAR(255)
);

LOAD DATA INFILE '/var/lib/mysql-files/movies.csv'
INTO TABLE temp_table_csv
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Show data from the temporary table
SELECT * FROM temp_table_csv;

/*
Start logic for importing the data regarding the movie directors
That code is creating a temporary table to store the distinct values of the directors. 
Then it is inserting the data into the person table, splitting the name into first and last name. 
Finally, it is dropping the temporary table holding distinct values
*/
CREATE TEMPORARY TABLE temp_table_person_distinct AS
SELECT DISTINCT `Réalisateur·ice` FROM temp_table_csv;

-- Insert data into the person table, splitting the name into first and last name
INSERT INTO person (first_name, last_name)
SELECT 
    SUBSTRING_INDEX(Réalisateur·ice, ' ', 1) AS first_name,
    CASE WHEN INSTR(Réalisateur·ice, ' ') > 0 
            THEN SUBSTRING_INDEX(Réalisateur·ice, ' ', -1)
            ELSE NULL 
    END AS last_name
FROM temp_table_person_distinct;

-- Drop the temporary table holding distinct values of film directors
DROP TEMPORARY TABLE IF EXISTS temp_table_person_distinct;

/* 
Start logic for importing the data regarding the movie into the movie table
*/
CREATE TEMPORARY TABLE temp_table_movie AS
SELECT DISTINCT `Titre`, `Durée(min)`, `Année de sortie`, `Synopsis`, `Commentaire`, `Restriction`, `Réalisateur·ice ID` FROM temp_table_csv;

-- Show data from the temporary table importing the movies
SELECT * FROM temp_table_movie;
-- Insert data related to movie into the movie table
INSERT INTO movie (title, synopsis, time_duration, release_date, aditional_comment, authorization_scale_id, director_id)
SELECT 
    `Titre` AS title,
    `Synopsis` AS synopsis,
    `Durée(min)` AS time_duration,
    `Année de sortie` AS release_date,
    `Commentaire` AS aditional_comment,
    CASE 
        WHEN `Restriction` = 'Tout public' THEN 1
        WHEN `Restriction` = 'Interdit aux moins de douze ans' THEN 2
        WHEN `Restriction` = 'Interdit aux moins de seize ans' THEN 3
        WHEN `Restriction` = 'Interdit aux mineurs' THEN 4
        ELSE NULL
    END AS authorization_scale_id,
    `Réalisateur·ice ID` AS director_id
FROM temp_table_movie;
DROP TEMPORARY TABLE IF EXISTS temp_table_movie;

-- Drop the main table responsible of the global import
DROP TEMPORARY TABLE IF EXISTS temp_table_csv;

--------------------------------------------------------------
-- 4. Request the movie per director order by date of release
--------------------------------------------------------------
SELECT m.title
FROM movie m
JOIN director d ON m.director_id = d.id
JOIN person p ON d.person_id = p.id
WHERE p.first_name = 'Peter' AND p.last_name = 'Jackson'
ORDER BY m.release_date;

--------------------------------------------------------------
-- 5. Request the movie where Viggo Mortensen is an actor 
--------------------------------------------------------------
SELECT m.title, p.first_name, p.last_name
FROM movie m
JOIN actor_has_movie am ON m.id = am.movie_id
JOIN actor a ON am.actor_id = a.id
JOIN person p ON a.person_id = p.id
WHERE p.first_name = 'Viggo' AND p.last_name = 'Mortensen';

--------------------------------------------------------------
-- 6. Request the movie where Viggo Mortensen and Ian McKellen are actors
--------------------------------------------------------------

SELECT m.title
FROM movie m
JOIN actor_has_movie am ON m.id = am.movie_id
JOIN actor a ON am.actor_id = a.id
JOIN person p ON a.person_id = p.id
WHERE (p.first_name = 'Viggo' AND p.last_name = 'Mortensen') OR 
      (p.first_name = 'Ian' AND p.last_name = 'McKellen')
GROUP BY m.id, m.title
HAVING COUNT(DISTINCT p.id) = 2;


--------------------------------------------------------------
-- 7. Transform time duration from minutes in hours and minutes
--------------------------------------------------------------

DELIMITER //
CREATE FUNCTION format_movie_duration(duration_in_min INT) 
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE hours INT;
    DECLARE minutes INT;
    SET hours = FLOOR(duration_in_min / 60);
    SET minutes = MOD(duration_in_min, 60);
    RETURN CONCAT(hours, 'h', LPAD(minutes, 2, '0'));
END//
DELIMITER ;

SELECT format_movie_duration(133);

--------------------------------------------------------------
-- 8. Display complete record of the movie Anatomie d'une chute
--------------------------------------------------------------
CREATE VIEW movie_summary AS
SELECT 
    m.title AS 'Title',
    m.synopsis AS 'Synopsis',
    CONCAT(p1.first_name, ' ', p1.last_name) AS 'Director',
    GROUP_CONCAT(DISTINCT CONCAT(p2.first_name, ' ', p2.last_name) SEPARATOR ', ') AS 'Actors',
    format_movie_duration(m.time_duration) AS 'Duration',
    GROUP_CONCAT(DISTINCT t.label SEPARATOR ', ') AS 'Genres',
    m.aditional_comment AS 'Comment'
FROM 
    movie m
JOIN 
    director d ON m.director_id = d.id
JOIN 
    person p1 ON d.person_id = p1.id
JOIN 
    actor_has_movie am ON m.id = am.movie_id
JOIN 
    actor a ON am.actor_id = a.id
JOIN 
    person p2 ON a.person_id = p2.id
JOIN 
    type_has_movie tm ON m.id = tm.movie_id
JOIN 
    type t ON tm.type_id = t.id
JOIN 
    authorization_scale a_s ON m.authorization_scale_id = a_s.id
WHERE 
    m.id = 5
GROUP BY 
    m.id;


--------------------------------------------------------------
-- 9. Create stored procedure to display summary of a movie
--------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE movie_summary(IN movie_id INT)
BEGIN
    SELECT 
        m.title AS 'Title',
        m.synopsis AS 'Synopsis',
        CONCAT(p1.first_name, ' ', p1.last_name) AS 'Director',
        GROUP_CONCAT(DISTINCT CONCAT(p2.first_name, ' ', p2.last_name) SEPARATOR ', ') AS 'Actors',
        format_movie_duration(m.time_duration) AS 'Duration',
        GROUP_CONCAT(DISTINCT t.label SEPARATOR ', ') AS 'Genres',
        m.aditional_comment AS 'Comment'
    FROM 
        movie m
    JOIN 
        director d ON m.director_id = d.id
    JOIN 
        person p1 ON d.person_id = p1.id
    JOIN 
        actor_has_movie am ON m.id = am.movie_id
    JOIN 
        actor a ON am.actor_id = a.id
    JOIN 
        person p2 ON a.person_id = p2.id
    JOIN 
        type_has_movie tm ON m.id = tm.movie_id
    JOIN 
        type t ON tm.type_id = t.id
    JOIN 
        authorization_scale a_s ON m.authorization_scale_id = a_s.id
    WHERE 
        m.id = movie_id
    GROUP BY 
        m.id;
END//
DELIMITER ;

-- Call the stored procedure to display the summary of the movie by id
CALL movie_summary(2);

--------------------------------------------------------------
-- 10. Create prepared statement to plan the sessions of a movie
--------------------------------------------------------------

-- Program "Le Seigneur des Anneaux : la communauté de l’anneau" in VF on all "Matin" sessions in "Salle 01"
INSERT INTO movie_screening (movie_id, language_id, session_has_movie_screening_session_id, session_has_movie_screening_cinema_room_id, is_preview, day_screening_id)
SELECT 
    (SELECT id FROM movie WHERE title = "Le Seigneur des Anneaux : La communauté de l'anneau") AS movie_id,
    (SELECT id FROM language WHERE label = 'VF') AS language_id,
    1,
    (SELECT id FROM cinema_room WHERE name = '01') AS cinema_room_id,
    0 AS is_preview,
    1 AS day_screening_id -- Constraint here due to DB creation, real case would be to create in the mean time the days where this screening occurs
FROM 
    session
WHERE 
    slot = 'Matin';

-- Program "Anatomie d’une chute" in VF on all "Après-Midi 2" weekday sessions and "Soirée" weekend sessions in "Salle 03"
INSERT INTO movie_screening (movie_id, language_id, session_has_movie_screening_session_id, session_has_movie_screening_cinema_room_id, is_preview, day_screening_id)
SELECT 
    (SELECT id FROM movie WHERE title = "Anatomie d'une chute") AS movie_id,
    (SELECT id FROM language WHERE label = 'VF') AS language_id,
    s.id AS session_id,
    (SELECT id FROM cinema_room WHERE name = '03') AS cinema_room_id,
    0 AS is_preview,
    1 AS day_screening_id -- Constraint here due to DB creation, real case would be to create in the mean time the days where this screening occurs
FROM 
    session_has_movie_screening shms
JOIN 
    session s ON shms.session_id = s.id
WHERE 
    (s.slot = 'Après-Midi 2' AND shms.is_weekday = 1) OR (s.slot = 'Soirée' AND shms.is_weekday = 0);

--------------------------------------------------------------
-- 11. List the movie screenings of the movies during the week
--------------------------------------------------------------
SELECT 
    m.title AS 'Movie Title',
    l.label AS 'Language',
    s.slot AS 'Session',
    cr.name AS 'Cinema Room',
    ms.is_preview AS 'Is Preview',
    ds.id AS 'Day Screening ID'
FROM 
    movie_screening ms
JOIN 
    movie m ON ms.movie_id = m.id
JOIN 
    language l ON ms.language_id = l.id
JOIN 
    session s ON ms.session_has_movie_screening_session_id = s.id
JOIN 
    cinema_room cr ON ms.session_has_movie_screening_cinema_room_id = cr.id
JOIN 
    day_screening ds ON ms.day_screening_id = ds.id
WHERE 
    ds.id IN (1, 2, 3)
ORDER BY ds.id, s.time;

--------------------------------------------------------------
-- 12. Register two seats 
--------------------------------------------------------------
INSERT INTO
    visitor_has_movie_screening (
        visitor_id, movie_screening_id, price_category_id
    )
VALUES (
        11, (
            SELECT ms.id
            FROM
                movie_screening ms
                JOIN movie m ON ms.movie_id = m.id
                JOIN session s ON ms.session_has_movie_screening_session_id = s.id
                JOIN day_screening ds ON ms.day_screening_id = ds.id
                JOIN cinema_room cr ON ms.session_has_movie_screening_cinema_room_id = cr.id
                JOIN language l ON ms.language_id = l.id
            WHERE
                m.id = 1
                AND s.time = '10:00:00'
                AND ds.date = '2024-03-10'
                AND l.label = 'VF'
                AND cr.name = '01'
        ), (
            SELECT id
            FROM price_category
            WHERE
                label = 'Tarif plein'
        )
    ),
    (
        12, (
            SELECT ms.id
            FROM
                movie_screening ms
                JOIN movie m ON ms.movie_id = m.id
                JOIN session s ON ms.session_has_movie_screening_session_id = s.id
                JOIN day_screening ds ON ms.day_screening_id = ds.id
                JOIN cinema_room cr ON ms.session_has_movie_screening_cinema_room_id = cr.id
                JOIN language l ON ms.language_id = l.id
            WHERE
                m.id = 1
                AND s.time = '10:00:00'
                AND ds.date = '2024-03-10'
                AND l.label = 'VF'
                AND cr.name = '01'
        ), (
            SELECT id
            FROM price_category
            WHERE
                label = "Tarif demandeur d'emploi" 
        )
    );


-- Display the two tickets
SELECT 
    vhm.visitor_id,
    vhm.movie_screening_id,
    vhm.price_category_id,
    m.title AS 'Movie Title',
    s.time AS 'Session Time',
    ds.date AS 'Screening Date',
    l.label AS 'Language',
    pc.label AS 'Price Category',
    cr.name AS 'Cinema Room'
FROM 
    visitor_has_movie_screening vhm
LEFT JOIN 
    movie_screening ms ON vhm.movie_screening_id = ms.id
LEFT JOIN 
    movie m ON ms.movie_id = m.id
LEFT JOIN 
    session s ON ms.session_has_movie_screening_session_id = s.id
LEFT JOIN 
    day_screening ds ON ms.day_screening_id = ds.id
LEFT JOIN 
    language l ON ms.language_id = l.id
LEFT JOIN 
    price_category pc ON vhm.price_category_id = pc.id
JOIN
    cinema_room cr ON ms.session_has_movie_screening_cinema_room_id = cr.id
WHERE 
    vhm.visitor_id IN (11, 12);


--------------------------------------------------------------
-- 13. Request number of seats available for a movie screening
--------------------------------------------------------------
SELECT 
    ds.date AS 'Screening Date',
    s.time AS 'Session Time',
    cr.name AS 'Cinema Room',
    cr.max_capacity - COUNT(vhm.visitor_id) AS 'Remaining Seats'
FROM 
    cinema_room cr
LEFT JOIN 
    movie_screening ms ON cr.id = ms.session_has_movie_screening_cinema_room_id
LEFT JOIN 
    visitor_has_movie_screening vhm ON ms.id = vhm.movie_screening_id
LEFT JOIN 
    session s ON ms.session_has_movie_screening_session_id = s.id
LEFT JOIN 
    day_screening ds ON ms.day_screening_id = ds.id
WHERE 
    s.time = '10:00:00' AND ds.date = '2024-03-10'
GROUP BY 
    cr.name, cr.max_capacity;
