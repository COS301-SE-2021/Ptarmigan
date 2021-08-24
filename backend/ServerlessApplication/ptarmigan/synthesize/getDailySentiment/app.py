import json

import boto3
from boto3.dynamodb.conditions import Key

def dbGetDay(tableName, startDate):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('TimeStamp').gt(startDate)
    )

    return response


def lambda_handler(event, context):
    """This function will return a simple day stock along with the sentiment of a day """
    body = {}
    if "body" in event:
        body = json.loads(event["body"])

    else:
        body = event


    list = dbGetDay(event["company"]+"Daily", event["beginDate"])["Items"]

    returnItems = []

    for i in list:
        returnItems.append({
            "TimeStamp" : i["TimeStamp"],
            "Sentiment" : float(i["Sentiment"]),
            "Stock" : float(i["Stock"])
        })

    print(returnItems)

    return {
        'statusCode': 200,
        'body': returnItems
    }


