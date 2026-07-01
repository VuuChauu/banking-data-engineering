from pathlib import Path

import pandas as pd
from config.logging import logger

from config.database import get_connection

# ==========================
# PATHS
# ==========================

BASE_DIR = Path(__file__).resolve().parents[2]
DATA_PATH = BASE_DIR / "data" / "raw"

# ==========================
# TABLE MAPPING
# ==========================

TABLES = [
    ("customers.csv", "customers"),
    ("branches.csv", "branches"),
    ("accounts.csv", "accounts"),
    ("cards.csv", "cards"),
    ("merchants.csv", "merchants"),
    ("transactions.csv", "transactions"),
    ("card_swipe_logs.csv", "card_swipe_logs"),
    ("loans.csv", "loans"),
    ("loan_repayments.csv", "loan_repayments"),
]
def truncate_staging(conn):
    cur = conn.cursor()

    tables = [
        "staging.customers",
        "staging.branches",
        "staging.accounts",
        "staging.cards",
        "staging.merchants",
        "staging.transactions",
        "staging.card_swipe_logs",
        "staging.loans",
        "staging.loan_repayments",
    ]

    for table in tables:
        cur.execute(f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE")

    conn.commit()
    cur.close()

def load_csv(conn, csv_file: str, table_name: str):

    file_path = DATA_PATH / csv_file

    if not file_path.exists():
        raise FileNotFoundError(f"{file_path} not found")

    logger.info(f"Loading {csv_file} -> staging.{table_name}")

    df = pd.read_csv(file_path)

    columns = ",".join(df.columns)
    placeholders = ",".join(["%s"] * len(df.columns))

    sql = f"""
        INSERT INTO staging.{table_name}
        ({columns})
        VALUES ({placeholders})
    """

    with conn.cursor() as cur:

        for row in df.itertuples(index=False, name=None):
            cur.execute(sql, row)

    conn.commit()

    logger.success(
        f"Loaded staging.{table_name} ({len(df):,} rows)"
    )


def main():

    logger.info("=" * 60)
    logger.info("LOAD CSV TO STAGING")
    logger.info("=" * 60)

    conn = get_connection()

    try:
        truncate_staging(conn)   
        for csv_file, table_name in TABLES:
            load_csv(conn, csv_file, table_name)

        logger.success("ALL CSV FILES LOADED SUCCESSFULLY")

    except Exception as e:

        conn.rollback()
        logger.exception(e)
        raise

    finally:

        conn.close()


if __name__ == "__main__":
    main()