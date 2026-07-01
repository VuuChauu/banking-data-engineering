import subprocess
import sys
import time

from config.logging import logger


PYTHON = sys.executable


STEPS = [

    # =========================
    # 1. AWS S3
    # =========================
    ("Upload to S3", [PYTHON, "-m", "scripts.aws.upload_to_s3"]),
    ("Download from S3", [PYTHON, "-m", "scripts.aws.download_from_s3"]),

    # =========================
    # 2. Load to Postgres
    # =========================
    ("Load to PostgreSQL", [PYTHON, "-m", "scripts.ingestion.load_to_postgres"]),

    # =========================
    # 3. DWH Transform
    # =========================
    ("Run Transformations", [PYTHON, "-m", "scripts.warehouse.run_transformations"]),
    ("Create Views", [PYTHON, "-m", "scripts.warehouse.run_views"]),

    # =========================
    # 4. Data Quality
    # =========================
    ("Data Quality Checks", [PYTHON, "-m", "scripts.quality.run_quality_checks"]),

    # =========================
    # 5. Archive S3
    # =========================
    ("Archive S3", [PYTHON, "-m", "scripts.aws.archive_to_s3"]),
]


def run_step(name, command):

    logger.info("=" * 70)
    logger.info(name)
    logger.info("=" * 70)

    result = subprocess.run(
        command,
        capture_output=True,
        text=True
    )

    print(result.stdout)

    if result.returncode != 0:

        print(result.stderr)
        raise RuntimeError(f"{name} failed")

    logger.success(f"{name} completed")


def main():

    start = time.time()

    logger.info("=" * 70)
    logger.info("FULL DATA PIPELINE STARTED")
    logger.info("=" * 70)

    for name, cmd in STEPS:

        run_step(name, cmd)

    logger.success("=" * 70)
    logger.success(
        f"PIPELINE COMPLETED ({round(time.time() - start, 2)} sec)"
    )
    logger.success("=" * 70)


if __name__ == "__main__":
    main()