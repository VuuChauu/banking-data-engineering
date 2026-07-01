INSERT INTO warehouse.fact_transaction (
    transaction_id,
    date_sk,
    from_account_sk,
    to_account_sk,
    amount,
    transaction_type,
    channel,
    status
)
SELECT
    s.transaction_id,

    d.date_sk,

    af.account_sk AS from_account_sk,
    at.account_sk AS to_account_sk,

    s.amount,
    s.transaction_type,
    s.channel,
    s.status

FROM staging.transactions s

LEFT JOIN warehouse.dim_date d
ON d.full_date = DATE(s.timestamp)

LEFT JOIN warehouse.dim_account af
    ON af.account_id = s.from_account_id
    AND af.is_current = TRUE

LEFT JOIN warehouse.dim_account at
    ON at.account_id = s.to_account_id
    AND at.is_current = TRUE;