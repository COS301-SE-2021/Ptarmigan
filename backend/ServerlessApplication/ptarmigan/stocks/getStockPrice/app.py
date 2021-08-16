import json
import requests
import boto3


def lambda_handler(event, context):
    contentList = getList()
    SymbolList = getTickerSymbols(contentList)
    priceList = getPriceList(SymbolList)

    priceDict = {contentList[i]: priceList[i] for i in range(len(contentList))}

    return writeToBucket(priceDict)

def getList():
    #get list from s3 Bucket
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'
    try:
        fileobj = s3client.get_object(
            Bucket=bucketname,
            Key=file_to_read
        )
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("Cannot find file within bucket")
        }
    filedata = fileobj['Body'].read()

    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    listContents = filecontents['scrape-detail']
    # print(listContents[0]['content'])
    i = 0
    for item in listContents:
        listContents[i] = item['content']
        i += 1

    return (listContents)


def getPriceList(list):
    listPrices = []
    # Make api request to get price based on ticker symbols
    for stuff in list:
        requestUrl = f"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={stuff}&apikey=VDLMI3ZNV3LSSLDZ"
        requestReturn = requests.get(requestUrl)
        requestResults = json.loads(requestReturn.text)
        # Make request to crypo api if error returns from stock api
        if ([*requestResults.keys()])[0] == "Error Message":
            #pull crypto symblo from ticker
            crypto = stuff[2:5]
            # add appropriate field to list
            requestUrlCrypto = f"https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency={crypto}&to_currency=USD&apikey=VDLMI3ZNV3LSSLDZ"
            requestReturnCrypto = requests.get(requestUrlCrypto)
            requestResultsCrypto = json.loads(requestReturnCrypto.text)
            listPrices.append((requestResultsCrypto['Realtime Currency Exchange Rate'])['5. Exchange Rate'])
        else:
            #add appropriate field to list
            requestResults = requestResults['Time Series (Daily)']
            key1 = ([*requestResults.keys()])[0]
            listPrices.append((requestResults[key1])['4. close'])

    return (listPrices)

def getTickerSymbols(list):
    tickerSymbolList = []
    # should probably change this functions api since its pepega
    # Make api request to get ticker symbol based on search query
    for stuff in list:
        #api requerst to sock api to get ticker
        requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={stuff} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
        requestReturn = requests.get(requestUrl)
        requestReturn = json.loads(requestReturn.text)
        requestResults = requestReturn['results']
        # Make request to crypo api if error returns from stock api
        if requestResults == None:

            requestUrlCrypto = f"https://api.polygon.io/v3/reference/tickers?market=crypto&search={stuff} Dollar&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
            requestReturnCrypto = requests.get(requestUrlCrypto)
            requestReturnCrypto = json.loads(requestReturnCrypto.text)
            requestResultsCrypto = requestReturnCrypto['results']
            tickerSymbolList.append(requestResultsCrypto[0]['ticker'])
        else:
            # add appropriate field to list
            tickerSymbolList.append(requestResults[0]['ticker'])
    return (tickerSymbolList)