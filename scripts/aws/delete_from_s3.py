from botocore.exceptions import ClientError

from config.aws import get_s3_client, S3_BUCKET_NAME
from config.logging import logger


PREFIX = "raw/"

def delete_single_file(client, object_key: str):

    client.delete_object(
        Bucket=S3_BUCKET_NAME,
        Key=object_key
    )

    logger.success(f"Deleted: {object_key}")


def delete_all_files(client):

    response = client.list_objects_v2(
        Bucket=S3_BUCKET_NAME,
        Prefix=PREFIX
    )

    objects = response.get("Contents", [])

    if not objects:

        logger.warning("No objects to delete in raw/")
        return

    for obj in objects:

        key = obj["Key"]

        # skip folder placeholder
        if key.endswith("/"):
            continue

        delete_single_file(client, key)

    logger.success("All raw/ files deleted.")


def main():

    logger.info("=" * 70)
    logger.info("DELETE FILES FROM AWS S3 (raw/)")
    logger.info("=" * 70)

    client = get_s3_client()

    print("\nChoose an option:")
    print("1. Delete one file in raw/")
    print("2. Delete all files in raw/")

    choice = input("\nYour choice (1/2): ").strip()

    try:

        if choice == "1":

            filename = input("Enter filename (e.g. customers.csv): ").strip()

            object_key = f"{PREFIX}{filename}"

            delete_single_file(client, object_key)

        elif choice == "2":

            confirm = input("Delete ALL files in raw/? (yes/no): ").strip().lower()

            if confirm == "yes":

                delete_all_files(client)

            else:

                logger.info("Cancelled.")

        else:

            logger.error("Invalid choice.")

    except ClientError as e:

        logger.exception(e)
        raise


if __name__ == "__main__":
    main()