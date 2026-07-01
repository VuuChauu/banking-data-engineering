# Banking Data Engineering Pipeline

An end-to-end Data Engineering project that builds a modern banking ETL pipeline using Python, PostgreSQL, Apache Airflow, Docker, and AWS S3.

The pipeline ingests raw banking datasets, transforms them into a dimensional Data Warehouse using a Star Schema, performs automated data quality validation, and orchestrates the entire workflow with Apache Airflow.

> **Key Highlights**
>
> * End-to-End ETL Pipeline
> * PostgreSQL Data Warehouse
> * Star Schema Modeling
> * AWS S3 Integration
> * Apache Airflow Orchestration
> * Automated Data Quality Checks
> * Dockerized Development Environment

---

# Architecture

```text
                        Raw CSV Files
                              │
                              ▼
                          AWS S3
                     (raw / archive)
                              │
                              ▼
                 Python Ingestion Layer
                              │
                              ▼
                  PostgreSQL Staging
                              │
                              ▼
                  SQL Transformations
                              │
                              ▼
                 Data Warehouse Layer
                (Dimension & Fact Tables)
                              │
                              ▼
                    Analytics Views
                              │
                              ▼
                 Data Quality Validation
                              │
                              ▼
                   Apache Airflow DAG
```

---

# Project Objectives

This project demonstrates how to:

* Build an end-to-end ETL pipeline using Python and SQL.
* Design a dimensional Data Warehouse using a Star Schema.
* Automate data ingestion from AWS S3 into PostgreSQL.
* Transform staging data into analytical warehouse tables.
* Validate data quality through automated checks.
* Orchestrate ETL workflows with Apache Airflow.
* Deploy the complete environment using Docker.

---

# Technology Stack

| Category         | Technologies           |
| ---------------- | ---------------------- |
| Programming      | Python 3.11            |
| Database         | PostgreSQL 16          |
| SQL              | PostgreSQL SQL         |
| Data Processing  | Pandas                 |
| Cloud Storage    | AWS S3                 |
| Workflow         | Apache Airflow         |
| Containerization | Docker, Docker Compose |
| AWS SDK          | Boto3                  |
| Database Driver  | Psycopg2               |
| Logging          | Loguru                 |

---

# Project Structure

```text
banking-data-engineering/

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
│   ├── warehouse/
│   ├── quality/
│   └── pipeline/
│
├── requirements.txt
├── docker-compose.yml
├── .env.example
└── README.md
```

---

# ETL Workflow

The pipeline executes the following stages:

1. Upload raw CSV files to AWS S3.
2. Download datasets from S3.
3. Load raw data into PostgreSQL staging tables.
4. Execute warehouse DDL scripts.
5. Transform staging data into dimension tables.
6. Populate fact tables.
7. Create analytics views.
8. Execute automated data quality checks.
9. Complete the ETL workflow through Apache Airflow.

---

# Data Warehouse Design

The warehouse follows a **Star Schema** architecture.

## Dimension Tables

* dim_customer
* dim_account
* dim_branch
* dim_card
* dim_merchant
* dim_date

## Fact Tables

* fact_transaction
* fact_card_swipe
* fact_loan
* fact_loan_repayment

---

# Data Quality Validation

The pipeline automatically validates warehouse data after each execution.

Implemented checks include:

* Row Count Validation
* NULL Value Detection
* Duplicate Detection
* Pipeline Validation Reports

---

# AWS S3 Features

Supported operations include:

* Upload files
* Download files
* Archive processed datasets
* List bucket objects
* Delete files
* Batch cleanup utilities

---

# Apache Airflow

Apache Airflow orchestrates the complete ETL workflow.

Pipeline tasks include:

* Upload to AWS S3
* Download from AWS S3
* Load PostgreSQL Staging
* Execute Warehouse DDL
* Run SQL Transformations
* Build Analytics Views
* Execute Data Quality Checks

---

# Installation

## Clone Repository

```bash
git clone https://github.com/<your-github-username>/banking-data-engineering.git

cd banking-data-engineering
```

## Configure Environment

Create a `.env` file from `.env.example`.

Configure:

* PostgreSQL credentials
* AWS credentials
* Airflow configuration

## Install Dependencies

```bash
pip install -r requirements.txt
```

## Start Docker Services

```bash
docker compose up -d
```

## Execute Full Pipeline

```bash
python -m scripts.pipeline.run_full_pipeline
```

---

# Screenshots

Include screenshots such as:

* Airflow DAG
* AWS S3 Bucket
* PostgreSQL Tables
* pgAdmin
* Analytics Views
* Data Quality Report

---

# Future Improvements

* Incremental ETL
* Change Data Capture (CDC)
* dbt Transformations
* Great Expectations
* CI/CD with GitHub Actions
* Apache Spark
* Apache Kafka
* Amazon Redshift
* Snowflake

---

# Skills Demonstrated

* Data Engineering
* ETL Development
* Data Warehouse Modeling
* SQL Optimization
* Python Automation
* AWS S3
* Apache Airflow
* Docker
* PostgreSQL
* Data Quality Engineering

---

# License

This project is licensed under the MIT License.
