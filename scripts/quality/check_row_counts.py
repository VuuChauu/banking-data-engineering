from config.logging import logger


from config.database import get_connection


TABLES = [

    ("staging", "customers", "warehouse", "dim_customer"),
    ("staging", "branches", "warehouse", "dim_branch"),
    ("staging", "accounts", "warehouse", "dim_account"),
    ("staging", "cards", "warehouse", "dim_card"),
    ("staging", "merchants", "warehouse", "dim_merchant"),

    ("staging", "transactions", "warehouse", "fact_transaction"),
    ("staging", "card_swipe_logs", "warehouse", "fact_card_swipe"),
    ("staging", "loans", "warehouse", "fact_loan"),
    ("staging", "loan_repayments", "warehouse", "fact_loan_repayment"),
]


def get_count(cur, schema, table):

    cur.execute(
        f"""
        SELECT COUNT(*)
        FROM {schema}.{table}
        """
    )

    return cur.fetchone()[0]


def main():

    logger.info("=" * 70)
    logger.info("ROW COUNT CHECK")
    logger.info("=" * 70)

    conn = get_connection()

    cur = conn.cursor()

    success = True

    try:

        for s_schema, s_table, w_schema, w_table in TABLES:

            staging_rows = get_count(cur, s_schema, s_table)
            warehouse_rows = get_count(cur, w_schema, w_table)

            if staging_rows == warehouse_rows:

                logger.success(
                    f"{s_table:<25}"
                    f" staging={staging_rows:<8}"
                    f" warehouse={warehouse_rows:<8}"
                )

            else:

                success = False

                logger.error(
                    f"{s_table:<25}"
                    f" staging={staging_rows:<8}"
                    f" warehouse={warehouse_rows:<8}"
                )

    finally:

        cur.close()
        conn.close()

    return success


if __name__ == "__main__":

    if main():
        logger.success("ROW COUNT CHECK PASSED")
    else:
        logger.error("ROW COUNT CHECK FAILED")