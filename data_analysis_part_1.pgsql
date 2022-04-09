-- Some fraudsters hack a credit card by making several small
-- transactions (generally less than $2.00), which are typically
-- ignored by cardholders.

-- Count the transactions that are less than $2.00 per cardholder.
SELECT COUNT(c.cardholder_id) AS "small_transactions", c.cardholder_id
FROM transaction as t
JOIN credit_card as c
ON t.card = c.card
WHERE t.amount < 2
GROUP BY c.cardholder_id
ORDER BY small_transactions DESC;

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT *
FROM transaction
WHERE EXTRACT("hour" from "date") BETWEEN 7 AND 8;
