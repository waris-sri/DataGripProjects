# -- Lecture 15 (since slide p.51)
# -- MySQL Transaction (Isolation Levels Demo)
# -- Data source for this file is `@localhost`
#
# -- Changes in this file will affect the file on @localhost [2]
# -- whether it has to be commited to be effective or not depends on
# -- the transaction isolation level configuration (default = repeatable read)
#
# DROP DATABASE IF EXISTS TransactionDemo;
# CREATE DATABASE IF NOT EXISTS TransactionDemo;
# USE TransactionDemo;
#
# CREATE TABLE accounts (
#     account_id   INT PRIMARY KEY AUTO_INCREMENT,
#     account_name VARCHAR(50),
#     balance      DECIMAL(10, 2)
# );
#
# INSERT INTO accounts (account_name, balance)
# VALUES ('Alice', 900.00),
#        ('Bob', 1600.00),
#        ('Charlie', 2000.00);
#
-- Turn off autocommit for demo purposes
SHOW VARIABLES WHERE Variable_name = 'autocommit';
SET autocommit = 0;
SHOW VARIABLES WHERE Variable_name = 'autocommit';
#
# START TRANSACTION;
# UPDATE accounts
# SET balance = balance - 200
# WHERE account_name = 'Charlie';
#
# SELECT *
# FROM accounts;
#
# COMMIT;
# -- Charlie's balance will be 1800
# # ROLLBACK; -- Charlie's balance will be back to 2000; before the commit
#
# SELECT *
# FROM accounts;

-- Below is used for Lecture 15's activity (Q4)
USE ICTBank;

SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@session.transaction_isolation;


-- RESET STATE
UPDATE ICTBank.Accounts
SET balance = 2000
WHERE account_name = 'Alice';
COMMIT;


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
/*
[READ UNCOMMITTED]
From Transaction A when Transaction A hasn't committed yet:
1,Alice,500.00
2,Bob,1500.00
3,Charlie,1000.00
*/

/*
[READ COMMITTED]
From Transaction A when Transaction A hasn't committed yet:
1,Alice,500.00
2,Bob,1500.00
3,Charlie,1000.00
*/

COMMIT;
