import subprocess
import sys
import time
from pathlib import Path

from config.logging import logger

# ==========================
# PROJECT ROOT
# ==========================

ROOT = Path(__file__).resolve().parents[2]

# ==========================
# PIPELINE
# ==========================

STEPS = [

    (
        "Run DDL",
        [sys.executable, "-m", "scripts.warehouse.run_sql"]
    ),

    (
        "Load CSV to Staging",
        [sys.executable, "-m", "scripts.ingestion.load_to_postgres"]
    ),

    (
        "Run Transformations",
        [sys.executable, "-m", "scripts.warehouse.run_transformations"]
    ),

    (
        "Create Views",
        [sys.executable, "-m", "scripts.warehouse.run_views"]
    )

]


def run_step(name, command):

    logger.info("=" * 70)
    logger.info(name)
    logger.info("=" * 70)

    start = time.time()

    result = subprocess.run(
        command,
        cwd=ROOT,
        capture_output=True,
        text=True
    )

    if result.returncode != 0:

        logger.error(result.stdout)
        logger.error(result.stderr)

        raise RuntimeError(f"{name} failed")

    logger.success(
        f"{name} completed ({round(time.time()-start,2)} sec)"
    )


def main():

    logger.info("")
    logger.info("=" * 70)
    logger.info("BANKING DATA WAREHOUSE REFRESH")
    logger.info("=" * 70)

    total = time.time()

    try:

        for name, command in STEPS:
            run_step(name, command)

    except Exception as e:

        logger.exception(e)
        sys.exit(1)

    logger.success("")
    logger.success("=" * 70)
    logger.success(
        f"REFRESH COMPLETED ({round(time.time()-total,2)} sec)"
    )
    logger.success("=" * 70)


if __name__ == "__main__":
    main()