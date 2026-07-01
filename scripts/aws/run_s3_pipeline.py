import subprocess
import sys
import time

from config.logging import logger

PYTHON = sys.executable


STEPS = [

    (
        "Upload CSV to S3",
        [PYTHON, "-m", "scripts.aws.upload_to_s3"]
    ),

    (
        "List Bucket (raw/)",
        [PYTHON, "-m", "scripts.aws.list_bucket"]
    ),

    (
        "Download CSV from S3",
        [PYTHON, "-m", "scripts.aws.download_from_s3"]
    ),
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
    logger.info("AWS S3 PIPELINE STARTED")
    logger.info("=" * 70)

    for name, cmd in STEPS:

        run_step(name, cmd)

    logger.success("=" * 70)
    logger.success(
        f"S3 Pipeline Finished ({round(time.time() - start, 2)} sec)"
    )
    logger.success("=" * 70)


if __name__ == "__main__":
    main()