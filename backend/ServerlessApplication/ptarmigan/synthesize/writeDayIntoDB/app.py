import boto3
import time
from boto3.dynamodb.conditions import Key
import requests

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

def writeIntoDb(date, company, stock, sentiment):
    company = company+"Daily"


    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table(company)
    response = table.put_item(
        Item={
            "TimeStamp": date,
            "Sentiment": str(sentiment),
            "Stock": str(stock)
        }
    )
    return response

def getStockPrice(date,company):
    requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={company} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
    requestReturn = requests.get(requestUrl)

def lambda_handler(event, context):
    # getAllFromDate(int(time.time())-86400, int(time.time()), "Tesla")
    companyName = "Microsoft"

    # TODO: Implement with actual data current implementation is for testing purposes only.
    currentTime = int(time.time())

    timeFromMidnight = currentTime % 86400

    currentTime = currentTime - timeFromMidnight

    sentiment = getAllFromDate(currentTime-86400, currentTime, companyName)

    updatedTime = currentTime

    for i in range(10):
        updatedTime = updatedTime - 86400
        sentiment = getAllFromDate(updatedTime - 86400, updatedTime, companyName)
        writeIntoDb(updatedTime, companyName, 706.5, sentiment)

    # return (writeIntoDb(currentTime, "Tesla", 706.5, sentiment))["ResponseMetadata"]
