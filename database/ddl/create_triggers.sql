/*
==============================================================
File        : create_triggers.sql
Project     : Banking Data Engineering
Description : Trigger Definitions
==============================================================
*/

SET search_path TO staging;

------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------

CREATE TRIGGER trg_customer_etl_timestamp

BEFORE INSERT OR UPDATE

ON customers

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- ACCOUNTS
------------------------------------------------------------

CREATE TRIGGER trg_account_etl_timestamp

BEFORE INSERT OR UPDATE

ON accounts

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- CARDS
------------------------------------------------------------

CREATE TRIGGER trg_card_etl_timestamp

BEFORE INSERT OR UPDATE

ON cards

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- MERCHANTS
------------------------------------------------------------

CREATE TRIGGER trg_merchant_etl_timestamp

BEFORE INSERT OR UPDATE

ON merchants

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- TRANSACTIONS
------------------------------------------------------------

CREATE TRIGGER trg_transaction_etl_timestamp

BEFORE INSERT OR UPDATE

ON transactions

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- CARD SWIPES
------------------------------------------------------------

CREATE TRIGGER trg_swipe_etl_timestamp

BEFORE INSERT OR UPDATE

ON card_swipe_logs

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- LOANS
------------------------------------------------------------

CREATE TRIGGER trg_loan_etl_timestamp

BEFORE INSERT OR UPDATE

ON loans

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();

------------------------------------------------------------
-- REPAYMENTS
------------------------------------------------------------

CREATE TRIGGER trg_repayment_etl_timestamp

BEFORE INSERT OR UPDATE

ON loan_repayments

FOR EACH ROW

EXECUTE FUNCTION warehouse.fn_update_etl_timestamp();