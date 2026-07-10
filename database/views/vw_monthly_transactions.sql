CREATE OR REPLACE VIEW analytics.vw_monthly_transactions AS

SELECT

    d.year,

    d.month,

    d.month_name,

    COUNT(*) AS total_transactions,

    SUM(t.amount) AS total_amount

FROM warehouse.fact_transaction t

JOIN warehouse.dim_date d

ON t.date_sk = d.date_sk

GROUP BY

    d.year,
    d.month,
    d.month_name

ORDER BY

    d.year,
    d.month;