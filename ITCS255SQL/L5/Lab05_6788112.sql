# DROP DATABASE IF EXISTS l04_Chinook;
USE l04_Chinook;

DROP TABLE IF EXISTS customer_copy;
DROP TABLE IF EXISTS invoice_backup;
DROP TABLE IF EXISTS tracks_structure_only;
DROP TABLE IF EXISTS customer_canada;

RENAME TABLE CustomerInvoice TO Invoice;
RENAME TABLE MusicAlbums TO Album;
RENAME TABLE MusicTracks TO Track;
RENAME TABLE MusicArtists TO Artist;

-- Task 1

CREATE TABLE customer_copy AS
SELECT *
FROM Customer;

-- Check 1

SELECT (
           SELECT COUNT(*)
           FROM Customer
           )   AS original_count,
       (
           SELECT COUNT(*)
           FROM customer_copy
           )   AS copy_count,
       CASE
           WHEN (
                    SELECT COUNT(*)
                    FROM Customer
                    ) = (
                            SELECT COUNT(*)
                            FROM customer_copy
                            )
               THEN 'Match'
           ELSE 'Mismatch'
           END AS count_check;

-- Task 2

CREATE TABLE invoice_backup AS
SELECT *
FROM Invoice;

-- Check 2

SELECT (
           SELECT COUNT(*)
           FROM Invoice
           )   AS original_count,
       (
           SELECT COUNT(*)
           FROM invoice_backup
           )   AS copy_count,
       CASE
           WHEN (
                    SELECT COUNT(*)
                    FROM Invoice
                    ) = (
                            SELECT COUNT(*)
                            FROM invoice_backup
                            )
               THEN 'Match'
           ELSE 'Mismatch'
           END AS count_check;

-- Task 3

-- No records will be matched with `LIKE` since `tracks_structure_only` is an entirely new table
-- Otherwise use `WHERE 1 = 0`
CREATE TABLE tracks_structure_only LIKE Track;
SELECT *
FROM tracks_structure_only;

-- Task 4

CREATE TABLE customer_canada AS
SELECT *
FROM Customer
WHERE Country = 'Canada';

-- Check 4

SELECT COUNT(*)                                            AS total_records,
       SUM(CASE WHEN Country = 'Canada' THEN 1 ELSE 0 END) AS canadian_records,
       CASE
           WHEN COUNT(*) = SUM(CASE WHEN Country = 'Canada' THEN 1 ELSE 0 END)
               THEN 'All Records Canadian'
           ELSE 'Error: Non-Canadian Records Found'
           END                                             AS verification_status
FROM customer_canada;

-- Task 5

ALTER TABLE customer_copy
    DROP CustomerId;
ALTER TABLE customer_copy
    ADD CustomerId INT AUTO_INCREMENT PRIMARY KEY;
-- NOTE: to specify the position of adding the column, use `AFTER <column_name>` (`BEFORE` doesn't exist)

-- Check 5

DESCRIBE customer_copy;

-- Task 6

INSERT INTO customer_copy
VALUES ('John', 'Doe', NULL, NULL, NULL, NULL, 'Thailand', 000000, NULL, NULL, 'john.doe@email.com', NULL, NULL);
INSERT INTO customer_copy
VALUES ('Jane', 'Doe', NULL, NULL, NULL, NULL, 'Thailand', 000000, NULL, NULL, 'jane.doe@email.com', NULL, NULL);

-- Check 6

SELECT *
FROM customer_copy;

-- Task 7

RENAME TABLE Invoice TO CustomerInvoice;
RENAME TABLE Album TO MusicAlbums;
RENAME TABLE Track TO MusicTracks;
RENAME TABLE Artist TO MusicArtists;

-- Check 7

SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN (
                     'CustomerInvoice',
                     'MusicAlbums',
                     'MusicTracks',
                     'MusicArtists');

-- Task 8

ALTER TABLE MusicTracks
    DROP LengthInMinutes;
ALTER TABLE MusicTracks
    ADD LengthInMinutes DEC(3, 2) GENERATED ALWAYS AS (Milliseconds / 60000);

-- Check 8

SELECT Milliseconds, LengthInMinutes
FROM MusicTracks;
