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
    if totalVotes == 0:
        return 0
    return (runningSentiment / totalVotes)


def dbReturn(event):
    dynamodb = boto3.resource('dynamodb')
    tableName = event["CompanyName"]
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(event["BeginDate"], event["EndDate"])
    )

    return response


def lambda_handler(event, context):
    try:
        event = json.loads(event["body"])
        response = dbReturn(event)
        print(response)

        calculation = calculateSentiment(response["Items"])

        return {
            "statusCode": 200,
            "body": json.dumps(calculation)
        }

    except:
        return {
            "statusCode": 400,
            "body": json.dumps("Invalid Inputs")
        }

# //{
#   "BeginDate" : 1623005418000,
#   "Interval":  "Day",
#   "CompanyName": "Tesla"
# }


