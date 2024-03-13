-- Create a view for weekday cinema room reserved sessions
/* This method is creating a vue, it concatenates multiple thing, first the string and the number of the cinea room. 
Second Groud concat is used to group the results in the same cell. 
Records are separated in a comma then space */
CREATE OR REPLACE VIEW sessions_plan_week AS
SELECT s.slot, GROUP_CONCAT(CONCAT('Salle ', cr.name)SEPARATOR ', ') AS cinema_room
FROM session s
JOIN session_has_movie_screening shms ON s.id = shms.session_id AND shms.is_weekday = 0
JOIN cinema_room cr ON shms.cinema_room_id = cr.id
GROUP BY s.slot;

-- Create a view for weekend cinema room reserved sessions
CREATE OR REPLACE VIEW sessions_plan_weekend AS
SELECT s.slot, GROUP_CONCAT(CONCAT('Salle ', cr.name)SEPARATOR ', ') AS cinema_room
FROM session s
JOIN session_has_movie_screening shms ON s.id = shms.session_id AND shms.is_weekday = 1
JOIN cinema_room cr ON shms.cinema_room_id = cr.id
GROUP BY s.slot;





