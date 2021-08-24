import boto3
import time
from boto3.dynamodb.conditions import Key


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

def getAllFromDate(beginDate, endDate, companyName):
    dynamodb = boto3.resource('dynamodb')
    tableName = companyName
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('Tweet_Id').gt(1) & Key('TimeStamp').between(beginDate, endDate)
    )

    return calculateSentiment(response["Items"])

def writeIntoDb(date, ):
    print()


def lambda_handler(event, context):
    # getAllFromDate(int(time.time())-86400, int(time.time()), "Tesla")
    currentTime = int(time.time())

    timeFromMidnight = currentTime % 86400

    currentTime = currentTime - timeFromMidnight

    getAllFromDate(currentTime-86400, currentTime, "Tesla")
