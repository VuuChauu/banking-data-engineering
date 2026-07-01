INSERT INTO warehouse.dim_merchant (
    merchant_id,
    merchant_name,
    category,
    city,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    s.merchant_id,
    s.merchant_name,
    s.category,
    s.city,
    CURRENT_DATE,
    NULL,
    TRUE
FROM staging.merchants s
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.dim_merchant d
    WHERE d.merchant_id = s.merchant_id
      AND d.is_current = TRUE
);