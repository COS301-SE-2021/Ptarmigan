import json

import boto3
from boto3.dynamodb.conditions import Key


def getMostPopularTweet(companyName, beginDate, endDate):
    print("Getting Time")

    dynamodb = boto3.resource('dynamodb')
    tableName = companyName
    table = dynamodb.Table(tableName)
    high = {
        "TweetId" : 0,
        "Weight" : 0
    }

    # Getting all of the tweets in a given timeframe from the DB

    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(beginDate, endDate) & Key('CompanyName').eq(
            companyName)
    )

    #

    for i in response:
        print(i)



    print(response)

    return response


def lambda_handler(event, context):
    print("Starting")
    print(event)
    if "body" in event:
        data = json.loads(event["body"])

    else:
        data = event

    return getMostPopularTweet(data["CompanyName"], data["BeginDate"], data["EndDate"])
