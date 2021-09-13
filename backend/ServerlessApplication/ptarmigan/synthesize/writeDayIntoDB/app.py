import boto3
import time
from boto3.dynamodb.conditions import Key
import requests
import json
from datetime import datetime
import yfinance as yf


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

def getStockPrice(date,requestResults,ticker):
    #get date from timestamp into format "2021-08-24"
    formatDate = datetime.fromtimestamp(date)
    formatDate = formatDate.strftime("%Y-%m-%d")

    #check if there was a return if not curr exchange api
    if not requestResults['Time Series (Daily)']:
        requestResults = requestResults['Time Series (Digital Currency Daily)']
        try:
            requestResults = requestResults[formatDate]
        except:
            return("No exchange rate data for this date")
        requestResults = requestResults['4b. close (USD)']
    else:
        #if did return move into item time series
        requestResults = requestResults['Time Series (Daily)']
        #try get the date
        try:
            requestResults = requestResults[formatDate]
        except:
            return ("No stock data for this date yet")
        #get close of the date
        requestResults = requestResults['4. close']
    return requestResults

def getStockList(ticker):
    # https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo example return of api used below
    requestUrl = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={ticker}&apikey=VDLMI3ZNV3LSSLDZ"

    requestReturn = requests.get(requestUrl)
    requestResults = json.loads(requestReturn.text)

    if not requestResults['Time Series (Daily)']:
        # pull crypto symblo from ticker
        # crypto = ticker[2:5] # this should be in format X:BTCUSD - pulling the BTC
    # https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=BTC&market=USD&apikey=VDLMI3ZNV3LSSLDZ example return
        requestUrlCrypto = f"https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol={ticker}&market=USD&apikey=VDLMI3ZNV3LSSLDZ"
        requestReturnCrypto = requests.get(requestUrlCrypto)
        requestResults = json.loads(requestReturnCrypto.text)

    return requestResults

def getStockPriceOnAGivenDay(unixTimeStamp, tickerSymbol):

    date = datetime.fromtimestamp(
        unixTimeStamp
    )

    day = date.weekday()
    if day == 5 or day == 6:
        unixTimeStamp = unixTimeStamp-((day-4)*86400)

    dt = datetime.fromtimestamp(
        unixTimeStamp
    ).strftime('%Y-%m-%d')

    endDate = datetime.fromtimestamp(
        unixTimeStamp+86400
    ).strftime('%Y-%m-%d')
    print(dt)
    try:
        # print(dt)
        # requestUrlCrypto = f"https://api.polygon.io/v1/open-close/{tickerSymbol}/{dt}?adjusted=true&apiKey=4RTTEtcaiXt4pdaVkrjbfcQDygvKbiqp"
        # requestReturnCrypto = requests.get(requestUrlCrypto)
        # requestResults = json.loads(requestReturnCrypto.text)
        # print(requestResults)

        requestResults = yf.download(tickerSymbol, start=endDate, end=endDate)

        try:
            print(requestResults["Close"][0])
            return int(requestResults["Close"][0])
        except:
            return "Error occured"

    except:
        print("Unable to get Data")
        raise Exception("Unable to get Data, The day might not be available")
        return "error"

def checkIfTableExist(companyName):
    tableName = companyName
    dynamodbClient = boto3.client('dynamodb')
    try:
        response = dynamodbClient.create_table(
            AttributeDefinitions=[
                {
                    'AttributeName': 'TimeStamp',
                    'AttributeType': 'N',
                }
            ],
            KeySchema=[
                {
                    'AttributeName': 'TimeStamp',
                    'KeyType': 'HASH',
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5,
            },
            TableName=(tableName + "Daily")
        )
        return False

    except dynamodbClient.exceptions.ResourceInUseException:
        print("The Table Already exists")
        return True

def catchUp(len, companyName, ticker):
    currentTime = int(time.time())

    timeFromMidnight = currentTime % 86400

    currentTime = currentTime - timeFromMidnight
    currentTime = currentTime - (86400)

    # sentiment = getAllFromDate(currentTime-86400, currentTime, companyName)

    updatedTime = currentTime

    # ticker = getTicker(companyName)
    # stockList = getStockPriceOnAGivenDay(updatedTime, ticker)
    # stockPrice = stockList["close"]
    # print(stockList)

    updatedTime = updatedTime
    for i in range(len):

        updatedTime = updatedTime - 86400
        sentiment = getAllFromDate(updatedTime - 86400, updatedTime, companyName)
        # stock = getStockPrice(updatedTime, stockList, ticker)
        stockPrice = getStockPriceOnAGivenDay(updatedTime, ticker)

        if stockPrice == "You've exceeded the maximum requests per minute, please wait or upgrade your subscription to continue. https://polygon.io/pricing":
            print("Exeeding max usage")
            time.sleep(60)
            stockPrice = getStockPriceOnAGivenDay(updatedTime, ticker)


        res = writeIntoDb(updatedTime, companyName, stockPrice, sentiment)
        print(res)
        print("Number: ", i)
# def getTicker(company):
#     requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={company} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
#     requestReturn = requests.get(requestUrl)
#     requestReturn = json.loads(requestReturn.text)
#     requestResults = requestReturn['results']
#     if requestResults == None:
#         requestUrlCrypto = f"https://api.polygon.io/v3/reference/tickers?market=crypto&search={company} Dollar&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
#         requestReturnCrypto = requests.get(requestUrlCrypto)
#         requestReturnCrypto = json.loads(requestReturnCrypto.text)
#         requestResults = requestReturnCrypto['results']
#     return (requestResults[0]['ticker'])

def oneItem(companyName, ticker):
    currentTime = int(time.time())

    timeFromMidnight = currentTime % 86400

    currentTime = currentTime - timeFromMidnight
    currentTime = currentTime

    # sentiment = getAllFromDate(currentTime-86400, currentTime, companyName)

    updatedTime = currentTime
    updatedTime = updatedTime - 86400
    sentiment = getAllFromDate(updatedTime - 86400, currentTime, companyName)
    # stock = getStockPrice(updatedTime, stockList, ticker)
    stockPrice = getStockPriceOnAGivenDay(updatedTime, ticker)
    if stockPrice == "You've exceeded the maximum requests per minute, please wait or upgrade your subscription to continue. https://polygon.io/pricing":
        print("Exeeding max usage")
        time.sleep(60)
        stockPrice = getStockPriceOnAGivenDay(updatedTime, ticker)

    res = writeIntoDb(updatedTime, companyName, stockPrice, sentiment)
    print(res)

def lambda_handler(event, context):
    # getAllFromDate(int(time.time())-86400, int(time.time()), "Tesla")
    companyName = ""
    ticker = ""

    try:
        body = {}
        if "body" in event:
            body = json.loads(event["body"])
        else:
            body = event

        companyName = body["companyName"]
        ticker = body["ticker"]

    except:
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid input")
        }

    table = checkIfTableExist(companyName)

    print(table)

    if not table:
        catchUp(10, companyName, ticker)
        print("The table did not exist")

    else:
        insert = oneItem(companyName, ticker)
        print("The table did exist and one item was entered into the db")

    return {
        'statusCode': 200,
        'body': json.dumps("Success!")
    }

if __name__ == '__main__':
    body = {
        "companyName": "Tesla",
        "ticker": "TSLA"
    }
    print(lambda_handler(body, ""))


