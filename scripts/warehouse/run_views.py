import os
import time

from config.logging import logger

from config.database import get_connection

VIEW_PATH = "database/views"

VIEW_FILES = [
    "vw_customer_summary.sql",
    "vw_branch_summary.sql",
    "vw_account_summary.sql",
    "vw_transaction_summary.sql",
    "vw_card_usage.sql",
    "vw_loan_summary.sql",
]


def execute_sql(cursor, file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        sql = f.read()

    cursor.execute(sql)


def main():

    start = time.time()

    logger.info("=" * 60)
    logger.info("CREATING ANALYTICS VIEWS")
    logger.info("=" * 60)

    conn = get_connection()
    cur = conn.cursor()

    try:

        for file_name in VIEW_FILES:

            file_path = os.path.join(VIEW_PATH, file_name)

            if not os.path.exists(file_path):
                raise FileNotFoundError(file_path)

            logger.info(f"Creating {file_name}")

            execute_sql(cur, file_path)

            conn.commit()

            logger.success(f"{file_name} created successfully")

    except Exception as e:

        conn.rollback()

        logger.exception(e)

        raise

    finally:

        cur.close()
        conn.close()

    logger.success(
        f"All views created in {round(time.time() - start, 2)} seconds."
    )


if __name__ == "__main__":
    main()