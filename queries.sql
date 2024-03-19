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

