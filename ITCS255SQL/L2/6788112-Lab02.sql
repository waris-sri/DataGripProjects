USE Lab02_classicmodels_db;

-- Task 2
SELECT 
    COUNT(customerName) AS 'NYC Customers'
FROM
    customers
WHERE
    city LIKE 'NYC';

-- Task 3
SELECT 
    AVG(amount) AS 'avg_payment',
    STD(amount) AS 'paymet_std_dev'
FROM
    payments
WHERE
    MONTH(paymentDate) BETWEEN 7 AND 9;

-- Task 4
SELECT 
    country, state, COUNT(officeCode) AS 'numOffices'
FROM
    offices
GROUP BY state , country
ORDER BY country;

-- Task 5
SELECT 
    productLine,
    COUNT(productCode) AS 'numProd',
    (MAX(MSRP) - MIN(MSRP)) AS 'rangeMSRP'
FROM
    products
GROUP BY productLine
HAVING COUNT(productCode) BETWEEN 10 AND 20;

-- Task 6
SELECT 
    productLine, ROUND(AVG(MSRP - buyPrice), 2) AS 'avgDiff'
FROM
    products
GROUP BY productLine
ORDER BY AVG(MSRP - buyPrice) DESC;

-- Task 7
SELECT 
    COUNT(e.employeeNumber) AS 'numLtdComp'
FROM
    customers c
        INNER JOIN
    employees e ON e.employeeNumber LIKE c.salesRepEmployeeNumber
WHERE
    c.customerName LIKE '%Ltd.'
        AND CONCAT(firstName, ' ', lastName) LIKE 'Leslie Jennings';

-- Task 8
-- e1 = supervisor, e2 = employee
SELECT 
    e1.employeeNumber,
    CONCAT(e1.firstName, ' ', e1.lastName) AS 'fullname',
    e1.jobTitle,
    COUNT(e1.reportsTo) AS 'numSubEmp'
FROM
    employees e1
        INNER JOIN
    employees e2 ON e2.reportsTo LIKE e1.employeeNumber
WHERE
    e1.jobTitle LIKE '%Manager%'
GROUP BY e2.reportsTo;

-- Task 9
SELECT 
    p.productCode, p.productName
FROM
    products p
        LEFT OUTER JOIN
    orderdetails o ON p.productCode = o.productCode
WHERE
    o.productCode IS NULL;

-- Task 10
SELECT
    CONCAT(e.firstName, ' ', e.lastName) AS SalesRep,
    CONCAT(o.city, ', ', o.state)        AS SalesLocation,
    c.customerName                      AS CustomerName,
    CONCAT(c.city, ', ', c.state)       AS CustomerLocation
FROM employees e
JOIN offices o
    ON e.officeCode = o.officeCode
CROSS JOIN customers c
WHERE e.jobTitle = 'Sales Rep'
  AND o.country = 'USA'
  AND c.country = 'USA';
  
-- Task 11
SELECT
    CONCAT(contactFirstName, ' ', contactLastName) AS contact_name,
    phone AS phone_number,
    'Customer' AS contact_type
FROM customers

UNION ALL

SELECT
    CONCAT(firstName, ' ', lastName) AS contact_name,
    CONCAT(o.phone, '-', e.extension) AS phone_number,
    'Employee' AS contact_type
FROM employees e
JOIN offices o
    ON e.officeCode = o.officeCode
ORDER BY contact_name;

-- Task 12
SELECT
    productLine,
    productCode,
    productName,
    total_quantity
FROM (
    SELECT
        p.productLine,
        p.productCode,
        p.productName,
        SUM(od.quantityOrdered) AS total_quantity,
        ROW_NUMBER() OVER (
            PARTITION BY p.productLine
            ORDER BY SUM(od.quantityOrdered) DESC
        ) AS rn
    FROM products p
    JOIN orderdetails od
        ON p.productCode = od.productCode
    WHERE p.productLine IN ('Motorcycles', 'Classic Cars', 'Vintage Cars')
    GROUP BY p.productLine, p.productCode, p.productName
) ranked
WHERE rn <= 3
ORDER BY productLine, total_quantity DESC;