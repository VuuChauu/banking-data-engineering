-- =========================================================
-- CUSTOMER DIMENSION - SCD TYPE 2
-- =========================================================

INSERT INTO warehouse.dim_customer (
    customer_id,
    full_name,
    dob,
    phone,
    email,
    kyc_status,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    s.customer_id,
    s.full_name,
    s.dob,
    s.phone,
    s.email,
    s.kyc_status,
    CURRENT_DATE AS effective_date,
    NULL AS expiry_date,
    TRUE AS is_current
FROM staging.customers s
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.dim_customer d
    WHERE d.customer_id = s.customer_id
      AND d.is_current = TRUE
);