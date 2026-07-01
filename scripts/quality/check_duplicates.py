from config.logging import logger

from config.database import get_connection


CHECKS = [

    (
        "fact_transaction",
        """
        SELECT COUNT(*)

        FROM (

            SELECT transaction_id

            FROM warehouse.fact_transaction

            GROUP BY transaction_id

            HAVING COUNT(*) > 1

        ) t
        """
    ),

    (
        "fact_card_swipe",
        """
        SELECT COUNT(*)

        FROM (

            SELECT swipe_id

            FROM warehouse.fact_card_swipe

            GROUP BY swipe_id

            HAVING COUNT(*) > 1

        ) t
        """
    ),

    (
        "fact_loan",
        """
        SELECT COUNT(*)

        FROM (

            SELECT loan_id

            FROM warehouse.fact_loan

            GROUP BY loan_id

            HAVING COUNT(*) > 1

        ) t
        """
    ),

    (
        "fact_loan_repayment",
        """
        SELECT COUNT(*)

        FROM (

            SELECT repayment_id

            FROM warehouse.fact_loan_repayment

            GROUP BY repayment_id

            HAVING COUNT(*) > 1

        ) t
        """
    )

]


def main():

    logger.info("=" * 70)
    logger.info("DUPLICATE CHECK")
    logger.info("=" * 70)

    conn = get_connection()

    cur = conn.cursor()

    success = True

    try:

        for table, sql in CHECKS:

            cur.execute(sql)

            duplicates = cur.fetchone()[0]

            if duplicates == 0:

                logger.success(
                    f"{table:<30} DUPLICATES = {duplicates}"
                )

            else:

                success = False

                logger.error(
                    f"{table:<30} DUPLICATES = {duplicates}"
                )

    finally:

        cur.close()
        conn.close()

    return success


if __name__ == "__main__":

    if main():
        logger.success("DUPLICATE CHECK PASSED")
    else:
        logger.error("DUPLICATE CHECK FAILED")