DROP VIEW IF EXISTS warehouse.vw_customer_summary;

CREATE OR REPLACE VIEW warehouse.vw_customer_summary AS

WITH transaction_summary AS (

    SELECT

        da.customer_sk,

        COUNT(ft.transaction_sk) AS total_transactions,

        COALESCE(SUM(ft.amount),0) AS total_transaction_amount,

        MAX(dd.full_date) AS last_transaction_date

    FROM warehouse.fact_transaction ft

    LEFT JOIN warehouse.dim_account da

        ON ft.from_account_sk = da.account_sk

    LEFT JOIN warehouse.dim_date dd

        ON ft.date_sk = dd.date_sk

    GROUP BY da.customer_sk

),

loan_summary AS (

    SELECT

        customer_sk,

        COUNT(*) AS total_loans,

        COALESCE(SUM(loan_amount),0) AS total_loan_amount

    FROM warehouse.fact_loan

    GROUP BY customer_sk

)

SELECT

    dc.customer_sk,

    dc.customer_id,

    dc.full_name,

    dc.email,

    dc.phone,

    dc.kyc_status,

    dc.dob,

    COALESCE(ts.total_transactions,0) AS total_transactions,

    COALESCE(ts.total_transaction_amount,0) AS total_transaction_amount,

    ts.last_transaction_date,

    COALESCE(ls.total_loans,0) AS total_loans,

    COALESCE(ls.total_loan_amount,0) AS total_loan_amount

FROM warehouse.dim_customer dc

LEFT JOIN transaction_summary ts

ON dc.customer_sk = ts.customer_sk

LEFT JOIN loan_summary ls

ON dc.customer_sk = ls.customer_sk

WHERE dc.is_current = TRUE;