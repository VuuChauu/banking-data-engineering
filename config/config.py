from pathlib import Path
from dotenv import load_dotenv

import os

# Load .env
load_dotenv()

####################################################
# ROOT DIRECTORY
####################################################

ROOT_DIR = Path(__file__).resolve().parent.parent

####################################################
# DATA DIRECTORY
####################################################

DATA_DIR = ROOT_DIR / "data"

RAW_DATA_DIR = DATA_DIR / "raw"

BRONZE_DATA_DIR = DATA_DIR / "bronze"

SILVER_DATA_DIR = DATA_DIR / "silver"

GOLD_DATA_DIR = DATA_DIR / "gold"

ARCHIVE_DATA_DIR = DATA_DIR / "archive"

####################################################
# LOG DIRECTORY
####################################################

LOG_DIR = ROOT_DIR / "logs"

####################################################
# NOTEBOOK
####################################################

NOTEBOOK_DIR = ROOT_DIR / "notebooks"

####################################################
# ENVIRONMENT
####################################################

ENVIRONMENT = os.getenv("ENV", "development")

PROJECT_NAME = os.getenv("PROJECT_NAME")