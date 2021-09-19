import json
import requests
import boto3
import time


def lambda_handler(event, context):
    contentList = getList()
    # SymbolList = getTickerSymbols(contentList)
    priceList = getPriceList(contentList)

    priceDict = {contentList[i]['content']: priceList[i] for i in range(len(contentList))}
    # return writeToBucket(priceDict)


def getList():
    # get list from s3 Bucket
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

    # i = 0
    # for item in listContents:
    #     listContents[i] = item['content']
    #     i += 1
    return (listContents)


def getPriceList(list):
    listPrices = []
    apiCalls = 0
    # Make api request to get price based on ticker symbols
    for stuff in list:
        if apiCalls == 5:
            time.sleep(60)
            apiCalls = 0
        Ticker = stuff['Ticker']
        requestUrl = f"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={Ticker}&apikey=VDLMI3ZNV3LSSLDZ"
        requestReturn = requests.get(requestUrl)
        apiCalls += 1
        requestResults = json.loads(requestReturn.text)
        # Make request to crypo api if error returns from stock api
        if not requestResults['Global Quote']:
            # pull crypto symblo from ticker
            # add appropriate field to list
            requestUrlCrypto = f"https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency={Ticker}&to_currency=USD&apikey=VDLMI3ZNV3LSSLDZ"
            requestReturnCrypto = requests.get(requestUrlCrypto)
            apiCalls += 1
            requestResultsCrypto = json.loads(requestReturnCrypto.text)
            listPrices.append((requestResultsCrypto['Realtime Currency Exchange Rate'])['5. Exchange Rate'])
        else:
            # add appropriate field to list
            requestResults = requestResults['Global Quote']
            listPrices.append(requestResults['08. previous close'])

    return (listPrices)


# def getTickerSymbols(list):
#     tickerSymbolList = []
#     apiCalls = 0
#     # should probably change this functions api since its pepega
#     # Make api request to get ticker symbol based on search query
#     for stuff in list:
#         if apiCalls == 5:
#             time.sleep(60)
#             apiCalls = 0
#         # api requerst to sock api to get ticker
#         requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={stuff} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
#         requestReturn = requests.get(requestUrl)
#         apiCalls += 1
#         requestReturn = json.loads(requestReturn.text)
#         requestResults = requestReturn['results']
#         # Make request to crypo api if error returns from stock api
#         if requestResults == None:
#             requestUrlCrypto = f"https://api.polygon.io/v3/reference/tickers?market=crypto&search={stuff} Dollar&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
#             requestReturnCrypto = requests.get(requestUrlCrypto)
#             apiCalls += 1
#             requestReturnCrypto = json.loads(requestReturnCrypto.text)
#             requestResultsCrypto = requestReturnCrypto['results']
#             tickerSymbolList.append(requestResultsCrypto[0]['ticker'])
#         else:
#             # add appropriate field to list
#             tickerSymbolList.append(requestResults[0]['ticker'])
#     return (tickerSymbolList)


def writeToBucket(dict):
    s3client = boto3.client('s3')
    bucketname = 'stepfunctestbucket'
    file_to_read = 'priceList.json'

    # encode python dict to bytes for upload
    uploadByteStream = bytes(json.dumps(dict).encode('UTF-8'))

    # try upload return error is failed
    try:
        s3client.put_object(
            Bucket=bucketname,
            Key=file_to_read,
            Body=uploadByteStream)
    except:
        return {
            'statusCode': 500,
            'body': json.dumps('Error updating Content file')
        }
    # else return success json
    return {
        'statusCode': 200,
        'body': json.dumps('Successfully Updated Stock Price List')
    }