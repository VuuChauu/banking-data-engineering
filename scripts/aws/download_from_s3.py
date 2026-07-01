from botocore.exceptions import ClientError

from config.aws import (
    get_s3_client,
    S3_BUCKET_NAME
)

from config.paths import RAW_DATA_DIR
from config.logging import logger


def download_file(client, object_key: str):

    # raw/customers.csv -> customers.csv
    filename = object_key.split("/")[-1]

    destination = RAW_DATA_DIR / filename

    logger.info(f"Downloading {filename}")

    client.download_file(
        S3_BUCKET_NAME,
        object_key,
        str(destination)
    )

    logger.success(f"{filename} downloaded")


def main():

    logger.info("=" * 70)
    logger.info("DOWNLOAD FILES FROM AWS S3")
    logger.info("=" * 70)

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    client = get_s3_client()

    try:

        response = client.list_objects_v2(
            Bucket=S3_BUCKET_NAME,
            Prefix="raw/"
        )

        if response.get("KeyCount", 0) == 0:

            logger.warning("No files found in raw/")
            return

        downloaded = 0

        for obj in response["Contents"]:

            object_key = obj["Key"]

            # bỏ qua nếu chỉ là folder raw/
            if object_key.endswith("/"):
                continue

            download_file(client, object_key)

            downloaded += 1

        logger.success("=" * 70)
        logger.success(f"Downloaded {downloaded} files")
        logger.success("=" * 70)

    except ClientError as e:

        logger.exception(e)
        raise


if __name__ == "__main__":
    main()