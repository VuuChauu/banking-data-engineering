import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()


def get_connection():

    host = os.getenv("POSTGRES_HOST")

    # Nếu chạy ngoài Docker thì dùng localhost
    if host == "postgres" and os.name == "nt":
        host = "localhost"

    return psycopg2.connect(
        host=host,
        port=os.getenv("POSTGRES_PORT"),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
    )