import os

import boto3

from dotenv import load_dotenv

load_dotenv()


AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")

AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")

AWS_DEFAULT_REGION = os.getenv("AWS_DEFAULT_REGION")

S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")


def get_s3_client():

    return boto3.client(

        "s3",

        aws_access_key_id=AWS_ACCESS_KEY_ID,

        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,

        region_name=AWS_DEFAULT_REGION

    )