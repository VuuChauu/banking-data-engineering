SET search_path TO warehouse;

------------------------------------------------------------
-- DIM_DATE
------------------------------------------------------------

CREATE TABLE dim_date (
    date_sk                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_date               DATE NOT NULL UNIQUE,
    day                     INT,
    month                   INT,
    month_name              VARCHAR(20),
    quarter                 INT,
    year                    INT,
    week_of_year           INT,
    day_name                VARCHAR(20),
    is_weekend             BOOLEAN DEFAULT FALSE,
    created_at             TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- DIM_BRANCH
------------------------------------------------------------

CREATE TABLE dim_branch (
    branch_sk              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    branch_id              INT NOT NULL,
    branch_name            VARCHAR(255),
    city                   VARCHAR(100),

    effective_date         DATE NOT NULL,
    expiry_date            DATE,
    is_current             BOOLEAN DEFAULT TRUE,

    created_at             TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- DIM_CUSTOMER (SCD2)
------------------------------------------------------------

CREATE TABLE dim_customer (
    customer_sk            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id            INT NOT NULL,

    full_name              VARCHAR(255),
    dob                    DATE,
    phone                  VARCHAR(50),
    email                  VARCHAR(255),
    kyc_status             VARCHAR(30),

    effective_date         DATE NOT NULL,
    expiry_date            DATE,
    is_current             BOOLEAN DEFAULT TRUE,

    created_at             TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- DIM_ACCOUNT
------------------------------------------------------------

CREATE TABLE dim_account (
    account_sk             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id             INT NOT NULL,

    account_number         VARCHAR(30),
    account_type           VARCHAR(30),
    currency               VARCHAR(10),
    status                 VARCHAR(20),
    balance                NUMERIC(18,2),

    customer_sk            BIGINT,
    branch_sk              BIGINT,

    effective_date         DATE NOT NULL,
    expiry_date            DATE,
    is_current             BOOLEAN DEFAULT TRUE,

    created_at             TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- DIM_CARD
------------------------------------------------------------

CREATE TABLE dim_card (
    card_sk                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    card_id                INT NOT NULL,

    card_number           VARCHAR(30),
    card_type             VARCHAR(20),
    credit_limit          NUMERIC(18,2),
    status                VARCHAR(20),

    account_sk            BIGINT,

    effective_date        DATE NOT NULL,
    expiry_date           DATE,
    is_current            BOOLEAN DEFAULT TRUE,

    created_at           TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- DIM_MERCHANT
------------------------------------------------------------

CREATE TABLE dim_merchant (
    merchant_sk            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    merchant_id            INT NOT NULL,

    merchant_name         VARCHAR(255),
    category              VARCHAR(100),
    city                  VARCHAR(100),

    effective_date        DATE NOT NULL,
    expiry_date           DATE,
    is_current            BOOLEAN DEFAULT TRUE,

    created_at           TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
------------------------------------------------------------
-- FACT_TRANSACTION
------------------------------------------------------------

CREATE TABLE fact_transaction (
    transaction_sk         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    transaction_id         BIGINT NOT NULL,

    date_sk                BIGINT NOT NULL,
    from_account_sk        BIGINT,
    to_account_sk          BIGINT,

    amount                 NUMERIC(18,2) NOT NULL,
    transaction_type      VARCHAR(50),
    channel               VARCHAR(50),
    status                VARCHAR(30),

    created_at            TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- FACT_CARD_SWIPE
------------------------------------------------------------

CREATE TABLE fact_card_swipe (
    swipe_sk              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    swipe_id              BIGINT NOT NULL,

    date_sk               BIGINT NOT NULL,
    card_sk               BIGINT,
    merchant_sk           BIGINT,

    amount                NUMERIC(18,2),

    device_id             VARCHAR(100),

    created_at            TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- FACT_LOAN
------------------------------------------------------------

CREATE TABLE fact_loan (
    loan_sk               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    loan_id               BIGINT NOT NULL,

    customer_sk           BIGINT,
    account_sk            BIGINT,

    loan_amount           NUMERIC(18,2),
    interest_rate         NUMERIC(5,2),
    term_months           INT,
    status                VARCHAR(30),

    created_at            TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- FACT_LOAN_REPAYMENT
------------------------------------------------------------

CREATE TABLE fact_loan_repayment (
    repayment_sk          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    repayment_id          BIGINT NOT NULL,

    loan_sk               BIGINT,
    date_sk               BIGINT,

    principal_paid        NUMERIC(18,2),
    interest_paid         NUMERIC(18,2),
    late_days             INT,

    created_at            TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

------------------------------------------------------------
-- FINAL COMMENTS (DATA WAREHOUSE LAYER)
------------------------------------------------------------

COMMENT ON TABLE dim_customer IS 'Customer dimension (SCD Type 2)';
COMMENT ON TABLE dim_account IS 'Account dimension';
COMMENT ON TABLE dim_card IS 'Card dimension';
COMMENT ON TABLE dim_merchant IS 'Merchant dimension';
COMMENT ON TABLE dim_branch IS 'Branch dimension';
COMMENT ON TABLE dim_date IS 'Date dimension for analytics';

COMMENT ON TABLE fact_transaction IS 'Transaction fact table';
COMMENT ON TABLE fact_card_swipe IS 'Card swipe fact table';
COMMENT ON TABLE fact_loan IS 'Loan fact table';
COMMENT ON TABLE fact_loan_repayment IS 'Loan repayment fact table';

------------------------------------------------------------
-- INDEX HINTS (OPTIONAL FOR LATER PHASE)
------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_fact_transaction_date
ON fact_transaction(date_sk);

CREATE INDEX IF NOT EXISTS idx_fact_transaction_account
ON fact_transaction(from_account_sk);

CREATE INDEX IF NOT EXISTS idx_fact_card_swipe_date
ON fact_card_swipe(date_sk);

CREATE INDEX IF NOT EXISTS idx_fact_loan_customer
ON fact_loan(customer_sk);

CREATE INDEX IF NOT EXISTS idx_fact_repayment_loan
ON fact_loan_repayment(loan_sk);

------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------