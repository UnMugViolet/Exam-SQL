-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema exam_sql_paul_jaguin
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `exam_sql_paul_jaguin` ;

-- -----------------------------------------------------
-- Schema exam_sql_paul_jaguin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `exam_sql_paul_jaguin` DEFAULT CHARACTER SET utf8 ;
USE `exam_sql_paul_jaguin` ;

-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`person` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`person` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`actor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`actor` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`actor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_actor_person1_idx` ON `exam_sql_paul_jaguin`.`actor` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`director` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`director` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_realisator_person_idx` ON `exam_sql_paul_jaguin`.`director` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`price_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`price_category` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`price_category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(150) NOT NULL,
  `price` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`cinema_room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`cinema_room` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`cinema_room` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `max_capacity` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`day_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`day_screening` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`day_screening` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`language` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`language` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`authorization_scale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`authorization_scale` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`authorization_scale` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `age` INT NOT NULL,
  `type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`movie` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`movie` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `synopsis` VARCHAR(501) NOT NULL,
  `time_duration` INT NOT NULL,
  `release_date` DATE NOT NULL,
  `aditional_comment` VARCHAR(200) NOT NULL,
  `authorization_scale_id` INT NOT NULL,
  `director_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_movie_authorization_scale1_idx` ON `exam_sql_paul_jaguin`.`movie` (`authorization_scale_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_director1_idx` ON `exam_sql_paul_jaguin`.`movie` (`director_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`session` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`session` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time` TIME NOT NULL,
  `slot` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`session_has_movie_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`session_has_movie_screening` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`session_has_movie_screening` (
  `session_id` INT NOT NULL,
  `cinema_room_id` INT NOT NULL,
  `is_weekday` TINYINT NOT NULL,
  PRIMARY KEY (`session_id`, `cinema_room_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_session_has_movie_screening_session1_idx` ON `exam_sql_paul_jaguin`.`session_has_movie_screening` (`session_id` ASC) VISIBLE;

CREATE INDEX `fk_session_has_movie_screening_cinema_room1_idx` ON `exam_sql_paul_jaguin`.`session_has_movie_screening` (`cinema_room_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`movie_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`movie_screening` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`movie_screening` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_preview` TINYINT NOT NULL DEFAULT 0,
  `day_screening_id` INT NOT NULL,
  `language_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  `session_has_movie_screening_session_id` INT NOT NULL,
  `session_has_movie_screening_cinema_room_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_movie_screening_day_screening1_idx` ON `exam_sql_paul_jaguin`.`movie_screening` (`day_screening_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_language1_idx` ON `exam_sql_paul_jaguin`.`movie_screening` (`language_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_movie1_idx` ON `exam_sql_paul_jaguin`.`movie_screening` (`movie_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_session_has_movie_screening1_idx` ON `exam_sql_paul_jaguin`.`movie_screening` (`session_has_movie_screening_session_id` ASC, `session_has_movie_screening_cinema_room_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`actor_has_movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`actor_has_movie` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`actor_has_movie` (
  `movie_id` INT NOT NULL,
  `actor_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `actor_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_actor_has_movie_movie1_idx` ON `exam_sql_paul_jaguin`.`actor_has_movie` (`movie_id` ASC) VISIBLE;

CREATE INDEX `fk_actor_has_movie_actor1_idx` ON `exam_sql_paul_jaguin`.`actor_has_movie` (`actor_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`type` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`type_has_movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`type_has_movie` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`type_has_movie` (
  `movie_id` INT NOT NULL,
  `type_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `type_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_type_has_movie_type1_idx` ON `exam_sql_paul_jaguin`.`type_has_movie` (`type_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`licence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`licence` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`licence` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_begin_exploitation` DATE NOT NULL,
  `date_end_exploitation` DATE NULL,
  `movie_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_licence_movie1_idx` ON `exam_sql_paul_jaguin`.`licence` (`movie_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`visitor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`visitor` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`visitor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_visitor_person1_idx` ON `exam_sql_paul_jaguin`.`visitor` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `exam_sql_paul_jaguin`.`visitor_has_movie_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exam_sql_paul_jaguin`.`visitor_has_movie_screening` ;

CREATE TABLE IF NOT EXISTS `exam_sql_paul_jaguin`.`visitor_has_movie_screening` (
  `visitor_id` INT NOT NULL,
  `movie_screening_id` INT NOT NULL,
  `price_category_id` INT NOT NULL,
  PRIMARY KEY (`visitor_id`, `movie_screening_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_visitor_has_movie_screening_movie_screening1_idx` ON `exam_sql_paul_jaguin`.`visitor_has_movie_screening` (`movie_screening_id` ASC) VISIBLE;

CREATE INDEX `fk_visitor_has_movie_screening_visitor1_idx` ON `exam_sql_paul_jaguin`.`visitor_has_movie_screening` (`visitor_id` ASC) VISIBLE;

CREATE INDEX `fk_visitor_has_movie_screening_price_category1_idx` ON `exam_sql_paul_jaguin`.`visitor_has_movie_screening` (`price_category_id` ASC) VISIBLE;

USE `exam_sql_paul_jaguin`;
DROP TRIGGER IF EXISTS `exam_sql_paul_jaguin`.`licence_BEFORE_INSERT`;
USE `exam_sql_paul_jaguin`;
CREATE DEFINER = CURRENT_USER TRIGGER `exam_sql_paul_jaguin`.`licence_BEFORE_INSERT` BEFORE INSERT ON `licence` FOR EACH ROW BEGIN IF NEW.date_end_exploitation IS NULL THEN SET NEW.date_end_exploitation = DATE_ADD(NEW.date_begin_exploitation, INTERVAL 8 WEEK); END IF; END;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
