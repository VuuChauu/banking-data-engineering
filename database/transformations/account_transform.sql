INSERT INTO warehouse.dim_account (
    account_id,
    account_number,
    account_type,
    currency,
    status,
    balance,
    customer_sk,
    branch_sk,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    s.account_id,
    s.account_number,
    s.account_type,
    s.currency,
    s.status,
    s.balance,

    c.customer_sk,
    b.branch_sk,

    CURRENT_DATE,
    NULL,
    TRUE
FROM staging.accounts s
LEFT JOIN warehouse.dim_customer c
    ON s.customer_id = c.customer_id
    AND c.is_current = TRUE
LEFT JOIN warehouse.dim_branch b
    ON s.branch_id = b.branch_id
    AND b.is_current = TRUE
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.dim_account d
    WHERE d.account_id = s.account_id
      AND d.is_current = TRUE
);