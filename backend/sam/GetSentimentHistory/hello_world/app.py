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





def lambda_handler(event, context):

    print(event)
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Test')
    response = table.scan(
        FilterExpression = Key('Tweet_Id').gt(1) & Key('TimeStamp').between(1, 1623060456000))

    # print(response["Items"])


    calculation = calculateSentiment(response["Items"])

    return {
        "statusCode": 200,
        "body": response

    }