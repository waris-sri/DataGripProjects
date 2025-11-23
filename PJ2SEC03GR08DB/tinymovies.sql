DROP DATABASE IF EXISTS `tinymovies`;
CREATE DATABASE IF NOT EXISTS `tinymovies`;
USE `tinymovies`;

CREATE TABLE `boxofficemovie` (
    `mid`          INT          NOT NULL,
    `title`        VARCHAR(100) NOT NULL,
    `studio`       VARCHAR(20),
    `year`         INT,
    `datereleased` DATE,
    `gross`        DECIMAL(10, 2),
    PRIMARY KEY (`mid`)
);

INSERT INTO `boxofficemovie`
VALUES (1, 'Avengers: Endgame', 'Marvel', 2019, '2019-04-26', 2794.70),
       (2, 'Avartar', 'Fox', 2009, '2009-12-18', 2789.70),
       (3, 'Titanic', 'Par', 1997, '1997-12-19', 2187.50),
       (4, 'Star Wars: The Force Awakens', 'Walt Disney', 2015, '2015-12-18', 2068.20),
       (5, 'Frozen II', 'Walt Disney', 2020, '2019-11-22', 2934.25),
       (6, 'Star Wars: The Rise of Skywalker', 'Walt Disney', 2019, '2019-12-11', 3564.75);

CREATE TABLE `users` (
    `uid`      INT         NOT NULL,
    `username` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`uid`)
);

INSERT INTO `users`
VALUES (1, 'captain_marvel'),
       (2, 'oldmcdonald123');


CREATE TABLE `watch_log` (
    `uid`            INT      NOT NULL,
    `mid`            INT      NOT NULL,
    `watch_datetime` DATETIME NOT NULL,
    PRIMARY KEY (`uid`, `mid`, `watch_datetime`),
    CONSTRAINT `user_watch` FOREIGN KEY (`uid`) REFERENCES `users` (`uid`),
    CONSTRAINT `watch_movie` FOREIGN KEY (`mid`) REFERENCES `boxofficemovie` (`mid`)
);

INSERT INTO `watch_log`
VALUES (1, 1, '2020-10-10 09:30:15'),
       (1, 1, '2020-10-13 17:30:15'),
       (2, 2, '2020-10-13 11:01:56'),
       (2, 2, '2020-10-13 14:26:03'),
       (2, 4, '2020-10-13 20:49:34'),
       (1, 5, '2020-10-13 19:55:21'),
       (2, 6, '2020-10-13 23:10:32');


-- List all users (usernames) and their watched movie titles.

SELECT username,
       title
FROM users u
         INNER JOIN
     watch_log w ON u.uid = w.uid
         INNER JOIN
     boxofficemovie b ON w.`mid` = b.`mid`;

-- List all usernames and their number of watched movies

SELECT username,
       COUNT(DISTINCT ( mid )) AS num_movie
FROM users u
         INNER JOIN
     watch_log w ON u.uid = w.uid
GROUP BY username;