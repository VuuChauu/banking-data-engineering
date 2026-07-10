CREATE OR REPLACE VIEW analytics.vw_transaction_dashboard AS

SELECT

    t.transaction_id,

    d.full_date,
    d.year,
    d.month,
    d.month_name,

    c.customer_id,
    c.full_name,

    a.account_number,
    a.account_type,
    a.currency,

    b.branch_name,

    t.amount,
    t.transaction_type,
    t.channel,
    t.status

FROM warehouse.fact_transaction t

LEFT JOIN warehouse.dim_date d
ON t.date_sk = d.date_sk

LEFT JOIN warehouse.dim_account a
ON t.from_account_sk = a.account_sk

LEFT JOIN warehouse.dim_customer c
ON a.customer_sk = c.customer_sk

LEFT JOIN warehouse.dim_branch b
ON a.branch_sk = b.branch_sk

WHERE
    c.is_current = TRUE
AND a.is_current = TRUE
AND b.is_current = TRUE;