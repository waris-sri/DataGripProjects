DROP DATABASE IF EXISTS L03_SchoolDB;
CREATE DATABASE IF NOT EXISTS L03_SchoolDB;
USE L03_SchoolDB;

DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS TempStudents;

-- Task 1
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    `name` VARCHAR(50),
    dob DATE,
    enrollment_date DATETIME
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATETIME,
    CONSTRAINT FK_student_id FOREIGN KEY (student_id)
        REFERENCES Students (student_id),
    CONSTRAINT FK_course_id FOREIGN KEY (course_id)
        REFERENCES Courses (course_id)
);

-- Task 2

-- 2a
insert into Students (student_id, `name`, dob, enrollment_date)
values (1, "John Doe", "2000-05-01", now());

-- 2b
insert into Students (student_id, `name`, dob, enrollment_date)
values (2, "Jane Smith", "1999-05-12", now());

-- 2c
insert into Students (student_id, `name`, dob, enrollment_date)
values (6788112, "Waris Sripatoomrak", NULL, now());

-- 2d
insert into Courses (course_id, course_name, credits)
values (104, "History", 3);

-- Task 3

-- 3a
insert into Courses (course_id, course_name, credits)
values
(101,"Mathematics", 4),
(102,"Physics", 3),
(103,"Chemistry", 3),
(105,"Biology", 3),
(106,"Computer Science", 4),
(107,"English", 2);

-- 3b
insert into Enrollments (enrollment_id,
    student_id,
    course_id,
    enrollment_date)
values
(1, 1, 101, now()),
(2, 2, 102, now());

-- Task 4

CREATE TABLE TempStudents (
    student_id INT PRIMARY KEY,
    `name` VARCHAR(50),
    dob DATE,
    enrollment_date DATETIME
);

INSERT INTO TempStudents (student_id, name, dob, enrollment_date)
VALUES 
    (3, 'Emily Johnson', '2001-08-25', '2023-12-03 11:00:00'),
    (4, 'Michael Brown', '1998-12-15', '2023-12-03 12:00:00'),
    (5, 'Sarah Davis', '2002-03-22', '2023-12-03 13:00:00'),
    (6, 'David Lee', '2000-07-11', '2023-12-03 14:00:00');

insert into Students
select * from TempStudents;

-- 4b

CREATE TABLE TempCourses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);

insert into TempCourses
select * from Courses where credits > 3;

-- 4c

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
SELECT 
    student_id,
    student_id, 
    course_id, 
    now()
FROM TempStudents, Courses
WHERE course_name = 'Mathematics';

-- 4d

INSERT INTO Courses (course_id, course_name, credits)
SELECT 
    REPLACE(tc.course_id, '1', '2'), 
    CONCAT('Advanced ', tc.course_name), 
    tc.credits
FROM TempCourses tc;

-- Task 5

-- 5a

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES (
    11,
    (SELECT student_id FROM Students WHERE name = 'Waris Sripatoomrak'),
    (SELECT course_id FROM Courses WHERE course_name = 'Advanced Computer Science'),
    NOW()
);

-- Task 6

-- 6a

insert into Students (student_id, `name`, dob, enrollment_date)
values (3, "Emily Johnson Updated", "2001-08-26", now())
as new_entry
on duplicate key update
    `name` = new_entry.`name`,
    enrollment_date = new_entry.enrollment_date;