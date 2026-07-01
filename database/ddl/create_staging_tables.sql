/*
==============================================================
File        : create_staging_tables.sql
Project     : Banking Data Engineering
Description : Create staging tables
Author      : Your Name
==============================================================
*/

SET search_path TO staging;

-------------------------------------------------------------
-- CUSTOMERS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS customers (

    customer_id             INTEGER PRIMARY KEY,

    full_name               VARCHAR(255) NOT NULL,

    dob                     DATE NOT NULL,

    phone                   VARCHAR(50),

    email                   VARCHAR(255),

    kyc_status              VARCHAR(30),

    created_at              TIMESTAMP,

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- BRANCHES
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS branches (

    branch_id               INTEGER PRIMARY KEY,

    branch_name             VARCHAR(255) NOT NULL,
    city                    VARCHAR(100),

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- ACCOUNTS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS accounts (

    account_id              INTEGER PRIMARY KEY,

    account_number          VARCHAR(30) NOT NULL,

    customer_id             INTEGER NOT NULL,

    branch_id               INTEGER NOT NULL,

    account_type            VARCHAR(30),

    currency                VARCHAR(10),

    balance                 NUMERIC(18,2),

    status                  VARCHAR(30),

    opened_at               TIMESTAMP,

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- CARDS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS cards (

    card_id                 INTEGER PRIMARY KEY,

    account_id              INTEGER NOT NULL,

    card_number             VARCHAR(30),

    card_type               VARCHAR(20),

    credit_limit            NUMERIC(18,2),

    expiry_date             DATE,

    status                  VARCHAR(30),

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- MERCHANTS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS merchants (

    merchant_id             INTEGER PRIMARY KEY,

    merchant_name           VARCHAR(255),

    category                VARCHAR(100),

    city                    VARCHAR(100),

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- TRANSACTIONS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS transactions (

    transaction_id          BIGINT PRIMARY KEY,

    from_account_id         INTEGER,

    to_account_id           INTEGER,

    amount                  NUMERIC(18,2),

    transaction_type        VARCHAR(50),

    channel                 VARCHAR(50),

    status                  VARCHAR(30),

    timestamp               TIMESTAMP,

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- CARD SWIPE LOGS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS card_swipe_logs (

    swipe_id                BIGINT PRIMARY KEY,

    card_id                 INTEGER,

    merchant_id             INTEGER,

    amount                  NUMERIC(18,2),

    device_id               VARCHAR(100),

    timestamp               TIMESTAMP,

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- LOANS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS loans (

    loan_id                 INTEGER PRIMARY KEY,

    customer_id             INTEGER,

    account_id              INTEGER,

    loan_amount             NUMERIC(18,2),

    interest_rate           NUMERIC(5,2),

    term_months             INTEGER,

    status                  VARCHAR(30),

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);

-------------------------------------------------------------
-- LOAN REPAYMENTS
-------------------------------------------------------------

CREATE TABLE IF NOT EXISTS loan_repayments (

    repayment_id            BIGINT PRIMARY KEY,

    loan_id                 INTEGER,

    principal_paid          NUMERIC(18,2),

    interest_paid           NUMERIC(18,2),

    payment_date            DATE,

    late_days               INTEGER,

    etl_batch_id            UUID,

    etl_loaded_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    source_file             VARCHAR(255)

);