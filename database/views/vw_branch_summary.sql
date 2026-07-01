DROP VIEW IF EXISTS warehouse.vw_branch_summary;

CREATE OR REPLACE VIEW warehouse.vw_branch_summary AS

WITH account_summary AS (

    SELECT

        branch_sk,

        COUNT(*) AS total_accounts,

        COALESCE(SUM(balance),0) AS total_balance

    FROM warehouse.dim_account

    WHERE is_current = TRUE

    GROUP BY branch_sk

),

transaction_summary AS (

    SELECT

        da.branch_sk,

        COUNT(ft.transaction_sk) AS total_transactions,

        COALESCE(SUM(ft.amount),0) AS total_transaction_amount

    FROM warehouse.fact_transaction ft

    LEFT JOIN warehouse.dim_account da

        ON ft.from_account_sk = da.account_sk

    GROUP BY da.branch_sk

)

SELECT

    db.branch_sk,

    db.branch_id,

    db.branch_name,

    db.city,

    COALESCE(a.total_accounts,0) AS total_accounts,

    COALESCE(a.total_balance,0) AS total_balance,

    COALESCE(t.total_transactions,0) AS total_transactions,

    COALESCE(t.total_transaction_amount,0) AS total_transaction_amount

FROM warehouse.dim_branch db

LEFT JOIN account_summary a

ON db.branch_sk = a.branch_sk

LEFT JOIN transaction_summary t

ON db.branch_sk = t.branch_sk

WHERE db.is_current = TRUE;