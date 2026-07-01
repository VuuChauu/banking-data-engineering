
# Xóa toàn bộ dữ liệu trong Warehouse.
import time

from config.logging import logger

from config.database import get_connection


TABLES = [

    "fact_loan_repayment",

    "fact_card_swipe",

    "fact_transaction",

    "fact_loan",

    "dim_card",

    "dim_account",

    "dim_customer",

    "dim_branch",

    "dim_merchant",

    "dim_date"

]


def main():

    start = time.time()

    conn = get_connection()
    cur = conn.cursor()

    logger.info("=" * 60)
    logger.info("TRUNCATE DATA WAREHOUSE")
    logger.info("=" * 60)

    try:

        for table in TABLES:

            logger.info(f"Cleaning warehouse.{table}")

            cur.execute(
                f"TRUNCATE TABLE warehouse.{table} RESTART IDENTITY CASCADE;"
            )

        conn.commit()

        logger.success("Warehouse cleaned.")

    except Exception as e:

        conn.rollback()
        logger.exception(e)
        raise

    finally:

        cur.close()
        conn.close()

    logger.success(f"Completed in {round(time.time()-start,2)} sec")


if __name__ == "__main__":
    main()