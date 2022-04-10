-- Some fraudsters hack a credit card by making several small
-- transactions (generally less than $2.00), which are typically
-- ignored by cardholders.

-- Count the transactions that are less than $2.00 per cardholder.
CREATE VIEW small_transactions AS
SELECT
    c.cardholder_id,
    COUNT(c.cardholder_id) AS "transactions"
FROM
    TRANSACTION AS t
    JOIN credit_card AS c ON t.card = c.card
WHERE
    t.amount < 2
GROUP BY
    c.cardholder_id
ORDER BY
    transactions DESC;

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
CREATE VIEW early_transactions AS
SELECT
    id_merchant, amount, date
FROM
    TRANSACTION
WHERE
    EXTRACT("hour" FROM "date") BETWEEN 7 AND 8
ORDER BY
    date ASC
LIMIT 100;

-- What are the top 5 merchants prone to being hacked using small transactions?
CREATE VIEW vulnerable_merchants AS
SELECT
    t.id_merchant,
    m.name,
    COUNT(t.id_merchant) AS small_transactions
FROM
    TRANSACTION AS t
    JOIN merchant AS m ON t.id_merchant = m.id
WHERE
    amount < 2
GROUP BY
    id_merchant,
    m.name
ORDER BY
    small_transactions DESC
LIMIT
    5;
