import json
from pprint import pprint
import boto3
from botocore.exceptions import ClientError

# import requests


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Twitter_Sentiment_Data')
    response = table.get_item(Key = {
        "Tweet_Id" : "999"

    })

    print(response)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world",
            # "location": ip.text.replace("\n", "")
        }),
    }
