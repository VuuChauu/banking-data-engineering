INSERT INTO warehouse.dim_card (
    card_id,
    card_number,
    card_type,
    credit_limit,
    status,
    account_sk,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    s.card_id,
    s.card_number,
    s.card_type,
    s.credit_limit,
    s.status,
    a.account_sk,
    CURRENT_DATE,
    NULL,
    TRUE
FROM staging.cards s
LEFT JOIN warehouse.dim_account a
    ON s.account_id = a.account_id
    AND a.is_current = TRUE
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.dim_card d
    WHERE d.card_id = s.card_id
      AND d.is_current = TRUE
);