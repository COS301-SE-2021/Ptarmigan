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

    # Loop through the results and setting the highest one to high

    for i in response["Items"]:
        if int(i["Weight"]) > int(high["Weight"]):
            high = i





    print(response)

    return high


def lambda_handler(event, context):
    print("Starting")
    if "body" in event:
        data = json.loads(event["body"])

    else:
        data = event

        return {
            "statusCode": 200,
            "body": getMostPopularTweet(data["CompanyName"], data["BeginDate"], data["EndDate"]),
        }
