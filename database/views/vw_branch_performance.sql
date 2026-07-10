CREATE OR REPLACE VIEW analytics.vw_branch_performance AS

SELECT

    b.branch_name,

    b.city,

    COUNT(t.transaction_sk) AS total_transactions,

    SUM(t.amount) AS total_amount

FROM warehouse.fact_transaction t

JOIN warehouse.dim_account a

ON t.from_account_sk = a.account_sk

JOIN warehouse.dim_branch b

ON a.branch_sk = b.branch_sk

GROUP BY

    b.branch_name,
    b.city

ORDER BY

    total_amount DESC;