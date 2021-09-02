import json

import boto3
from boto3.dynamodb.conditions import Key

def dbGetDay(tableName, startDate):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('TimeStamp').gt(startDate),
    )

    return response

def checkIfSorted(list):
    prev = 0
    for i in list:
        if i["TimeStamp"] < prev:
            print(i["TimeStamp"], "<", prev)
            return False

        else:
            print(i["TimeStamp"], ">", prev)
            prev = i ["TimeStamp"]

    return True
def sortList(list):
    checkIfSorted(list)
    sorted = []

    while len(list) != 0:
        item = getSmallestAndRemove(list)
        sorted.append(item)
        removeFromList(list, item)

    # print(sorted)
    # print(checkIfSorted(sorted))

    return sorted

def getSmallestAndRemove(list):
    smallest = 999999999999999999999999999
    smallestObject = {}

    # print("Finding the smallest")

    # Get the smallest item in the list
    for i in list:
        if smallest > int(i["TimeStamp"]):
            smallest = int(i["TimeStamp"])
            smallestObject = i

    return smallestObject

def removeFromList(list, item):
    for i in list:
        if int(i["TimeStamp"]) == int(item["TimeStamp"]):
            list.remove(i)

#     Remove the smallest item from the list

def lambda_handler(event, context):
    """This function will return a simple day stock along with the sentiment of a day """
    try:
        body = {}
        if "body" in event:
            body = json.loads(event["body"])

        else:
            body = event


        list = dbGetDay(body["company"]+"Daily", body["beginDate"])["Items"]

        sortItems = []

        returnItems = []
        # print(list)
        # sortItems.sort(key=lambda x:x["TimeStamp"])
        # print(sortItems)
        list = sortList(list)

        for i in list:
            returnItems.append({
                "TimeStamp" : int(i["TimeStamp"]),
                "Sentiment" : str(float(i["Sentiment"])),
                "Stock" : i["Stock"]
            })

        # print(sortItems)

        return {
            'statusCode': 200,
            'body': returnItems
        }
    except:
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid input")
        }


