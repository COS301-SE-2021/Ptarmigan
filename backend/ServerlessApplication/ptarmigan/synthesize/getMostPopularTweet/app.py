import json

import boto3
from boto3.dynamodb.conditions import Key


def dbCall(companyName, beginDate, endDate):
    print("Scanning the db table")
    dynamodb = boto3.resource('dynamodb')
    tableName = companyName
    table = dynamodb.Table(companyName)

    # Getting all of the tweets in a given timeframe from the DB
    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(beginDate, endDate)
    )
    print(response)
    return response


def getMostPopularTweet(companyName, beginDate, endDate):
    print("Getting Time")

    response = dbCall(companyName, beginDate, endDate)
    # Loop through the results and setting the highest one to high

    high = response["Items"][0]

    for i in response["Items"]:
        if int(i["Weight"]) > int(high["Weight"]):
            high = i
    print(response)

    return high


def lambda_handler(event, context):
    print("Starting")
    print("This is where we start")
    try:
        print("HERE ONE")
        if "body" in event:
            data = json.loads(event["body"])

        else:
            print("HERE TWO")
            data = event

        print(data)
        returnData = getMostPopularTweet(data["CompanyName"], data["BeginDate"], data["EndDate"])

        ret = {
            "Tweet_Id": str(returnData["Tweet_Id"]),
            "Weight": str(returnData["Weight"])
        }
        return {
            "statusCode": 200,
            "body": json.dumps(ret)
        }
    except:
        return {
            "statusCode": 400,
            "body": json.dumps("Invalid Inputs")
        }

    # return{
    #         "statusCode": 400,
    #         "body": json.dumps("That did not)
    #     }






