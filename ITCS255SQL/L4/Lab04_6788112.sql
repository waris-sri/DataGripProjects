-- DROP DATABASE IF EXISTS l04_Chinook;
USE l04_Chinook;
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Task 1
/*
UPDATE [LOW_PRIORITY] [IGNORE] table_name
SET
    column_name1 = val1,
    column_name2 = val2,
    ...
[WHERE
    condition];
*/

-- 1a
UPDATE Customer 
SET 
    FirstName = 'Waris',
    LastName = 'Sripatoomrak'
WHERE
    CustomerId = 3;
    


-- 1b
UPDATE Customer 
SET 
    Email = 'itcs255@ict.com'
WHERE
    CustomerId = 5;

-- 1c
UPDATE Customer 
SET 
    Address = 'New Berlin'
WHERE
    City = 'Berlin';

-- 1d
UPDATE Customer 
SET 
    SupportRepId = SupportRepId + 1
WHERE
    SupportRepId IS NOT NULL;

select * from Customer;
-- Task 2
/*
UPDATE
    T1
[INNER JOIN | LEFT JOIN] T2 ON T1.C1 = T2.C1
SET
    T1.C2 = T2.C2,
    T2.C3 = expr
WHERE
    condition;
*/

-- 2a
UPDATE Invoice i
        INNER JOIN
    Customer c ON i.CustomerId = c.CustomerId 
SET 
    InvoiceDate = NOW();

-- 2b
UPDATE Invoice i
        INNER JOIN
    Customer c ON i.CustomerId = c.CustomerId 
SET 
    BillingPostalCode = '00000'
WHERE
    c.City LIKE 'London';

-- 2c
UPDATE Invoice i
        INNER JOIN
    Customer c ON i.CustomerId = c.CustomerId 
SET 
    i.BillingCountry = 'France (Cap)'
WHERE
    c.City = 'Paris';

-- 2d
UPDATE Invoice i
        INNER JOIN
    Customer c ON i.CustomerId = c.CustomerId 
SET 
    i.Total = i.Total * 1.1 -- increase by 10%
WHERE
    c.City = 'Madrid';

select * from Invoice i
        JOIN
    Customer c on i.CustomerId = c.CustomerId;
-- Task 3
/*
DELETE T1, T2
FROM T1
INNER JOIN T2 ON T1.key = T2.key
WHERE condition;
*/

-- 3a
-- Check the referenced relationship of 'Track' table by using the following script.
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    REFERENCED_TABLE_NAME = 'Track'; -- InvoiceLine, PlaylistTrack

-- 3b
DELETE il, pt, t
FROM Track t
LEFT JOIN InvoiceLine il ON t.TrackId = il.TrackId
LEFT JOIN PlaylistTrack pt ON t.TrackId = pt.TrackId
INNER JOIN Album a ON t.AlbumId = a.AlbumId
INNER JOIN Artist art ON a.ArtistId = art.ArtistId
WHERE art.Name = 'AC/DC';
-- Check 3b
SELECT COUNT(*) as TrackNum
FROM track t
JOIN album a ON t.AlbumId = a.AlbumId
JOIN artist ar ON a.ArtistId = ar.ArtistId
WHERE ar.Name = 'AC/DC';

-- 3c
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    REFERENCED_TABLE_NAME = 'Invoice'; -- InvoiceLine

DELETE il , i FROM Invoice i
        LEFT JOIN
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
        INNER JOIN
    Customer c ON i.CustomerId = c.CustomerId 
WHERE
    c.City = 'Prague';

-- Check 3c
SELECT COUNT(*) as InvoiceNum
FROM invoice i
JOIN customer c ON i.CustomerId = c.CustomerId
WHERE c.City = 'Prague';

-- 3d
DELETE pt
FROM PlaylistTrack pt
INNER JOIN Track t ON pt.TrackId = t.TrackId
WHERE t.Milliseconds > 300000;
-- Check 3d
SELECT COUNT(*) 
FROM PlaylistTrack pt
JOIN Track t ON pt.TrackId = t.TrackId
WHERE t.Milliseconds > 300000;

-- 3e
DELETE c FROM Customer c
        LEFT JOIN
    Invoice i ON c.CustomerId = i.CustomerId 
WHERE
    i.InvoiceId IS NULL;
-- Check 3e
SELECT 
    COUNT(*) AS Null_customer
FROM
    customer c
        LEFT JOIN
    invoice i ON c.CustomerId = i.CustomerId
WHERE
    i.InvoiceId IS NULL;

-- Task 4

-- 4a
SELECT 
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.CONSTRAINT_NAME,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME,
    rc.DELETE_RULE
FROM
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
        JOIN
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE
    rc.CONSTRAINT_SCHEMA = 'l04_Chinook'
        AND kcu.REFERENCED_TABLE_NAME IN ('Track' , 'Artist', 'Album');

-- 4b
ALTER TABLE PlaylistTrack DROP FOREIGN KEY `FK_PlaylistTrackTrackId`;
ALTER TABLE InvoiceLine DROP FOREIGN KEY `FK_InvoiceLineTrackId`;
ALTER TABLE Album DROP FOREIGN KEY `FK_AlbumArtistId`;
ALTER TABLE Track DROP FOREIGN KEY `FK_TrackAlbumId`;

ALTER TABLE `Album` ADD CONSTRAINT `FK_AlbumArtistId`
    FOREIGN KEY (`ArtistId`) REFERENCES `Artist` (`ArtistId`) ON DELETE CASCADE;
ALTER TABLE `InvoiceLine` ADD CONSTRAINT `FK_InvoiceLineTrackId`
    FOREIGN KEY (`TrackId`) REFERENCES `Track` (`TrackId`) ON DELETE CASCADE;
ALTER TABLE `PlaylistTrack` ADD CONSTRAINT `FK_PlaylistTrackTrackId`
    FOREIGN KEY (`TrackId`) REFERENCES `Track` (`TrackId`) ON DELETE CASCADE;
ALTER TABLE `Track` ADD CONSTRAINT `FK_TrackAlbumId`
    FOREIGN KEY (`AlbumId`) REFERENCES `Album` (`AlbumId`) ON DELETE cascade;
-- Check 4b
SELECT 
    kcu.TABLE_NAME,
    kcu.COLUMN_NAME,
    kcu.CONSTRAINT_NAME,
    kcu.REFERENCED_TABLE_NAME,
    kcu.REFERENCED_COLUMN_NAME,
    rc.DELETE_RULE
FROM
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
        JOIN
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE
    rc.CONSTRAINT_SCHEMA = 'l04_Chinook'
        AND kcu.REFERENCED_TABLE_NAME IN ('Track' , 'Artist', 'Album');

-- 4c
DELETE FROM Artist 
WHERE
    `Name` = 'Queen';
-- Check 4c
SELECT 
    'Artist' AS TableName, COUNT(*) AS RecordCount
FROM
    artist
WHERE
    Name = 'Queen' 
UNION ALL SELECT 
    'Albums', COUNT(*)
FROM
    album a
        JOIN
    artist ar ON a.ArtistId = ar.ArtistId
WHERE
    ar.Name = 'Queen' 
UNION ALL SELECT 
    'Tracks', COUNT(*)
FROM
    track t
        JOIN
    album a ON t.AlbumId = a.AlbumId
        JOIN
    artist ar ON a.ArtistId = ar.ArtistId
WHERE
    ar.Name = 'Queen' 
UNION ALL SELECT 
    'InvoiceLines', COUNT(*)
FROM
    invoiceline il
        JOIN
    track t ON il.TrackId = t.TrackId
        JOIN
    album a ON t.AlbumId = a.AlbumId
        JOIN
    artist ar ON a.ArtistId = ar.ArtistId
WHERE
    ar.Name = 'Queen' 
UNION ALL SELECT 
    'PlaylistTracks', COUNT(*)
FROM
    playlisttrack pt
        JOIN
    track t ON pt.TrackId = t.TrackId
        JOIN
    album a ON t.AlbumId = a.AlbumId
        JOIN
    artist ar ON a.ArtistId = ar.ArtistId
WHERE
    ar.Name = 'Queen';
