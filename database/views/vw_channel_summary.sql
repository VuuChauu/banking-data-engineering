CREATE OR REPLACE VIEW analytics.vw_channel_summary AS

SELECT

    channel,

    COUNT(*) AS total_transactions,

    SUM(amount) AS total_amount

FROM warehouse.fact_transaction

GROUP BY

    channel

ORDER BY

    total_transactions DESC;