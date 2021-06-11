import json
from pprint import pprint
import boto3
from boto3 import dynamodb
from botocore.exceptions import ClientError

# import requests


def lambda_handler(event, context):
    table = dynamodb.Table('Movies')

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
            # "location": ip.text.replace("\n", "")
        }),
    }
