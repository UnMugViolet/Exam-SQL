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
CREATE TEMPORARY TABLE temp_table
(
    Titre VARCHAR(255),
    `Durée(min)` INT,
    `Réalisateur·ice` VARCHAR(255),
    `Acteur·ice` VARCHAR(255),
    `Année de sortie` DATE,
    Synopsis TEXT,
    Commentaire TEXT,
    `En avant-première` BOOLEAN,
    `Durée d'exploitation(sem)` INT,
    Restriction VARCHAR(255),
    Categories VARCHAR(255)
);
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE '/home/paul/Desktop/Developpement/Exam-SQL/ressources/movies.csv'
INTO TABLE temp_table
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

INSERT INTO person (first_name, last_name)
SELECT DISTINCT SUBSTRING_INDEX(`Réalisateur·ice`, ' ', 1), SUBSTRING_INDEX(`Réalisateur·ice`, ' ', -1)

INSERT INTO movie (title, synopsis, time_duration, release_date, aditional_comment, authorization_scale_id, director_id)
SELECT t.Titre, t.Synopsis, t.`Durée(min)`, t.`Année de sortie`, t.Commentaire, a.id, d.id


