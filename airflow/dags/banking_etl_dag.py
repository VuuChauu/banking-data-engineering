from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


default_args = {
    "owner": "banking",
    "depends_on_past": False,
    "retries": 1,
}


with DAG(

    dag_id="banking_etl_pipeline",

    default_args=default_args,

    start_date=datetime(2025, 1, 1),

    schedule="@daily",

    catchup=False,

    tags=["banking", "etl"],

) as dag:

    upload = BashOperator(
        task_id="upload_to_s3",
        bash_command="cd /opt/airflow/project && python -m scripts.aws.upload_to_s3",
    )

    download = BashOperator(
        task_id="download_from_s3",
        bash_command="cd /opt/airflow/project && python -m scripts.aws.download_from_s3",
    )

    load = BashOperator(
        task_id="load_to_postgres",
        bash_command="cd /opt/airflow/project && python -m scripts.ingestion.load_to_postgres",
    )

    transform = BashOperator(
        task_id="run_transformations",
        bash_command="cd /opt/airflow/project && python -m scripts.warehouse.run_transformations",
    )

    views = BashOperator(
        task_id="create_views",
        bash_command="cd /opt/airflow/project && python -m scripts.warehouse.run_views",
    )

    quality = BashOperator(
        task_id="quality_check",
        bash_command="cd /opt/airflow/project && python -m scripts.quality.run_quality_checks",
    )

    archive = BashOperator(
        task_id="archive_s3",
        bash_command="cd /opt/airflow/project && python -m scripts.aws.archive_to_s3",
    )

    (
        upload
        >> download
        >> load
        >> transform
        >> views
        >> quality
        >> archive
    )