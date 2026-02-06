DROP DATABASE IF EXISTS L03_SchoolDB;
CREATE DATABASE IF NOT EXISTS L03_SchoolDB;
USE L03_SchoolDB;

DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS TempStudents;

-- Task 1
CREATE TABLE Students (
    student_id      INT PRIMARY KEY,
    `name`          VARCHAR(50),
    dob             DATE,
    enrollment_date DATETIME
);

CREATE TABLE Courses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits     INT
);

CREATE TABLE Enrollments (
    enrollment_id   INT PRIMARY KEY,
    student_id      INT,
    course_id       INT,
    enrollment_date DATETIME,
    CONSTRAINT FK_student_id FOREIGN KEY (student_id)
        REFERENCES Students (student_id),
    CONSTRAINT FK_course_id FOREIGN KEY (course_id)
        REFERENCES Courses (course_id)
);

-- Task 2

-- 2a
INSERT INTO Students (student_id, `name`, dob, enrollment_date)
VALUES (1, 'John Doe', '2000-05-01', NOW());

-- 2b
INSERT INTO Students (student_id, `name`, dob, enrollment_date)
VALUES (2, 'Jane Smith', '1999-05-12', NOW());

-- 2c
INSERT INTO Students (student_id, `name`, dob, enrollment_date)
VALUES (6788112, 'Waris Sripatoomrak', NULL, NOW());

-- 2d
INSERT INTO Courses (course_id, course_name, credits)
VALUES (104, 'History', 3);

-- Task 3

-- 3a
INSERT INTO Courses (course_id, course_name, credits)
VALUES (101, 'Mathematics', 4),
       (102, 'Physics', 3),
       (103, 'Chemistry', 3),
       (105, 'Biology', 3),
       (106, 'Computer Science', 4),
       (107, 'English', 2);

-- 3b
INSERT INTO Enrollments (enrollment_id,
                         student_id,
                         course_id,
                         enrollment_date)
VALUES (1, 1, 101, NOW()),
       (2, 2, 102, NOW());

-- Task 4

CREATE TABLE TempStudents (
    student_id      INT PRIMARY KEY,
    `name`          VARCHAR(50),
    dob             DATE,
    enrollment_date DATETIME
);

INSERT INTO TempStudents (student_id, name, dob, enrollment_date)
VALUES (3, 'Emily Johnson', '2001-08-25', '2023-12-03 11:00:00'),
       (4, 'Michael Brown', '1998-12-15', '2023-12-03 12:00:00'),
       (5, 'Sarah Davis', '2002-03-22', '2023-12-03 13:00:00'),
       (6, 'David Lee', '2000-07-11', '2023-12-03 14:00:00');

INSERT INTO Students
SELECT *
FROM TempStudents;

-- 4b

CREATE TABLE TempCourses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits     INT
);

INSERT INTO TempCourses
SELECT *
FROM Courses
WHERE credits > 3;

-- 4c

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
SELECT student_id,
       student_id,
       course_id,
       NOW()
FROM TempStudents,
     Courses
WHERE course_name = 'Mathematics';

-- 4d

INSERT INTO Courses (course_id, course_name, credits)
SELECT REPLACE(tc.course_id, '1', '2'),
       CONCAT('Advanced ', tc.course_name),
       tc.credits
FROM TempCourses tc;

-- Task 5

-- 5a

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (11,
        (
            SELECT student_id
            FROM Students
            WHERE name = 'Waris Sripatoomrak'
            ),
        (
            SELECT course_id FROM Courses WHERE course_name = 'Advanced Computer Science'
            ),
        NOW());

-- Task 6

-- 6a

INSERT INTO Students (student_id, `name`, dob, enrollment_date)
    VALUES (3, 'Emily Johnson Updated', '2001-08-26', NOW())
        AS new_entry
ON DUPLICATE KEY UPDATE `name`          = new_entry.`name`,
                        enrollment_date = new_entry.enrollment_date;
