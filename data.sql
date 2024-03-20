USE `exam_sql_paul_jaguin`;

/*
Add the data related to the licence in the database
*/
INSERT INTO `licence` (`date_begin_exploitation`, `date_end_exploitation`, `movie_id`)
VALUES
('2024-03-10', '2024-04-07', 1), 
('2024-03-09', '2024-04-06', 2), 
('2024-03-10', '2024-04-07', 3), 
('2024-03-01', '2024-03-15', 4), 
('2024-03-11', '2024-04-22', 5); 

/*
List fil language
*/
INSERT INTO `language` (`label`)
VALUES
('VOSTFR'),
('VO'),
('VF');

/*
List of authorization scale
*/
INSERT INTO `authorization_scale` (`age`, `type`)
VALUES
(0, 'Tout public'),
(12, 'Interdit aux moins de douze ans'),
(16, 'Interdit aux moins de seize ans'),
(18, 'Interdit aux mineurs');

/*
List all prices available
*/
INSERT INTO `price_category` (`label`, `price`)
VALUES
('Tarif plein', 980),
('Tarif étudiant', 500),
('Tarif demandeur d''emploi', 500),
('Tarif -14 ans', 380);

/*
List all cinema rooms in the database
*/
INSERT INTO `cinema_room` (`name`, `max_capacity`)
VALUES
('01', 100),
('02', 150),
('03', 200);

/*
Add all the sessions casses available
*/
INSERT INTO `session` (`time`, `slot`)
VALUES
('10:00:00', 'Matin'),
('14:00:00', 'Après-midi 1'),
('18:15:00', 'Après-midi 2'),
('20:00:00', 'Soirée'),
('22:00:00', 'Nuit');

/*
Add some sessions to the cinema room
*/
INSERT INTO `session_has_movie_screening` (`session_id`, `cinema_room_id`, `is_weekday`)
VALUES
(1, 1, 0),
(2, 1, 0),
(3, 2, 0),
(4, 2, 0),
(5, 3, 1),
(5, 2, 1);

/*
Add the data related to the movies in the database link with the director and the authorization scale
*/
INSERT INTO `movie` (`id`,`title`, `synopsis`, `time_duration`, `release_date`, `aditional_comment`, `authorization_scale_id`, `director_id`)
VALUES
(1,'Le Seigneur des Anneaux : La communauté de l\'anneau', 'Dans ce chapitre de la trilogie, le jeune et timide Hobbit, Frodon Sacquet, hérite d\'un anneau. Bien loin d\'être une simple babiole, il s\'agit de l\'Anneau Unique, un instrument de pouvoir absolu qui permettrait à Sauron, le Seigneur des ténèbres, de régner sur la Terre du Milieu et de réduire en esclavage ses peuples. Etc.', '178', '2001-09-23', 'Rétrospective', 1, 1),
(2, 'Le Seigneur des Anneaux : Les deux tours', 'Après la mort de Boromir et la disparition de Gandalf,  la Communauté s\'est scindée en trois. Perdus dans les collines d`\'Emyn Muil  Frodon et Sam découvrent qu\'ils sont suivis par Gollum  une créature versatile corrompue par l\'Anneau etc.', '179', '2002-12-18', 'Rétrospective', 1, 1),
(3, 'Le Seigneur des Anneaux : Le retour du roi', 'Les armées de Sauron ont attaqué Minas Tirith, la capitale de Gondor. Jamais ce royaume autrefois puissant n\'a eu autant besoin de son roi. Mais Aragorn trouvera-t-il en lui la volonté d\'accomplir sa destinée ?', '201', '2003-12-01', 'Rétrospective', 1, 1),
(4, 'Les chambres rouges', 'Deux jeunes femmes se réveillent chaque matin aux portes du palais de justice pour pouvoir assister au procès hypermédiatisé', '118', '2024-01-17', NULL, 2, 2),
(5, 'Anatomie d\'une chute', 'Sandra, Samuel et leur fils malvoyant de 11 ans, Daniel, vivent depuis un an loin de tout, à la montagne. Un jour, Samuel est etc.', '150', '2023-09-23', 'Coup de coeur', 1, 3);

/*
Add the data for movie screening
*/
INSERT INTO `movie_screening` (`id`,`is_preview`, `day_screening_id`, `language_id`, `session_has_movie_screening_session_id`, `session_has_movie_screening_cinema_room_id`, `movie_id`)
VALUES
(1, 0, 1, 1, 1, 1, 1),
(2, 0, 1, 2, 2, 1, 2),
(3, 0, 2, 1, 3, 1, 3),
(4, 1, 2, 1, 4, 1, 4),
(5, 0, 3, 1, 1, 2, 5);

/*
Add the data related to the director in the database
*/
INSERT INTO `director` (`person_id`)
VALUES
(1),
(2),
(3);

/*
Add the actors in the database
*/
INSERT INTO `actor` (`person_id`)
VALUES
(4),
(5),
(6),
(7),
(8),
(9),
(10);

/*
Add the data related to the visitor in the database
*/
INSERT INTO `visitor` (`person_id`)
VALUES
(11),
(12),
(13),
(14),
(15);

/*
Add the data related to the persons in the database
*/
INSERT INTO `person` (`id`,`first_name`, `last_name`)
VALUES
(1, 'Peter', 'Jackson'),
(2, 'Pascal', 'Plante'),
(3, 'Justine', 'Triet'),
(4, 'Elijah', 'Wood'),
(5, 'Ian', 'McKellen'),
(6, 'Viggo', 'Mortensen'),
(7, 'Maxwell', 'McCabe-Lokos'),
(8, 'Juliette', 'Gariépy'),
(9, 'Milo Machado', 'Graner'),
(10, 'Swann', 'Arlaud'),
(11, 'John', 'Doe'),
(12, 'Jane', 'Doe'),
(13, 'Jack', 'Doe'),
(14 ,'Jill', 'Doe'),
(15, 'James', 'Doe');

/*
Add the link actor and movie in the database
*/
INSERT INTO `actor_has_movie` (`movie_id`, `actor_id`)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 4),
(4, 5),
(5, 6),
(5, 7);


/*
Add the type of movie
*/
INSERT INTO `type` (`id`, `label`)
VALUES
(1, 'Drame'),
(2, 'Comédie'),
(3, 'Aventure'),
(4, 'Animation'),
(5, 'Famille'),
(6, 'Romance'),
(7, 'Fantastique'),
(8, 'Science-fiction'),
(9, 'Comédie dramatique'),
(10, 'Western'),
(11, 'Action'),
(12, 'Documentaire'),
(13, 'Policier'),
(14, 'Fantasy'),
(15, 'Thriller');

/*
Add the linkage from movie to type
*/
INSERT INTO `type_has_movie` (`movie_id`, `type_id`)
VALUES
(1, 7),
(1, 5),
(2, 7),
(2, 5),
(3, 7),
(3, 5),
(4, 15),
(5, 1),
(5, 13);

/*
Add visitor to screening with price
*/
INSERT INTO `visitor_has_movie_screening` (`visitor_id`, `movie_screening_id`, `price_category_id`)
VALUES
(11, 1, 1),
(12, 2, 2),
(13, 3, 3),
(14, 4, 4),
(15, 5, 1);

/*
Add day_screening programmation
*/
INSERT INTO `day_screening` (`date`)
VALUES
('2024-03-10'),
('2024-03-09'), 
('2022-02-27')
('2024-03-11');

