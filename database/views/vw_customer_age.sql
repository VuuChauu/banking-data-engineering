CREATE OR REPLACE VIEW analytics.vw_customer_age AS

SELECT

    CASE

        WHEN EXTRACT(YEAR FROM AGE(dob)) < 25 THEN '<25'

        WHEN EXTRACT(YEAR FROM AGE(dob)) BETWEEN 25 AND 34 THEN '25-34'

        WHEN EXTRACT(YEAR FROM AGE(dob)) BETWEEN 35 AND 44 THEN '35-44'

        WHEN EXTRACT(YEAR FROM AGE(dob)) BETWEEN 45 AND 54 THEN '45-54'

        ELSE '55+'

    END AS age_group,

    COUNT(*) AS total_customers

FROM warehouse.dim_customer

WHERE is_current = TRUE

GROUP BY

    age_group

ORDER BY

    age_group;