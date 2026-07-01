import os
import time

from config.logging import logger
from config.database import get_connection

TRANSFORM_PATH = "database/transformations"

TRANSFORM_FILES = [
    "branch_transform.sql",
    "date_transform.sql",
    "customer_transform.sql",
    "account_transform.sql",
    "card_transform.sql",
    "merchant_transform.sql",
    "transaction_transform.sql",
    "swipe_transform.sql",
    "loan_transform.sql",
    "repayment_transform.sql"
]


def truncate_fact_tables(cur):

    tables = [
        "warehouse.fact_transaction",
        "warehouse.fact_card_swipe",
        "warehouse.fact_loan",
        "warehouse.fact_loan_repayment"
    ]

    logger.info("================================================")
    logger.info("CLEAR FACT TABLES (PREVENT DUPLICATES)")
    logger.info("================================================")

    for table in tables:
        logger.info(f"Clearing {table}")
        cur.execute(f"TRUNCATE TABLE {table}")


def execute_sql(cursor, file_path):

    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    cursor.execute(sql)


def main():

    start = time.time()

    logger.info("=" * 60)
    logger.info("RUNNING DATA WAREHOUSE TRANSFORMATIONS")
    logger.info("=" * 60)

    conn = get_connection()
    cur = conn.cursor()

    try:

        truncate_fact_tables(cur)
        conn.commit()

        for file_name in TRANSFORM_FILES:

            file_path = os.path.join(TRANSFORM_PATH, file_name)

            if not os.path.exists(file_path):
                raise FileNotFoundError(file_path)

            logger.info(f"Running {file_name}")

            execute_sql(cur, file_path)

            conn.commit()

            logger.success(f"{file_name} completed")

    except Exception as e:

        conn.rollback()
        logger.exception(e)
        raise

    finally:

        cur.close()
        conn.close()

    logger.success(
        f"All transformations completed in {round(time.time()-start,2)} seconds."
    )


if __name__ == "__main__":
    main()