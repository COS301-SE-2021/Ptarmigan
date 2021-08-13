import json
import os
import time
import boto3
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

    return (runningSentiment / totalVotes)


#
def getInterval(interval):
    if interval == "Second":
        return 1000
    if interval == "Minute":
        return 60 * 1000
    if interval == "Hour":
        return 60 * 60 * 1000
    if interval == "Day":
        return 60 * 60 * 24 * 1000
    if interval == "Week":
        return 60 * 60 * 24 * 7 * 1000
    if interval == "Month":
        return 60 * 60 * 24 * 30 * 1000
    if interval == "Year":
        return 60 * 60 * 24 * 365 * 1000


def dbReturn(event, beginDate, endDate):
    dynamodb = boto3.resource('dynamodb')
    tableName = event["CompanyName"]
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(beginDate, endDate) & Key('CompanyName').eq(
            event["CompanyName"])
    )

    return response


def lambda_handler(event, context):
    print(event)

    try:
        event = json.loads(event["body"])
        cName = event["CompanyName"]
        print(cName)
        interval = event["Interval"]
        ev = event["BeginDate"]

        print(cName, " ", interval, " ", ev)

    except:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "Error": "Invalid Inputs"
            })
        }

    interval = getInterval(event["Interval"])
    beginDate = event["BeginDate"]
    endDate = beginDate + interval

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Test')

    returnObject = {
        "CompanyName": "Tesla",
        "Interval": interval,
        "Data": []
    }

    while beginDate < int(time.time()):
        try:
            response = dbReturn(event, beginDate, endDate)

            # print(response)

            returnObject["Data"].append({
                "BeginDate": beginDate,
                "EndDate": endDate,
                "IntervalData": calculateSentiment(response["Items"])
            })


        except:
            returnObject["Data"].append({
                "BeginDate": beginDate,
                "EndDate": endDate,
                "IntervalData": 0
            })

        beginDate = endDate
        endDate = endDate + interval

    return {
        "statusCode": 200,
        "body": json.dumps(returnObject),
        "isBase64Encoded": False
    }

