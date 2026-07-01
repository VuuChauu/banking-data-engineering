from botocore.exceptions import ClientError

from config.aws import get_s3_client, S3_BUCKET_NAME
from config.logging import logger


RAW_PREFIX = "raw/"
ARCHIVE_PREFIX = "archive/"


def archive_file(client, key: str):

    filename = key.split("/")[-1]
    new_key = f"{ARCHIVE_PREFIX}{filename}"

    # copy sang archive
    client.copy_object(
        Bucket=S3_BUCKET_NAME,
        CopySource={"Bucket": S3_BUCKET_NAME, "Key": key},
        Key=new_key
    )

    # xóa khỏi raw
    client.delete_object(
        Bucket=S3_BUCKET_NAME,
        Key=key
    )

    logger.success(f"Archived: {key} → {new_key}")


def main():

    logger.info("=" * 70)
    logger.info("ARCHIVE S3 RAW DATA")
    logger.info("=" * 70)

    client = get_s3_client()

    try:

        response = client.list_objects_v2(
            Bucket=S3_BUCKET_NAME,
            Prefix=RAW_PREFIX
        )

        objects = response.get("Contents", [])

        if not objects:

            logger.warning("No files in raw/")
            return

        archived = 0

        for obj in objects:

            key = obj["Key"]

            if key.endswith("/"):
                continue

            archive_file(client, key)
            archived += 1

        logger.success("=" * 70)
        logger.success(f"Archived {archived} files")
        logger.success("=" * 70)

    except ClientError as e:

        logger.exception(e)
        raise


if __name__ == "__main__":
    main()