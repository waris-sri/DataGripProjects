# -- Lecture 15 (since slide p.51)
# -- MySQL Transaction (Isolation Levels Demo)
# -- Data source for this file is `@localhost [2]`
#
# -- Changes in this file will affect the file on @localhost
# -- whether it has to be committed to be effective or not depends on
# -- the transaction isolation level configuration (default = repeatable read)
#
SELECT @@session.transaction_isolation; -- @@ reads/writes MySQL settings
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- default
# SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
# SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
#
# USE TransactionDemo;
# SELECT *
# FROM accounts;
#
# UPDATE accounts
# SET balance = balance + 500 -- if goes right, 1800 + 500 = 2300
# WHERE account_name = 'Charlie';
#
# SELECT *
# FROM accounts; -- @localhost's side will still show 2000 since we haven't committed it yet
#
# COMMIT;

-- Below is used for Lecture 15's activity (Q4)
USE ICTBank;
SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@session.transaction_isolation;

-- RESET STATE
# UPDATE ICTBank.Accounts
# SET balance = 2000
# WHERE account_name = 'Alice';
# COMMIT;

START TRANSACTION;
SELECT *
FROM Accounts
WHERE Accounts.account_name = 'Alice';
/*
From Transaction B when Transaction A hasn't committed yet
1,Alice,2000.00
*/
COMMIT;
SELECT *
FROM Accounts;
/*
[READ UNCOMMITTED]
From Transaction B when Transaction A hasn't committed yet
1,Alice,500.00
2,Bob,1500.00
3,Charlie,1000.00
*/

/*
[READ UNCOMMITTED]
From Transaction B when Transaction A hasn't committed yet
1,Alice,2000.00
2,Bob,1500.00
3,Charlie,1000.00

From Transaction B when Transaction A has committed
1,Alice,500.00
2,Bob,1500.00
3,Charlie,1000.00
*/

/*
After committing:
1,Alice,2000.00
2,Bob,1500.00
3,Charlie,1000.00
*/
/*
From Transaction B when Transaction A has committed
1,Alice,500.00
2,Bob,1500.00
3,Charlie,1000.00
*/