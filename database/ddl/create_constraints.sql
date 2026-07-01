/*
==============================================================
File        : create_constraints.sql
Project     : Banking Data Engineering
Description : Create Primary, Foreign Key, Check & Unique Constraints
==============================================================
*/

SET search_path TO staging;

------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------

ALTER TABLE customers
ADD CONSTRAINT chk_customer_kyc
CHECK (kyc_status IN ('Verified','Pending','Rejected'));

------------------------------------------------------------
-- BRANCHES
------------------------------------------------------------

-- No constraint required

------------------------------------------------------------
-- ACCOUNTS
------------------------------------------------------------

ALTER TABLE accounts
ADD CONSTRAINT fk_accounts_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE accounts
ADD CONSTRAINT fk_accounts_branch
FOREIGN KEY (branch_id)
REFERENCES branches(branch_id);

ALTER TABLE accounts
ADD CONSTRAINT uq_account_number
UNIQUE(account_number);

ALTER TABLE accounts
ADD CONSTRAINT chk_account_balance
CHECK(balance >= 0);

ALTER TABLE accounts
ADD CONSTRAINT chk_account_type
CHECK(account_type IN
(
'Saving',
'Checking',
'Business'
));

ALTER TABLE accounts
ADD CONSTRAINT chk_account_currency
CHECK(currency IN
(
'USD',
'VND',
'EUR'
));

ALTER TABLE accounts
ADD CONSTRAINT chk_account_status
CHECK(status IN
(
'Active',
'Inactive',
'Closed'
));

------------------------------------------------------------
-- CARDS
------------------------------------------------------------

ALTER TABLE cards
ADD CONSTRAINT fk_cards_account
FOREIGN KEY(account_id)
REFERENCES accounts(account_id);

ALTER TABLE cards
ADD CONSTRAINT uq_card_number
UNIQUE(card_number);

ALTER TABLE cards
ADD CONSTRAINT chk_card_type
CHECK(card_type IN
(
'Debit',
'Credit'
));

ALTER TABLE cards
ADD CONSTRAINT chk_card_status
CHECK(status IN
(
'Active',
'Blocked',
'Expired'
));

ALTER TABLE cards
ADD CONSTRAINT chk_credit_limit
CHECK
(
credit_limit IS NULL
OR credit_limit >= 0
);

------------------------------------------------------------
-- MERCHANTS
------------------------------------------------------------

ALTER TABLE merchants
ADD CONSTRAINT chk_merchant_category
CHECK(category IN
(
'Restaurant',
'Shopping',
'Fuel',
'Hotel',
'Coffee',
'Supermarket',
'Hospital',
'Airline'
));

------------------------------------------------------------
-- TRANSACTIONS
------------------------------------------------------------

ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_from_account
FOREIGN KEY(from_account_id)
REFERENCES accounts(account_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_to_account
FOREIGN KEY(to_account_id)
REFERENCES accounts(account_id);

ALTER TABLE transactions
ADD CONSTRAINT chk_transaction_amount
CHECK(amount > 0);

ALTER TABLE transactions
ADD CONSTRAINT chk_transaction_type
CHECK(transaction_type IN
(
'Transfer',
'Deposit',
'Withdrawal'
));

ALTER TABLE transactions
ADD CONSTRAINT chk_transaction_channel
CHECK(channel IN
(
'ATM',
'Mobile',
'Branch',
'POS',
'Internet Banking'
));

ALTER TABLE transactions
ADD CONSTRAINT chk_transaction_status
CHECK(status IN
(
'SUCCESS',
'FAILED',
'PENDING'
));

------------------------------------------------------------
-- CARD SWIPE LOGS
------------------------------------------------------------

ALTER TABLE card_swipe_logs
ADD CONSTRAINT fk_swipe_card
FOREIGN KEY(card_id)
REFERENCES cards(card_id);

ALTER TABLE card_swipe_logs
ADD CONSTRAINT fk_swipe_merchant
FOREIGN KEY(merchant_id)
REFERENCES merchants(merchant_id);

ALTER TABLE card_swipe_logs
ADD CONSTRAINT chk_swipe_amount
CHECK(amount > 0);

------------------------------------------------------------
-- LOANS
------------------------------------------------------------

ALTER TABLE loans
ADD CONSTRAINT fk_loan_customer
FOREIGN KEY(customer_id)
REFERENCES customers(customer_id);

ALTER TABLE loans
ADD CONSTRAINT fk_loan_account
FOREIGN KEY(account_id)
REFERENCES accounts(account_id);

ALTER TABLE loans
ADD CONSTRAINT chk_interest_rate
CHECK
(
interest_rate >=0
AND
interest_rate <=100
);

ALTER TABLE loans
ADD CONSTRAINT chk_term
CHECK(term_months IN
(
12,
24,
36,
48,
60
));

ALTER TABLE loans
ADD CONSTRAINT chk_loan_amount
CHECK(loan_amount >0);

ALTER TABLE loans
ADD CONSTRAINT chk_loan_status
CHECK(status IN
(
'Active',
'Closed',
'Default'
));

------------------------------------------------------------
-- LOAN REPAYMENTS
------------------------------------------------------------

ALTER TABLE loan_repayments
ADD CONSTRAINT fk_repayment_loan
FOREIGN KEY(loan_id)
REFERENCES loans(loan_id);

ALTER TABLE loan_repayments
ADD CONSTRAINT chk_principal
CHECK(principal_paid>=0);

ALTER TABLE loan_repayments
ADD CONSTRAINT chk_interest
CHECK(interest_paid>=0);

ALTER TABLE loan_repayments
ADD CONSTRAINT chk_late_days
CHECK(late_days>=0);