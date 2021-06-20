import json
from pprint import pprint
import boto3
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
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
    table = dynamodb.Table('Test')

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

    except:
        return {
            "statusCode": 400,
            "body": "Parameters not found in DB"
        }




# //{
#   "BeginDate" : 1623005418000,
#   "Interval":  "Day",
#   "CompanyName": "Tesla"
# }


