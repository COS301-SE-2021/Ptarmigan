"""This function should get a tweet that matches the tweet ID"""
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    print("Getting by Id")

    companyName = "Tesla"
    tweetId = 1424887326887628803

    db = boto3.resource("dynamodb")

    table = db.Table(companyName)

    try:
        response = table.get_item(Key={"Tweet_Id": tweetId})
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        print(response['Item'])



