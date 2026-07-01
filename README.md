# Banking Data Engineering Pipeline

An end-to-end Data Engineering project that builds a complete ETL pipeline for banking transaction data. The project demonstrates modern data engineering practices, including data ingestion, cloud storage integration, data warehousing, workflow orchestration, and automated data quality validation.

---

# 1. Project Overview

This project simulates a real-world banking data platform where transactional data is processed through multiple layers before being transformed into a dimensional Data Warehouse for analytics.

The pipeline includes:

- Raw data ingestion from CSV files
- AWS S3 integration for data storage
- PostgreSQL staging and warehouse layers
- SQL-based ETL transformations
- Star Schema data modeling
- Automated data quality validation
- Apache Airflow workflow orchestration
- Dockerized deployment

The primary objective is to demonstrate an end-to-end Data Engineering workflow suitable for analytical reporting and business intelligence.

---

# 2. System Architecture

```text
                         +----------------------+
                         |   Banking CSV Data   |
                         +----------+-----------+
                                    |
                                    |
                                    ▼
                         +----------------------+
                         |        AWS S3        |
                         |   raw / archive      |
                         +----------+-----------+
                                    |
                                    ▼
                    +-------------------------------+
                    | Python Ingestion Layer         |
                    | (Download & Load to Staging)   |
                    +---------------+----------------+
                                    |
                                    ▼
                       PostgreSQL Staging Database
                                    |
                                    ▼
                    SQL Transformation (ETL Scripts)
                                    |
                                    ▼
                   PostgreSQL Data Warehouse (Star Schema)
                                    |
                    +---------------+----------------+
                    |                                |
                    ▼                                ▼
            Analytics Views                Data Quality Checks
                    |                                |
                    +---------------+----------------+
                                    |
                                    ▼
                         Apache Airflow Scheduler
```

---

# 3. Technology Stack

| Category | Technology |
|----------|------------|
| Programming Language | Python 3.11 |
| Database | PostgreSQL 16 |
| Data Processing | Pandas |
| SQL | PostgreSQL SQL |
| Cloud Storage | AWS S3 |
| Workflow Orchestration | Apache Airflow |
| Containerization | Docker & Docker Compose |
| AWS SDK | Boto3 |
| Database Driver | Psycopg2 |
| Logging | Loguru |


---

# 4. Project Structure

```text
banking-data-engineering/
│
├── airflow/
│   ├── dags/
│   └── logs/
│
├── config/
│
├── data/
│   ├── raw/
│   └── archive/
│
├── database/
│   ├── ddl/
│   ├── transformations/
│   ├── views/
│   └── quality/
│
├── docker/
│
├── scripts/
│   ├── aws/
│   ├── ingestion/
│   ├── pipeline/
│   ├── quality/
│   └── warehouse/
│
├── requirements.txt
├── docker-compose.yml
├── .env.example
└── README.md
```

---

# 5. Installation & Setup

## Clone Repository

```bash
git clone https://github.com/VuuChauu/banking-data-engineering.git

cd banking-data-engineering
```

## Configure Environment

Create a `.env` file based on `.env.example`.

Configure:

- PostgreSQL
- AWS S3
- Airflow

## Install Dependencies

```bash
pip install -r requirements.txt
```

## Start Infrastructure

```bash
docker compose up -d
```

## Execute the Complete Pipeline

```bash
python -m scripts.pipeline.run_full_pipeline
```

## Launch Airflow

```
http://localhost:8080
```

Trigger the DAG from the Airflow UI to execute the pipeline automatically.

---

# 6. Data Flow

The pipeline executes the following workflow:

1. Banking transaction datasets are stored as CSV files.
2. CSV files are uploaded to AWS S3.
3. Files are downloaded from S3 to the local raw directory.
4. Python ingestion scripts load the data into PostgreSQL staging tables.
5. SQL transformation scripts populate warehouse dimension tables.
6. Fact tables are generated using business keys and surrogate keys.
7. Analytics views are created for reporting.
8. Automated quality checks validate warehouse integrity.
9. Apache Airflow orchestrates the complete ETL process.

---

# 7. Data Warehouse Design

The warehouse is implemented using a **Star Schema**.

## Dimension Tables

- dim_date
- dim_customer
- dim_account
- dim_branch
- dim_card
- dim_merchant

## Fact Tables

- fact_transaction
- fact_card_swipe
- fact_loan
- fact_loan_repayment

The dimensional model simplifies analytical queries while improving reporting performance.

---

# 8. Data Quality Validation

The project includes automated validation scripts executed after every warehouse refresh.

Implemented quality checks include:

### Row Count Validation

Verifies that expected records exist across staging and warehouse layers.

### NULL Validation

Ensures mandatory business columns do not contain missing values.

### Duplicate Detection

Detects duplicate business keys within fact and dimension tables.

These checks help maintain consistency and reliability throughout the ETL pipeline.

---

# 9. Airflow Workflow

The Airflow DAG orchestrates the complete ETL process:

```text
Upload to S3
      │
      ▼
Download from S3
      │
      ▼
Load CSV to PostgreSQL
      │
      ▼
Refresh Data Warehouse
      │
      ▼
Run Data Quality Checks
```

Each task is executed sequentially with dependency management and execution logging.

---

# 10. Key Features

- End-to-End ETL Pipeline
- AWS S3 Data Lake Integration
- PostgreSQL Data Warehouse
- Star Schema Modeling
- SQL-Based Transformations
- Automated Data Quality Validation
- Apache Airflow Orchestration
- Dockerized Deployment
- Centralized Logging
- Modular Project Structure

---

# 11. Future Enhancements

Potential improvements include:

- Incremental ETL Processing
- Change Data Capture (CDC)
- dbt Transformation Framework
- Great Expectations
- Apache Spark Processing
- Kafka Streaming Integration
- Amazon Redshift
- Snowflake Data Warehouse
- CI/CD Pipeline with GitHub Actions

---
