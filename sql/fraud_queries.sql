-- Credit card fraud questions, in SQL.
-- Table: creditcard_fraud
-- Columns: Time (seconds since first transaction), V1..V28 (PCA),
--          Amount, Class (1 = fraud, 0 = legitimate).
-- SQLite-compatible. Load creditcard.csv into the table first.

-- 1. How many transactions are there, and how many are fraud?
SELECT
    COUNT(*) AS total_transactions,
    SUM(Class) AS fraud_count,
    COUNT(*) - SUM(Class) AS legitimate_count,
    ROUND(100.0 * SUM(Class) / COUNT(*), 3) AS fraud_rate_pct
FROM creditcard_fraud;

-- 2. How does the transaction amount compare for fraud vs legitimate?
SELECT
    Class AS is_fraud,
    COUNT(*) AS transactions,
    ROUND(AVG(Amount), 2) AS avg_amount,
    ROUND(MIN(Amount), 2) AS min_amount,
    ROUND(MAX(Amount), 2) AS max_amount
FROM creditcard_fraud
GROUP BY Class;

-- 3. Fraud rate by amount band — where does fraud concentrate?
SELECT
    CASE
        WHEN Amount < 10 THEN 'Under $10'
        WHEN Amount < 50 THEN '$10 - $50'
        WHEN Amount < 100 THEN '$50 - $100'
        WHEN Amount < 500 THEN '$100 - $500'
        ELSE '$500 and over'
    END AS amount_band,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_count,
    ROUND(100.0 * SUM(Class) / COUNT(*), 3) AS fraud_rate_pct
FROM creditcard_fraud
GROUP BY amount_band
ORDER BY MIN(Amount);

-- 4. Fraud count by hour of day (Time is seconds from the first transaction).
SELECT
    CAST((Time / 3600) % 24 AS INTEGER) AS hour_of_day,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_count,
    ROUND(100.0 * SUM(Class) / COUNT(*), 3) AS fraud_rate_pct
FROM creditcard_fraud
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 5. What share of the total money is fraud?
SELECT
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS fraud_amount_total,
    ROUND(SUM(Amount), 2) AS all_amount_total,
    ROUND(100.0 * SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END) / SUM(Amount), 3) AS fraud_share_of_money_pct
FROM creditcard_fraud;

-- 6. Average amount of fraud by hour — do fraud amounts change through the day?
SELECT
    CAST((Time / 3600) % 24 AS INTEGER) AS hour_of_day,
    COUNT(*) AS fraud_count,
    ROUND(AVG(Amount), 2) AS avg_fraud_amount
FROM creditcard_fraud
WHERE Class = 1
GROUP BY hour_of_day
ORDER BY hour_of_day;
