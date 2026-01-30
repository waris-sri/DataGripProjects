-- Waris Sripatoomrak 6788112, Section 3
-- Lecture 15

DROP DATABASE IF EXISTS ICTBank;
CREATE DATABASE IF NOT EXISTS ICTBank;
USE ICTBank;

DROP TABLE IF EXISTS Accounts;

CREATE TABLE Accounts (
    account_id   INT PRIMARY KEY AUTO_INCREMENT,
    account_name VARCHAR(50),
    balance      DECIMAL(10, 2) -- the 2 decimal points are included in the 10 numbers
);

INSERT INTO Accounts (account_name, balance)
VALUES ('Alice', 1000.00),
       ('Bob', 1500.00),
       ('Charlie', 2000.00);

SELECT *
FROM Accounts;

-- Q1

START TRANSACTION;

UPDATE Accounts
SET balance = balance + 1000
WHERE account_name = 'Alice';

UPDATE Accounts
SET balance = balance - 1000
WHERE account_name = 'Bob';

COMMIT;

SELECT *
FROM Accounts;
/*
1,Alice,2000.00
2,Bob,500.00
3,Charlie,2000.00
*/

-- Q2

START TRANSACTION;

-- @ = declare user variable
SET @BALANCEBOB = (
                      SELECT balance
                      FROM Accounts
                      WHERE account_name = 'Bob'
                      ); -- 500.00

UPDATE Accounts
SET balance = balance - 1000
WHERE account_name = 'Bob'
  AND @BALANCEBOB >= 1000;

UPDATE Accounts
SET balance = balance + 1000
WHERE account_name = 'Charlie'
  AND @BALANCEBOB >= 1000;

COMMIT;

SELECT *
FROM Accounts;
/*
1,Alice,2000.00
2,Bob,500.00
3,Charlie,2000.00
*/

-- Q3

UPDATE Accounts
SET balance = balance - 1000
WHERE account_name = 'Charlie';

UPDATE Accounts
SET balance = balance + 1000
WHERE account_name = 'Bob';

COMMIT; -- It's a commit.

SELECT *
FROM Accounts;
/*
1,Alice,2000.00
2,Bob,1500.00
3,Charlie,1000.00
*/

-- Q4
-- NOTE: The current state of the table in both transactions are from the result of Q3.
-- NOTE: Before the experimentation session, both transaction isolations were in repeatable read
--       and the autocommit parameter was already set to 0 beforehand.

-- In Session 1 (Transaction A)
USE ICTBank;
SET autocommit = 0;
SHOW VARIABLES WHERE Variable_name = 'autocommit';
SELECT @@SESSION.TRANSACTION_ISOLATION; -- REPEATABLE-READ (default)
START TRANSACTION;
UPDATE ICTBank.Accounts
SET balance = 1000
WHERE account_name = 'Alice';
UPDATE ICTBank.Accounts
SET balance = balance - 500
WHERE account_name = 'Alice';
SELECT *
FROM ICTBank.Accounts
WHERE account_name = 'Alice';
SELECT *
FROM Accounts;
COMMIT;

-- In Session 2 (Transaction B)
USE ICTBank;
SET autocommit = 0;
SHOW VARIABLES WHERE Variable_name = 'autocommit';
SELECT @@SESSION.TRANSACTION_ISOLATION; -- REPEATABLE-READ (default)
START TRANSACTION;
SELECT *
FROM Accounts
WHERE Accounts.account_name = 'Alice';
COMMIT;
SELECT *
FROM Accounts;

/*
Q4.3 Compare the results of Alice’s balance in Session 1 and Session 2.

    From Transaction A when Transaction A hasn't committed yet:
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    From Transaction B when Transaction A hasn't committed yet
    1,Alice,2000.00
    2,Bob,1500.00
    3,Charlie,1000.00


Q4.4 Commit Transaction A in Session 1, and re-execute and commit Transaction B
in Session 2. What is the value of Alice’s balance in Session 2? Is the
value the same or different from step 3?

    From Transaction B when Transaction A has committed
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00
    Therefore, the value of Transaction B in Q4.4 is different from that of Q4.3.
*/

/*
NOTE: For each experimentation, Alice's balance is reset to 2000.00 like in Q3.

Experimentation (READ UNCOMMITTED):

    From Transaction A when Transaction A hasn't committed yet:
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    From Transaction B when Transaction A hasn't committed yet
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    From Transaction B when Transaction A has committed
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    Both results are the same, since the transaction isolation level allows reading uncommited values.


Experimentation (READ COMMITTED):

    From Transaction A when Transaction A hasn't committed yet:
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    From Transaction B when Transaction A hasn't committed yet
    1,Alice,2000.00
    2,Bob,1500.00
    3,Charlie,1000.00

    From Transaction B when Transaction A has committed
    1,Alice,500.00
    2,Bob,1500.00
    3,Charlie,1000.00

    Later Alice's balance became 500.00 since values in Transaction B can only read and update
    when Transaction A has committed its values.
*/