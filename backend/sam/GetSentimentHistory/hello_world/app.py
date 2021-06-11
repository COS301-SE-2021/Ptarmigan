import json
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
import json

# import requests


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Test')
    response = table.scan(
        FilterExpression = Key('Tweet_Id').gt(50) & Key('TimeStamp').gt(1))

    print(response["Items"])

    return {
        "statusCode": 200,
        "body":response

    }