INSERT INTO warehouse.dim_date (
    full_date,
    day,
    month,
    quarter,
    year,
    day_name,
    month_name,
    is_weekend
)
SELECT
    d::date,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    TO_CHAR(d, 'FMDay'),
    TO_CHAR(d, 'FMMonth'),
    CASE
        WHEN EXTRACT(ISODOW FROM d) IN (6,7)
        THEN TRUE
        ELSE FALSE
    END
FROM generate_series(
    '2018-01-01'::date,
    '2035-12-31'::date,
    INTERVAL '1 day'
) d;