DROP VIEW IF EXISTS warehouse.vw_card_usage;

CREATE OR REPLACE VIEW warehouse.vw_card_usage AS

WITH swipe_summary AS (

    SELECT

        card_sk,

        COUNT(*) AS total_swipes,

        COALESCE(SUM(amount),0) AS total_spent,

        COALESCE(AVG(amount),0) AS avg_swipe_amount,

        MAX(date_sk) AS last_date_sk

    FROM warehouse.fact_card_swipe

    GROUP BY card_sk

)

SELECT

    c.card_sk,
    c.card_id,
    c.card_number,
    c.card_type,
    c.credit_limit,
    c.status,

    a.account_number,

    cu.customer_id,
    cu.full_name,

    b.branch_name,
    b.city,

    COALESCE(s.total_swipes,0) AS total_swipes,
    COALESCE(s.total_spent,0) AS total_spent,
    COALESCE(s.avg_swipe_amount,0) AS avg_swipe_amount,

    d.full_date AS last_swipe_date

FROM warehouse.dim_card c

LEFT JOIN warehouse.dim_account a
ON c.account_sk = a.account_sk

LEFT JOIN warehouse.dim_customer cu
ON a.customer_sk = cu.customer_sk

LEFT JOIN warehouse.dim_branch b
ON a.branch_sk = b.branch_sk

LEFT JOIN swipe_summary s
ON c.card_sk = s.card_sk

LEFT JOIN warehouse.dim_date d
ON s.last_date_sk = d.date_sk

WHERE c.is_current = TRUE;