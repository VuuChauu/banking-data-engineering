CREATE OR REPLACE VIEW analytics.vw_card_summary AS

SELECT

    c.card_type,

    COUNT(*) AS total_cards,

    SUM(s.amount) AS total_swipe_amount

FROM warehouse.dim_card c

LEFT JOIN warehouse.fact_card_swipe s

ON c.card_sk = s.card_sk

WHERE c.is_current = TRUE

GROUP BY

    c.card_type;