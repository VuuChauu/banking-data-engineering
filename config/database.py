import os

from dotenv import load_dotenv

load_dotenv()

POSTGRES_CONFIG = {

    "host": os.getenv("LOCAL_POSTGRES_HOST"),

    "port": os.getenv("POSTGRES_PORT"),

    "database": os.getenv("POSTGRES_DB"),

    "user": os.getenv("POSTGRES_USER"),

    "password": os.getenv("POSTGRES_PASSWORD")

}