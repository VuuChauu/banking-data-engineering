import os

from dotenv import load_dotenv

load_dotenv()

PROJECT_NAME = os.getenv("PROJECT_NAME")

ENV = os.getenv("ENV")

AWS_REGION = os.getenv("AWS_DEFAULT_REGION")

S3_BUCKET = os.getenv("S3_BUCKET_NAME")