DROP VIEW IF EXISTS warehouse.vw_loan_summary;

CREATE OR REPLACE VIEW warehouse.vw_loan_summary AS

WITH repayment_summary AS (

    SELECT

        loan_sk,

        COUNT(*) AS total_payments,

        COALESCE(SUM(principal_paid),0) AS principal_paid,

        COALESCE(SUM(interest_paid),0) AS interest_paid,

        COALESCE(AVG(late_days),0) AS avg_late_days,

        MAX(date_sk) AS last_payment_date_sk

    FROM warehouse.fact_loan_repayment

    GROUP BY loan_sk

)

SELECT

    fl.loan_sk,
    fl.loan_id,

    dc.customer_id,
    dc.full_name,

    da.account_number,

    db.branch_name,

    fl.loan_amount,
    fl.interest_rate,
    fl.term_months,
    fl.status,

    COALESCE(r.total_payments,0) AS total_payments,

    COALESCE(r.principal_paid,0) AS total_principal_paid,

    COALESCE(r.interest_paid,0) AS total_interest_paid,

    COALESCE(r.avg_late_days,0) AS avg_late_days,

    dd.full_date AS last_payment_date

FROM warehouse.fact_loan fl

LEFT JOIN warehouse.dim_customer dc
ON fl.customer_sk = dc.customer_sk

LEFT JOIN warehouse.dim_account da
ON fl.account_sk = da.account_sk

LEFT JOIN warehouse.dim_branch db
ON da.branch_sk = db.branch_sk

LEFT JOIN repayment_summary r
ON fl.loan_sk = r.loan_sk

LEFT JOIN warehouse.dim_date dd
ON r.last_payment_date_sk = dd.date_sk;