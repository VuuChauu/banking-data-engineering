from config.logging import logger

from config.database import get_connection


CHECKS = [

    (
        "fact_transaction",
        """
        SELECT COUNT(*)

        FROM warehouse.fact_transaction

        WHERE date_sk IS NULL
           OR transaction_id IS NULL
        """
    ),

    (
        "fact_card_swipe",
        """
        SELECT COUNT(*)

        FROM warehouse.fact_card_swipe

        WHERE swipe_id IS NULL
           OR date_sk IS NULL
        """
    ),

    (
        "fact_loan",
        """
        SELECT COUNT(*)

        FROM warehouse.fact_loan

        WHERE loan_id IS NULL
        """
    ),

    (
        "fact_loan_repayment",
        """
        SELECT COUNT(*)

        FROM warehouse.fact_loan_repayment

        WHERE repayment_id IS NULL
        """
    ),

]


def main():

    logger.info("=" * 70)
    logger.info("NULL CHECK")
    logger.info("=" * 70)

    conn = get_connection()

    cur = conn.cursor()

    success = True

    try:

        for table, sql in CHECKS:

            cur.execute(sql)

            total = cur.fetchone()[0]

            if total == 0:

                logger.success(
                    f"{table:<30} NULLS = {total}"
                )

            else:

                success = False

                logger.error(
                    f"{table:<30} NULLS = {total}"
                )

    finally:

        cur.close()
        conn.close()

    return success


if __name__ == "__main__":

    if main():
        logger.success("NULL CHECK PASSED")
    else:
        logger.error("NULL CHECK FAILED")