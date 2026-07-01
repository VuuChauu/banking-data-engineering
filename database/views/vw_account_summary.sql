DROP VIEW IF EXISTS warehouse.vw_account_summary;

CREATE OR REPLACE VIEW warehouse.vw_account_summary AS

WITH outgoing AS (

    SELECT
        from_account_sk AS account_sk,
        COUNT(*) AS total_outgoing_transactions,
        COALESCE(SUM(amount),0) AS total_outgoing_amount
    FROM warehouse.fact_transaction
    GROUP BY from_account_sk

),

incoming AS (

    SELECT
        to_account_sk AS account_sk,
        COUNT(*) AS total_incoming_transactions,
        COALESCE(SUM(amount),0) AS total_incoming_amount
    FROM warehouse.fact_transaction
    GROUP BY to_account_sk

),

loan_summary AS (

    SELECT
        account_sk,
        COUNT(*) AS total_loans,
        COALESCE(SUM(loan_amount),0) AS total_loan_amount
    FROM warehouse.fact_loan
    GROUP BY account_sk

)

SELECT

    a.account_sk,
    a.account_id,
    a.account_number,
    a.account_type,
    a.currency,
    a.balance,
    a.status,

    c.customer_id,
    c.full_name,

    b.branch_name,
    b.city,

    COALESCE(o.total_outgoing_transactions,0) AS total_outgoing_transactions,
    COALESCE(o.total_outgoing_amount,0) AS total_outgoing_amount,

    COALESCE(i.total_incoming_transactions,0) AS total_incoming_transactions,
    COALESCE(i.total_incoming_amount,0) AS total_incoming_amount,

    COALESCE(l.total_loans,0) AS total_loans,
    COALESCE(l.total_loan_amount,0) AS total_loan_amount

FROM warehouse.dim_account a

LEFT JOIN warehouse.dim_customer c
ON a.customer_sk = c.customer_sk

LEFT JOIN warehouse.dim_branch b
ON a.branch_sk = b.branch_sk

LEFT JOIN outgoing o
ON a.account_sk = o.account_sk

LEFT JOIN incoming i
ON a.account_sk = i.account_sk

LEFT JOIN loan_summary l
ON a.account_sk = l.account_sk

WHERE a.is_current = TRUE;