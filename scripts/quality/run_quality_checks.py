import time

from config.logging import logger

from scripts.quality.check_row_counts import main as row_count_check
from scripts.quality.check_nulls import main as null_check
from scripts.quality.check_duplicates import main as duplicate_check


def main():

    start = time.time()

    logger.info("=" * 70)
    logger.info("DATA QUALITY REPORT")
    logger.info("=" * 70)

    row_ok = row_count_check()

    null_ok = null_check()

    duplicate_ok = duplicate_check()

    logger.info("=" * 70)

    if row_ok and null_ok and duplicate_ok:

        logger.success("ALL DATA QUALITY CHECKS PASSED")

    else:

        logger.error("DATA QUALITY CHECK FAILED")

    logger.success(
        f"Finished in {round(time.time()-start,2)} seconds"
    )

    logger.info("=" * 70)


if __name__ == "__main__":
    main()