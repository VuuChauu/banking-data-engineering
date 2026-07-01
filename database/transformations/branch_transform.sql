INSERT INTO warehouse.dim_branch (
    branch_id,
    branch_name,
    city,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    s.branch_id,
    s.branch_name,
    s.city,
    CURRENT_DATE,
    NULL,
    TRUE
FROM staging.branches s
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.dim_branch d
    WHERE d.branch_id = s.branch_id
      AND d.is_current = TRUE
);