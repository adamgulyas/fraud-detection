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

-- The two most important customers of the firm may have been hacked.
-- Verify if there are any fraudulent transactions in their history.
-- For privacy reasons, you only know that their cardholder IDs are 2 and 18.
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

-- The CEO of the biggest customer of the firm suspects that someone has used
-- her corporate credit card without authorization in the first quarter of 2018
-- to pay quite expensive restaurant bills. Again, for privacy reasons, you
-- know only that the cardholder ID in question is 25.
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
