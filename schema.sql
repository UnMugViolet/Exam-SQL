-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema MCD - SQL Exam
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `MCD - SQL Exam` ;

-- -----------------------------------------------------
-- Schema MCD - SQL Exam
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `MCD - SQL Exam` DEFAULT CHARACTER SET utf8 ;
USE `MCD - SQL Exam` ;

-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`person` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`person` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`actor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`actor` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`actor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_actor_person1_idx` ON `MCD - SQL Exam`.`actor` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`director`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`director` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`director` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_realisator_person_idx` ON `MCD - SQL Exam`.`director` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`price_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`price_category` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`price_category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(150) NOT NULL,
  `price` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`cinema_room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`cinema_room` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`cinema_room` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `max_capacity` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`day_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`day_screening` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`day_screening` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`language` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`language` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`session` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`session` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time` TIME NOT NULL,
  `slot` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`authorization_scale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`authorization_scale` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`authorization_scale` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `age` INT NOT NULL,
  `type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`movie` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`movie` (
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

CREATE INDEX `fk_movie_authorization_scale1_idx` ON `MCD - SQL Exam`.`movie` (`authorization_scale_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_director1_idx` ON `MCD - SQL Exam`.`movie` (`director_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`movie_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`movie_screening` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`movie_screening` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_preview` TINYINT NOT NULL DEFAULT 0,
  `day_screening_id` INT NOT NULL,
  `language_id` INT NOT NULL,
  `session_id` INT NOT NULL,
  `cinema_room_id` INT NOT NULL,
  `movie_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_movie_screening_day_screening1_idx` ON `MCD - SQL Exam`.`movie_screening` (`day_screening_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_language1_idx` ON `MCD - SQL Exam`.`movie_screening` (`language_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_session1_idx` ON `MCD - SQL Exam`.`movie_screening` (`session_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_cinema_room1_idx` ON `MCD - SQL Exam`.`movie_screening` (`cinema_room_id` ASC) VISIBLE;

CREATE INDEX `fk_movie_screening_movie1_idx` ON `MCD - SQL Exam`.`movie_screening` (`movie_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`actor_has_movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`actor_has_movie` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`actor_has_movie` (
  `movie_id` INT NOT NULL,
  `actor_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `actor_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_actor_has_movie_movie1_idx` ON `MCD - SQL Exam`.`actor_has_movie` (`movie_id` ASC) VISIBLE;

CREATE INDEX `fk_actor_has_movie_actor1_idx` ON `MCD - SQL Exam`.`actor_has_movie` (`actor_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`type` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`type` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`type_has_movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`type_has_movie` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`type_has_movie` (
  `movie_id` INT NOT NULL,
  `type_id` INT NOT NULL,
  PRIMARY KEY (`movie_id`, `type_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_type_has_movie_type1_idx` ON `MCD - SQL Exam`.`type_has_movie` (`type_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`licence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`licence` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`licence` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date_begin_exploitation` DATE NOT NULL,
  `date_end_exploitation` DATE NULL,
  `movie_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_licence_movie1_idx` ON `MCD - SQL Exam`.`licence` (`movie_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`visitor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`visitor` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`visitor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM;

CREATE INDEX `fk_visitor_person1_idx` ON `MCD - SQL Exam`.`visitor` (`person_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `MCD - SQL Exam`.`visitor_has_movie_screening`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MCD - SQL Exam`.`visitor_has_movie_screening` ;

CREATE TABLE IF NOT EXISTS `MCD - SQL Exam`.`visitor_has_movie_screening` (
  `visitor_id` INT NOT NULL,
  `movie_screening_id` INT NOT NULL,
  `price_category_id` INT NOT NULL,
  PRIMARY KEY (`visitor_id`, `movie_screening_id`))
ENGINE = MyISAM;

CREATE INDEX `fk_visitor_has_movie_screening_movie_screening1_idx` ON `MCD - SQL Exam`.`visitor_has_movie_screening` (`movie_screening_id` ASC) VISIBLE;

CREATE INDEX `fk_visitor_has_movie_screening_visitor1_idx` ON `MCD - SQL Exam`.`visitor_has_movie_screening` (`visitor_id` ASC) VISIBLE;

CREATE INDEX `fk_visitor_has_movie_screening_price_category1_idx` ON `MCD - SQL Exam`.`visitor_has_movie_screening` (`price_category_id` ASC) VISIBLE;

USE `MCD - SQL Exam`;
DROP TRIGGER IF EXISTS `MCD - SQL Exam`.`licence_BEFORE_INSERT`;
USE `MCD - SQL Exam`;
CREATE DEFINER = CURRENT_USER TRIGGER `MCD - SQL Exam`.`licence_BEFORE_INSERT` BEFORE INSERT ON `licence` FOR EACH ROW BEGIN IF NEW.date_end_exploitation IS NULL THEN SET NEW.date_end_exploitation = DATE_ADD(NEW.date_begin_exploitation, INTERVAL 8 WEEK); END IF; END;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
