DROP DATABASE IF EXISTS tinycompany;
CREATE DATABASE IF NOT EXISTS tinycompany;
USE tinycompany;

-- Department Table
CREATE TABLE department (
    dnumber  INT PRIMARY KEY, -- dnumber is a primary key
    dname    VARCHAR(50) NOT NULL,
    location VARCHAR(100),    -- location is nullable
    CONSTRAINT chk_dnumber CHECK (dnumber >= 1 AND dnumber <= 20 )
    -- dnumber range from 1 to 20
);

-- Project Table
CREATE TABLE project (
    pnumber INT PRIMARY KEY, -- dnumber is a primary key
    pname   VARCHAR(50) NOT NULL,
    dept_no INT         NOT NULL,
    CONSTRAINT FK_DeptProj FOREIGN KEY (dept_no)
        REFERENCES department (dnumber)
);
-- Employee Table
CREATE TABLE employee (
    fname   VARCHAR(20) NOT NULL,
    lname   VARCHAR(20) NOT NULL,
    ssn     CHAR(9) PRIMARY KEY,
    bdate   DATE        NOT NULL,
    sex     CHAR(1)     NOT NULL,
    salary  DECIMAL(12, 2), -- salary is nullable
    dept_no INT,            -- dept_no is nullable
    CONSTRAINT FK_EmpDept FOREIGN KEY (dept_no)
        REFERENCES department (dnumber)
);
-- Add a CHECK constraint for sex: only value 'M' or 'F' allowed
ALTER TABLE employee
    ADD CONSTRAINT CHK_Gender CHECK (sex IN ('M', 'F'));

-- Assignment Table
CREATE TABLE assignment (
    essn       CHAR(9) NOT NULL,
    projno     INT     NOT NULL,
    hours      DECIMAL(9, 2), -- hours is nullable
    hourlyrate DECIMAL(9, 2), -- hourlyrate is nullable
    CONSTRAINT FK_AsmEmp FOREIGN KEY (essn) REFERENCES employee (ssn),
    CONSTRAINT FK_AsmPrj FOREIGN KEY (projno)
        REFERENCES project (pnumber),
    PRIMARY KEY (essn, projno)
);


-- DML Insert Data to all tables sequentially
INSERT INTO department
VALUES (1, 'Accounting', '2A101 Fl.1'),
       (2, 'Human Resources', '2A104 Fl.1'),
       (3, 'Research and Development', '2B401 Fl.4'),
       (4, 'Information Technology', '2A404 Fl.4'),
       (5, 'Public Relations', '2B201 Fl.2'),
       (6, 'Administration', '2B301 Fl.3'),
       (7, 'Academic Services', '2B302 Fl.3');


INSERT INTO employee
VALUES ('MaryJane', 'Watson', '103849237', '1983-08-19', 'F', 3400.40, 1),
       ('Peter', 'Parker', '110033445', '1985-05-04', 'M', 1800.50, 3),
       ('Miles', 'Morales', '230563445', '1990-08-31', 'M', NULL, NULL),
       ('Jonah', 'Jameson', '679373346', '1973-11-23', 'M', NULL, NULL),
       ('Norman', 'Osborn', '830384453', '1964-05-04', 'M', 4000.50, 2),
       ('Harry', 'Osborn', '834940344', '1990-08-31', 'M', NULL, 3);


INSERT INTO project
VALUES (1, 'APTX4869', 3),
       (2, 'APTX4742', 2),
       (3, 'APTX3948', 3),
       (4, 'APTX0007', 2),
       (5, 'APTX1412', 1),
       (6, 'APTX1919', 1),
       (7, 'APTX8383', 4);


INSERT INTO assignment
VALUES ('103849237', 1, 10, 55.00),
       ('103849237', 2, 10, 58.00),
       ('110033445', 1, 10, 50.50);


-- Find the average age of Employee in our company separated by gender.
SELECT AVG(YEAR(NOW()) - YEAR(bdate)) AS avg_age,
       sex
FROM employee
GROUP BY sex;

-- Find the month that have at least 2 employees born

SELECT MONTH(bdate) AS birth_month
FROM employee
GROUP BY birth_month
HAVING COUNT(birth_month) >= 2;

