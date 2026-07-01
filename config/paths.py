from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[1]

DATA_DIR = ROOT_DIR / "data"

RAW_DATA_DIR = DATA_DIR / "raw"

PROCESSED_DATA_DIR = DATA_DIR / "processed"

DATABASE_DIR = ROOT_DIR / "database"

DDL_DIR = DATABASE_DIR / "ddl"

DML_DIR = DATABASE_DIR / "dml"

TRANSFORMATION_DIR = DATABASE_DIR / "transformations"

VIEW_DIR = DATABASE_DIR / "views"

SEED_DIR = DATABASE_DIR / "seed"

LOG_DIR = ROOT_DIR / "logs"