/*
==============================================================
File        : create_functions.sql
Project     : Banking Data Engineering
Description : Common ETL Functions
==============================================================
*/

------------------------------------------------------------
-- UUID Extension
------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

------------------------------------------------------------
-- Generate ETL Batch ID
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_generate_batch_id()
RETURNS UUID
LANGUAGE SQL
AS
$$
SELECT uuid_generate_v4();
$$;

------------------------------------------------------------
-- Update ETL Loaded Time
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_update_etl_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN

    NEW.etl_loaded_at := CURRENT_TIMESTAMP;

    RETURN NEW;

END;
$$;

------------------------------------------------------------
-- Validate Email
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_validate_email(email_address TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN email_address ~*
    '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

END;
$$;

------------------------------------------------------------
-- Validate Phone Number
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_validate_phone(phone_number TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN LENGTH(phone_number)>=8;
END;
$$;

------------------------------------------------------------
-- Mask Card Number
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_mask_card_number(card_no TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN
    '************' ||
    RIGHT(card_no,4);

END;
$$;

------------------------------------------------------------
-- Mask Account Number
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_mask_account_number(acc_no TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN
    '******'||
    RIGHT(acc_no,4);

END;
$$;

------------------------------------------------------------
-- Calculate Customer Age
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_calculate_age(dob DATE)
RETURNS INTEGER
LANGUAGE SQL
AS
$$

SELECT DATE_PART('year',AGE(CURRENT_DATE,dob));

$$;

------------------------------------------------------------
-- Customer Balance
------------------------------------------------------------

CREATE OR REPLACE FUNCTION warehouse.fn_customer_balance(customer INTEGER)
RETURNS NUMERIC
LANGUAGE SQL
AS
$$

SELECT
COALESCE(SUM(balance),0)

FROM staging.accounts

WHERE customer_id=customer;

$$;