-- Inner join 2 tables (intersection)
-- List the department number and name and their working projects

SELECT ssn,
       fname,
       lname,
       dname,
       dept_no,
       dnumber
FROM employee e
         INNER JOIN
     department d ON e.dept_no = d.dnumber;

-- How many projects exists in “Human Resource” department?

SELECT COUNT(pnumber),
       dname AS num_proj
FROM department d
         INNER JOIN
     project p ON d.dnumber = p.dept_no
WHERE dname = 'Human Resources'
ORDER BY d.dnumber;

-- How many projects are currently being handled by each department?

SELECT dnumber,
       dname,
       COUNT(pnumber) AS numproj
FROM department d
         INNER JOIN
     project p ON d.dnumber = p.dept_no
GROUP BY d.dnumber
ORDER BY d.dnumber;

-- Find all employess who works in the R&D department

SELECT *
FROM department d
         INNER JOIN
     employee e ON d.dnumber = e.dept_no
WHERE dname = 'Research and Development';

-- Find all departments and their maximum salary of their employees if the salary is NOT NULL

SELECT dname,
       MAX(salary)
FROM department d
         INNER JOIN
     employee e ON d.dnumber = e.dept_no
WHERE salary IS NOT NULL
GROUP BY dname;

-- Right Outer Join (the right-hand set including intersection)
SELECT *
FROM employee e
         RIGHT OUTER JOIN
     department d ON e.dept_no = d.dnumber;

-- Find all employees and their corresponding assigned project

SELECT *
FROM employee e
         INNER JOIN
     assignment a ON e.ssn = a.essn
         INNER JOIN
     project p ON p.pnumber = a.projno;

-- Find all projects that do not have any employee assigned

SELECT essn,
       projno,
       pnumber,
       pname
FROM project p
         LEFT OUTER JOIN
     assignment a ON p.pnumber = a.projno
WHERE a.essn IS NULL
ORDER BY pnumber;

-- Find all male employees that don't have any project assigned

SELECT fname,
       lname,
       sex
FROM employee e
         LEFT OUTER JOIN
     assignment a ON e.ssn = a.essn
WHERE a.essn IS NULL
  AND e.sex = 'M';

-- ----------------------------------------
-- Set Operations
-- ----------------------------------------

-- What are project numbers (pnumber) that have no employees assigned to them?

SELECT pnumber AS projnum
FROM project
EXCEPT
SELECT projno AS projnum
FROM assignment
ORDER BY projnum ASC;

-- Our TinyCompany needs to calculate the total amount of money to be paid to all employees, including:
--   • Salaried employees (from the Employee table)
--   • Hourly employees (from the Assignment table)
-- List all transactions showing how much each person will be paid.
-- Display all payment transactions, including each employee’s SSN and the amount to be paid for each transaction.

SELECT ssn,
       salary AS paid
FROM employee
UNION ALL
SELECT essn,
       ( hours * hourlyrate ) AS paid
FROM assignment;

-- List all employees that are older than the average ages of the employee in the “Research and Development” department
-- Q1: Find the average ages of the employee in the “Research and Development” department
-- Q2: Find the employee whose ages is greater (older) than the age calculate from Q1

-- Q1
SELECT AVG(YEAR(CURDATE()) - YEAR(bdate)) AS avg_age -- 37.5000
FROM employee e
         INNER JOIN
     department d ON e.dept_no = d.dnumber
WHERE d.dname = 'Research and Development';
-- Q2 (insert Q1 as a snippet after >)
SELECT fname,
       lname,
       YEAR(CURDATE()) - YEAR(bdate) AS age
FROM employee
WHERE ( YEAR(CURDATE()) - YEAR(bdate) ) > (
                                              SELECT AVG(YEAR(CURDATE()) - YEAR(bdate)) AS avg_age
                                              FROM employee e
                                                       INNER JOIN
                                                   department d ON e.dept_no = d.dnumber
                                              WHERE d.dname = 'Research and Development'
                                              );

CREATE VIEW sample AS
SELECT ssn,
       SUM(paid)
FROM (
         SELECT ssn,
                salary AS paid
         FROM employee
         UNION ALL
         SELECT essn,
                ( hours * hourlyrate ) AS paid
         FROM assignment
         ) t1
GROUP BY ssn;