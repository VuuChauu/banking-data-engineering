INSERT INTO warehouse.fact_loan_repayment (
    repayment_id,
    loan_sk,
    date_sk,
    principal_paid,
    interest_paid,
    late_days
)
SELECT
    s.repayment_id,

    l.loan_sk,

    d.date_sk,

    s.principal_paid,
    s.interest_paid,
    s.late_days

FROM staging.loan_repayments s

LEFT JOIN warehouse.fact_loan l
    ON l.loan_id = s.loan_id

LEFT JOIN warehouse.dim_date d
    ON d.full_date = s.payment_date;