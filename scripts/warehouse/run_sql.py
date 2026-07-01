import os
import time
import psycopg2
from dotenv import load_dotenv
from pathlib import Path
from config.logging import logger

# ------------------------------------------------------------
# LOAD ENV
# ------------------------------------------------------------

load_dotenv()

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

DDL_PATH = Path("database/ddl")

DDL_ORDER = [
    "create_schema.sql",
    "create_staging_tables.sql",
    "create_constraints.sql",
    "create_indexes.sql",
    "create_functions.sql",
    "create_triggers.sql",
    "create_dw_tables.sql"
]

# ------------------------------------------------------------
# DB CONNECTION
# ------------------------------------------------------------

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

# ------------------------------------------------------------
# EXECUTE SQL FILE
# ------------------------------------------------------------

def execute_sql_file(conn, file_path):
    logger.info(f"Running: {file_path.name}")

    start_time = time.time()

    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    with conn.cursor() as cur:
        cur.execute(sql)

    conn.commit()

    end_time = time.time()

    logger.success(
        f"Completed: {file_path.name} | Time: {round(end_time - start_time, 2)}s"
    )

# ------------------------------------------------------------
# MAIN RUNNER
# ------------------------------------------------------------

def run_ddl_pipeline():
    logger.info("Starting DDL Pipeline...")

    conn = get_connection()

    try:
        for file_name in DDL_ORDER:
            file_path = DDL_PATH / file_name

            if not file_path.exists():
                raise FileNotFoundError(f"Missing file: {file_name}")

            execute_sql_file(conn, file_path)

        logger.success("ALL DDL EXECUTED SUCCESSFULLY")

    except Exception as e:
        conn.rollback()
        logger.error(f"Pipeline failed: {str(e)}")
        raise

    finally:
        conn.close()
        logger.info("Connection closed")

# ------------------------------------------------------------
# ENTRY POINT
# ------------------------------------------------------------

if __name__ == "__main__":
    run_ddl_pipeline()