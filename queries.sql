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
    Titre VARCHAR(255),
    `Durée(min)` INT,
    `Réalisateur·ice` VARCHAR(255),
    `Acteur·ice` VARCHAR(255),
    `Année de sortie` DATE,
    Synopsis TEXT,
    Commentaire TEXT,
    `En avant-première` BOOLEAN,
    `Date début d’exploitation` DATE,
    `Date de fin d’exploitation` DATE,
    Restriction VARCHAR(255),
    Categories VARCHAR(255)
);

LOAD DATA INFILE '/var/lib/mysql-files/movies.csv'
INTO TABLE temp_table_csv
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Stored procedure to explode the name into two columns
DELIMITER //
CREATE PROCEDURE insert_into_person()
BEGIN
    -- Insert data into the person table, splitting the name into first and last name
    INSERT INTO person (first_name, last_name)
    SELECT 
        SUBSTRING_INDEX(Réalisateur·ice, ' ', 1) AS first_name,
        CASE WHEN INSTR(Réalisateur·ice, ' ') > 0 
             THEN SUBSTRING_INDEX(Réalisateur·ice, ' ', -1)
             ELSE NULL 
        END AS last_name
    FROM temp_table_person_distinct;
END;
DELIMITER ;

-- Show data from the temporary table
SELECT * FROM temp_table_csv;

SELECT `Réalisateur·ice` FROM temp_table_csv;

-- Select distinct rows from the temporary table
CREATE TEMPORARY TABLE temp_table_person_distinct AS
SELECT DISTINCT `Réalisateur·ice` FROM temp_table_csv;

-- Insert film director into the person table, splitting the name into first and last name
CALL insert_into_person();

-- Drop the temporary table holding distinct values
DROP TEMPORARY TABLE IF EXISTS temp_table_person_distinct;

DROP TEMPORARY TABLE IF EXISTS temp_table_csv;
