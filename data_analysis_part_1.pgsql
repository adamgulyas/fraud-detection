-- Drop views if they already exist
DROP VIEW IF EXISTS small_transactions;
DROP VIEW IF EXISTS early_transactions;
DROP VIEW IF EXISTS vulnerable_merchants;
DROP VIEW IF EXISTS fraudulent_transactions;
DROP VIEW IF EXISTS unauthorized_transactions;

-- Count the transactions that are less than $2.00 per cardholder
CREATE VIEW small_transactions AS
SELECT
    cc.cardholder_id,
    COUNT(cc.cardholder_id) AS "transactions"
FROM
    "transaction" AS t
    JOIN "credit_card" AS cc ON t.card = cc.card
WHERE
    t.amount < 2
GROUP BY
    cc.cardholder_id
ORDER BY
    transactions DESC
;

-- Get the top 100 highest transactions made between 7:00 am and 9:00 am
CREATE VIEW early_transactions AS
SELECT
    id_merchant, amount, date
FROM
    "transaction"
WHERE
    EXTRACT(HOUR FROM date) BETWEEN 7 AND 8
ORDER BY
    date ASC
LIMIT 100
;

-- Get the top 5 merchants prone to being hacked using small transactions
CREATE VIEW vulnerable_merchants AS
SELECT
    t.id_merchant,
    m.name,
    COUNT(t.id_merchant) AS small_transactions
FROM
    "transaction" AS t
    JOIN "merchant" AS m ON t.id_merchant = m.id
WHERE
    amount < 2
GROUP BY
    id_merchant,
    m.name
ORDER BY
    small_transactions DESC
LIMIT
    5
;

-- Verify if there are any fraudulent transactions in the history of specific card holders
CREATE VIEW fraudulent_transactions AS
SELECT
    cc.cardholder_id,
    t.amount,
    t.date
FROM
    "transaction" AS t
    JOIN "credit_card" AS cc ON t.card = cc.card
WHERE
    cc.cardholder_id = 2
    OR cc.cardholder_id = 18
ORDER BY
    t.date ASC
;

-- Get transactions for a specific card holder and order and sort from largest to smallest
CREATE VIEW unauthorized_transactions AS
SELECT
    cc.cardholder_id,
    t.amount,
    t.date
FROM
    "transaction" AS t
    JOIN "credit_card" AS cc ON t.card = cc.card
WHERE
    cc.cardholder_id = 25
ORDER BY
    t.amount DESC
;
