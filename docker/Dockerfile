FROM apache/airflow:2.9.2-python3.11

USER root

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    build-essential

USER airflow

COPY airflow/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt