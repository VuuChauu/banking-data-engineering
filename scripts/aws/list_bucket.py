import botocore

from config.aws import get_s3_client, S3_BUCKET_NAME
from config.logging import logger


def main():

    logger.info("=" * 70)
    logger.info("LIST OBJECTS IN S3 (raw/)")
    logger.info("=" * 70)

    client = get_s3_client()

    try:

        response = client.list_objects_v2(
            Bucket=S3_BUCKET_NAME,
            Prefix="raw/"
        )

        contents = response.get("Contents", [])

        if not contents:

            logger.warning("No objects found in raw/")
            return

        logger.success(f"Objects: {len(contents)}")

        for obj in contents:

            key = obj["Key"]

            # bỏ qua folder giả raw/
            if key.endswith("/"):
                continue

            logger.info(key)

    except botocore.exceptions.ClientError as e:

        logger.error(e)
        raise


if __name__ == "__main__":

    main()