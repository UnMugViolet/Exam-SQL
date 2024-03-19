-- Create a view for weekday cinema room reserved sessions
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


-- Import data from csv `movies.csv` into the database
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

