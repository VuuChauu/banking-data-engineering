INSERT INTO warehouse.fact_loan (
    loan_id,
    customer_sk,
    account_sk,
    loan_amount,
    interest_rate,
    term_months,
    status
)
SELECT
    s.loan_id,

    c.customer_sk,
    a.account_sk,

    s.loan_amount,
    s.interest_rate,
    s.term_months,
    s.status

FROM staging.loans s

LEFT JOIN warehouse.dim_customer c
    ON c.customer_id = s.customer_id
    AND c.is_current = TRUE

LEFT JOIN warehouse.dim_account a
    ON a.account_id = s.account_id
    AND a.is_current = TRUE;