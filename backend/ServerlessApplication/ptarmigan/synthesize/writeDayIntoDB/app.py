import boto3
import time
from boto3.dynamodb.conditions import Key
import requests
import json
from datetime import datetime


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

def getStockPrice(date,ticker):
    formatDate = datetime.fromtimestamp(date)
    formatDate = formatDate.strftime("%Y-%m-%d")
    requestUrl = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={ticker}&apikey=VDLMI3ZNV3LSSLDZ"
    requestReturn = requests.get(requestUrl)
    requestResults = json.loads(requestReturn.text)
    if not requestResults['Time Series (Daily)']:
        # pull crypto symblo from ticker
        crypto = ticker[2:5]
        # https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo example return of api used below
        requestUrlCrypto = f"https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency={crypto}&to_currency=USD&apikey=VDLMI3ZNV3LSSLDZ"
        requestReturnCrypto = requests.get(requestUrlCrypto)
        requestResultsCrypto = json.loads(requestReturnCrypto.text)
        requestResults = (requestResultsCrypto['Realtime Currency Exchange Rate'])['5. Exchange Rate']
    else:
        requestResults = requestResults['Time Series (Daily)']
        try:
            requestResults = requestResults[formatDate]
        except:
            return ("No stock data for this date yet")
        requestResults = requestResults['4. close']
    return requestResults


def getTicker(company):
    requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={company} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
    requestReturn = requests.get(requestUrl)
    requestReturn = json.loads(requestReturn.text)
    requestResults = requestReturn['results']
    if requestResults == None:
        requestUrlCrypto = f"https://api.polygon.io/v3/reference/tickers?market=crypto&search={company} Dollar&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
        requestReturnCrypto = requests.get(requestUrlCrypto)
        requestReturnCrypto = json.loads(requestReturnCrypto.text)
        requestResults = requestReturnCrypto['results']
    return (requestResults[0]['ticker'])

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
        ticker = getTicker(companyName)
        stock = getStockPrice(updatedTime,ticker)
        writeIntoDb(updatedTime, companyName, 706.5, sentiment)

    # return (writeIntoDb(currentTime, "Tesla", 706.5, sentiment))["ResponseMetadata"]
