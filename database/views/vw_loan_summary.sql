CREATE OR REPLACE VIEW analytics.vw_loan_summary AS

SELECT

    status,

    COUNT(*) AS total_loans,

    SUM(loan_amount) AS total_amount,

    AVG(interest_rate) AS average_interest_rate

FROM warehouse.fact_loan

GROUP BY

    status;