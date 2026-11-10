-- =========================================================
-- Backtrack schema (MySQL / InnoDB)
-- Run with:  mysql -u root -p < schema.sql
-- or import the file through phpMyAdmin.
-- =========================================================

CREATE DATABASE IF NOT EXISTS backtrack
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE backtrack;


-- ---------------------------------------------------------
-- Platforms: lookup table, one row per platform
-- ---------------------------------------------------------
CREATE TABLE Platforms (
  platform_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  platform_name  VARCHAR(50)  NOT NULL,
  PRIMARY KEY (platform_id),
  UNIQUE KEY uq_platform_name (platform_name)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- Users
-- display_name is optional. When it is NULL, the app shows the username.
-- ---------------------------------------------------------
CREATE TABLE Users (
  user_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username       VARCHAR(30)  NOT NULL,
  display_name   VARCHAR(50)  NULL,
  email          VARCHAR(255) NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  is_admin       BOOLEAN      NOT NULL DEFAULT FALSE,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_username (username),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- Games: the shared catalog. One row per platform-specific release.
-- cover_image stores a file name (e.g. 'doom.jpeg') from images/covers/
-- Player counts: NULL means that mode is not supported.
-- Games are never deleted, only set to is_active = FALSE.
-- ---------------------------------------------------------
CREATE TABLE Games (
  game_id                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  game_name                 VARCHAR(150) NOT NULL,
  platform_id               INT UNSIGNED NOT NULL,
  game_description          TEXT         NULL,
  cover_image               VARCHAR(255) NULL,
  number_players_local_min  TINYINT UNSIGNED NULL,
  number_players_local_max  TINYINT UNSIGNED NULL,
  number_players_online_min TINYINT UNSIGNED NULL,
  number_players_online_max TINYINT UNSIGNED NULL,
  is_active                 BOOLEAN      NOT NULL DEFAULT TRUE,
  PRIMARY KEY (game_id),
  UNIQUE KEY uq_game_per_platform (game_name, platform_id),
  CONSTRAINT fk_games_platform
    FOREIGN KEY (platform_id) REFERENCES Platforms (platform_id)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- Tags: preset list, only admins/seed data add rows.
-- category groups them (e.g. 'Genre', 'Mood')
-- ---------------------------------------------------------
CREATE TABLE Tags (
  tag_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tag_name  VARCHAR(50)  NOT NULL,
  category  VARCHAR(50)  NOT NULL,
  PRIMARY KEY (tag_id),
  UNIQUE KEY uq_tag_name (tag_name)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- GameTagAssignments: links games to tags (many-to-many)
-- ---------------------------------------------------------
CREATE TABLE GameTagAssignments (
  game_id  INT UNSIGNED NOT NULL,
  tag_id   INT UNSIGNED NOT NULL,
  PRIMARY KEY (game_id, tag_id),
  CONSTRAINT fk_gta_game
    FOREIGN KEY (game_id) REFERENCES Games (game_id) ON DELETE CASCADE,
  CONSTRAINT fk_gta_tag
    FOREIGN KEY (tag_id) REFERENCES Tags (tag_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- UserLibraryEntries: a user's games and progress.
-- The composite primary key stops the same game being added twice.
-- ---------------------------------------------------------
CREATE TABLE UserLibraryEntries (
  user_id     INT UNSIGNED NOT NULL,
  game_id     INT UNSIGNED NOT NULL,
  status      ENUM('Backlog', 'Playing', 'On Hold', 'Completed')
              NOT NULL DEFAULT 'Backlog',
  added_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
              ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, game_id),
  CONSTRAINT fk_library_user
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_library_game
    FOREIGN KEY (game_id) REFERENCES Games (game_id)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- WishlistEntries: games a user wants but has not added to their library.
-- Moving a game to the library = insert into the library AND delete
-- from here. The database will not do that automatically.
-- ---------------------------------------------------------
CREATE TABLE WishlistEntries (
  user_id   INT UNSIGNED NOT NULL,
  game_id   INT UNSIGNED NOT NULL,
  added_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, game_id),
  CONSTRAINT fk_wishlist_user
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_game
    FOREIGN KEY (game_id) REFERENCES Games (game_id)
) ENGINE=InnoDB;


-- ---------------------------------------------------------
-- GameRequests: users ask for games missing from the catalog.
-- ---------------------------------------------------------
CREATE TABLE GameRequests (
  request_id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id          INT UNSIGNED NOT NULL,
  requested_title  VARCHAR(150) NOT NULL,
  platform_id      INT UNSIGNED NOT NULL,
  notes            TEXT NULL,
  status           ENUM('Pending', 'Approved', 'Declined')
                   NOT NULL DEFAULT 'Pending',
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (request_id),
  CONSTRAINT fk_requests_user
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_requests_platform
    FOREIGN KEY (platform_id) REFERENCES Platforms (platform_id)
) ENGINE=InnoDB;
