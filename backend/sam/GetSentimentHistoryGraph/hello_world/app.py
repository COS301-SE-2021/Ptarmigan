import json
import time
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


def getInterval(interval):
    if interval == "Second":
        return 1000
    if interval == "Minute":
        return 60*1000
    if interval == "Hour":
        return 60*60*1000
    if interval == "Day":
        return 60*60*24*1000
    if interval == "Week":
        return 60*60*24*7*1000
    if interval == "Month":
        return 60 * 60 * 24 * 30 * 1000
    if interval == "Year":
        return 60 * 60 * 24 * 365 * 1000





def lambda_handler(event, context):

    print(event)

    interval = getInterval(event["Interval"])
    beginDate = event["BeginDate"]
    endDate = beginDate + interval

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Test')

    print(int(time.time()*1000))

    returnObject = {
        "CompanyName": "Tesla",
        "Interval": interval,
        "Data": {

        }
    }
    returnArray = []

    while beginDate < int(time.time()*1000):
        try:
            response = table.scan(
                FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(beginDate,endDate) & Key('CompanyName').eq(event["CompanyName"])
            )

            # returnArray.append(calculateSentiment(response["Items"]))
            returnObject["Data"].update({
                "BeginDate": beginDate,
                "EndDate": endDate,
                "IntervalData": calculateSentiment(response["Items"])
            })


        except:
            print("asdfa")
            returnObject["Data"].update({
                "BeginDate": beginDate,
                "EndDate": endDate,
                "IntervalData": 0
            })

        beginDate = endDate
        endDate = endDate + interval

    return {
        "statusCode": 200,
        "body": returnArray
    }


    # dynamodb = boto3.resource('dynamodb')
    # table = dynamodb.Table('Test')
    # try:
    #     response = table.scan(
    #         FilterExpression = Key('Tweet_Id').gt(1) & Key('TimeStamp').between(event["BeginDate"], event["EndDate"])& Key('CompanyName').eq(event["CompanyName"])
    #     )

        # calculation = calculateSentiment(response["Items"])
    #
    #     return {
    #         "statusCode": 200,
    #         "body": calculation
    #     }
    #
    # except:
    #     return {
    #         "statusCode": 400,
    #         "body": "Parameters not found in DB"
    #     }




