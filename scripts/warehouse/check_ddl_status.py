# Nó chỉ là file kiểm tra.

# Bạn chỉ chạy khi muốn biết:

# bảng staging đã tạo chưa
# bảng warehouse đã tạo chưa
# thiếu bảng nào
# sau khi clone project trên máy khác
from config.logging import logger

from config.database import get_connection


def check_table(schema, table):

    conn = get_connection()
    cur = conn.cursor()

    cur.execute(
        """
        SELECT EXISTS(
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema=%s
              AND table_name=%s
        )
        """,
        (schema, table),
    )

    exists = cur.fetchone()[0]

    cur.close()
    conn.close()

    return exists


DDL_TABLES = {

    "staging": [
        "customers",
        "branches",
        "accounts",
        "cards",
        "merchants",
        "transactions",
        "card_swipe_logs",
        "loans",
        "loan_repayments",
    ],

    "warehouse": [
        "dim_date",
        "dim_branch",
        "dim_customer",
        "dim_account",
        "dim_card",
        "dim_merchant",
        "fact_transaction",
        "fact_card_swipe",
        "fact_loan",
        "fact_loan_repayment",
    ],
}


def main():

    logger.info("=" * 60)
    logger.info("CHECK DDL STATUS")
    logger.info("=" * 60)

    for schema, tables in DDL_TABLES.items():

        logger.info(f"\nSchema: {schema}")

        for table in tables:

            status = "OK" if check_table(schema, table) else "MISSING"

            logger.info(f"{table:<30} {status}")


if __name__ == "__main__":
    main()