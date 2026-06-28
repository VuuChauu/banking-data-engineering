import sys

from pathlib import Path

from loguru import logger

LOG_PATH = Path("logs")

LOG_PATH.mkdir(exist_ok=True)

logger.remove()

logger.add(

    sys.stdout,

    level="INFO",

    format="{time:YYYY-MM-DD HH:mm:ss} | {level} | {message}"

)

logger.add(

    LOG_PATH / "pipeline.log",

    rotation="10 MB",

    retention="30 days",

    compression="zip",

    level="INFO"

)