# File này dùng để xóa sạch dữ liệu trong staging nhưng giữ nguyên cấu trúc bảng.
import time

from config.logging import logger

from config.database import get_connection


TABLES = [
    "loan_repayments",
    "loans",
    "card_swipe_logs",
    "transactions",
    "cards",
    "accounts",
    "merchants",
    "customers",
    "branches"
]


def main():

    start = time.time()

    conn = get_connection()
    cur = conn.cursor()

    logger.info("=" * 60)
    logger.info("TRUNCATE STAGING TABLES")
    logger.info("=" * 60)

    try:

        for table in TABLES:

            logger.info(f"Cleaning staging.{table}")

            cur.execute(
                f"TRUNCATE TABLE staging.{table} RESTART IDENTITY CASCADE;"
            )

        conn.commit()

        logger.success("All staging tables truncated.")

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