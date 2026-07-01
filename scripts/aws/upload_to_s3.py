from pathlib import Path

from botocore.exceptions import ClientError

from config.aws import (
    get_s3_client,
    S3_BUCKET_NAME
)

from config.paths import RAW_DATA_DIR
from config.logging import logger


def upload_file(client, file_path: Path):

    # raw/customers.csv
    object_key = f"raw/{file_path.name}"

    logger.info(f"Uploading {object_key}")

    client.upload_file(
        str(file_path),
        S3_BUCKET_NAME,
        object_key
    )

    logger.success(f"{object_key} uploaded")


def main():

    logger.info("=" * 70)
    logger.info("UPLOAD CSV TO AWS S3")
    logger.info("=" * 70)

    client = get_s3_client()

    files = sorted(RAW_DATA_DIR.glob("*.csv"))

    if not files:

        logger.warning("No CSV files found")
        return

    uploaded = 0

    try:

        for file in files:

            upload_file(client, file)

            uploaded += 1

    except ClientError as e:

        logger.exception(e)
        raise

    logger.success("=" * 70)
    logger.success(f"Uploaded {uploaded} files")
    logger.success("=" * 70)


if __name__ == "__main__":
    main()