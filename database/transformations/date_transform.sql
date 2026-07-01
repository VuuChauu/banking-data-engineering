-- ============================================================
-- Populate Date Dimension
-- ============================================================

TRUNCATE TABLE warehouse.dim_date RESTART IDENTITY CASCADE;

INSERT INTO warehouse.dim_date
(
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    week_of_year,
    day_name,
    is_weekend
)

SELECT

    d::date,

    EXTRACT(DAY FROM d),

    EXTRACT(MONTH FROM d),

    TO_CHAR(d,'Month'),

    EXTRACT(QUARTER FROM d),

    EXTRACT(YEAR FROM d),

    EXTRACT(WEEK FROM d),

    TO_CHAR(d,'Day'),

    CASE
        WHEN EXTRACT(ISODOW FROM d) IN (6,7)
        THEN TRUE
        ELSE FALSE
    END

FROM generate_series(

    DATE '2020-01-01',

    DATE '2035-12-31',

    INTERVAL '1 day'

) AS d;