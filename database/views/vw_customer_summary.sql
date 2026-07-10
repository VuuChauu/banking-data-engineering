CREATE OR REPLACE VIEW analytics.vw_customer_summary AS
SELECT
    c.customer_id,
    c.full_name,
    COUNT(a.account_sk) AS total_accounts,
    COALESCE(AVG(a.balance), 0) AS average_balance,
    COALESCE(SUM(a.balance), 0) AS total_balance
FROM warehouse.dim_customer c
LEFT JOIN warehouse.dim_account a
    ON c.customer_sk = a.customer_sk
WHERE c.is_current = TRUE
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY
    total_balance DESC;