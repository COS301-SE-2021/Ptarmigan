import json
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
import os
import json

# import requests
def calculateSentiment(content):
    totalVotes = 0
    runningSentiment = 0
    for element in content:
        weight = int(element["Weight"])
        totalVotes = totalVotes + weight
        sentiment = 0
        if element["Sentiment"] == "NEUTRAL":
            sentiment = 0
        if element["Sentiment"] == "POSITIVE":
            sentiment = 1
        if element["Sentiment"] == "NEGATIVE":
            sentiment = -1

        runningSentiment = runningSentiment + (weight * sentiment)

    return (runningSentiment/totalVotes)

def dbReturn(event):
    dynamodb = boto3.resource('dynamodb')
    print("Something")
    tableName = os.environ["TABLE_NAME"]
    print(tableName)
    table = dynamodb.Table(os.environ["TABLE_NAME"])

    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(event["BeginDate"], event["EndDate"]) & Key(
            'CompanyName').eq(event["CompanyName"])
    )

    return response


def lambda_handler(event, context):
    try:
        response = dbReturn(event)
        print(response)

        calculation = calculateSentiment(response["Items"])

        return {
            "statusCode": 200,
            "body": calculation
        }

    except ValueError:
        print(ValueError)
        return {
            "statusCode": 400,
            "body": ValueError
        }




# //{
#   "BeginDate" : 1623005418000,
#   "Interval":  "Day",
#   "CompanyName": "Tesla"
# }


