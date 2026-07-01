INSERT INTO warehouse.fact_card_swipe (
    swipe_id,
    date_sk,
    card_sk,
    merchant_sk,
    amount,
    device_id
)
SELECT
    s.swipe_id,

    d.date_sk,

    c.card_sk,
    m.merchant_sk,

    s.amount,
    s.device_id

FROM staging.card_swipe_logs s

LEFT JOIN warehouse.dim_date d
    ON d.full_date = DATE(s.timestamp)

LEFT JOIN warehouse.dim_card c
    ON c.card_id = s.card_id
    AND c.is_current = TRUE

LEFT JOIN warehouse.dim_merchant m
    ON m.merchant_id = s.merchant_id
    AND m.is_current = TRUE;