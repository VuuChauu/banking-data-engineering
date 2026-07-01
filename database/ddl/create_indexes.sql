/*
==============================================================
File        : create_indexes.sql
Project     : Banking Data Engineering
Description : Create indexes for staging schema
==============================================================
*/

SET search_path TO staging;

------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_customer_email
ON customers(email);

CREATE INDEX IF NOT EXISTS idx_customer_phone
ON customers(phone);

CREATE INDEX IF NOT EXISTS idx_customer_created_at
ON customers(created_at);

------------------------------------------------------------
-- BRANCHES
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_branch_city
ON branches(city);

------------------------------------------------------------
-- ACCOUNTS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_account_customer
ON accounts(customer_id);

CREATE INDEX IF NOT EXISTS idx_account_branch
ON accounts(branch_id);

CREATE INDEX IF NOT EXISTS idx_account_status
ON accounts(status);

CREATE INDEX IF NOT EXISTS idx_account_currency
ON accounts(currency);

CREATE INDEX IF NOT EXISTS idx_account_type
ON accounts(account_type);

------------------------------------------------------------
-- CARDS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_card_account
ON cards(account_id);

CREATE INDEX IF NOT EXISTS idx_card_status
ON cards(status);

CREATE INDEX IF NOT EXISTS idx_card_type
ON cards(card_type);

------------------------------------------------------------
-- MERCHANTS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_merchant_category
ON merchants(category);

CREATE INDEX IF NOT EXISTS idx_merchant_city
ON merchants(city);

------------------------------------------------------------
-- TRANSACTIONS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_transaction_time
ON transactions(timestamp);

CREATE INDEX IF NOT EXISTS idx_transaction_status
ON transactions(status);

CREATE INDEX IF NOT EXISTS idx_transaction_channel
ON transactions(channel);

CREATE INDEX IF NOT EXISTS idx_transaction_type
ON transactions(transaction_type);

CREATE INDEX IF NOT EXISTS idx_transaction_from_account
ON transactions(from_account_id);

CREATE INDEX IF NOT EXISTS idx_transaction_to_account
ON transactions(to_account_id);

CREATE INDEX IF NOT EXISTS idx_transaction_lookup
ON transactions(from_account_id,to_account_id,timestamp);

------------------------------------------------------------
-- CARD SWIPE LOGS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_swipe_card
ON card_swipe_logs(card_id);

CREATE INDEX IF NOT EXISTS idx_swipe_merchant
ON card_swipe_logs(merchant_id);

CREATE INDEX IF NOT EXISTS idx_swipe_time
ON card_swipe_logs(timestamp);

------------------------------------------------------------
-- LOANS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_loan_customer
ON loans(customer_id);

CREATE INDEX IF NOT EXISTS idx_loan_account
ON loans(account_id);

CREATE INDEX IF NOT EXISTS idx_loan_status
ON loans(status);

------------------------------------------------------------
-- REPAYMENTS
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_repayment_loan
ON loan_repayments(loan_id);

CREATE INDEX IF NOT EXISTS idx_payment_date
ON loan_repayments(payment_date);