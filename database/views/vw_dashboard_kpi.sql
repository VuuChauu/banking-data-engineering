CREATE OR REPLACE VIEW analytics.vw_dashboard_kpi AS

SELECT

    (SELECT COUNT(*) FROM warehouse.dim_customer WHERE is_current = TRUE)
        AS total_customers,

    (SELECT COUNT(*) FROM warehouse.dim_account WHERE is_current = TRUE)
        AS total_accounts,

    (SELECT COUNT(*) FROM warehouse.fact_transaction)
        AS total_transactions,

    (SELECT COALESCE(SUM(amount),0)
     FROM warehouse.fact_transaction)
        AS total_transaction_amount,

    (SELECT COUNT(*) FROM warehouse.fact_loan)
        AS total_loans,

    (SELECT COALESCE(SUM(loan_amount),0)
     FROM warehouse.fact_loan)
        AS total_loan_amount;