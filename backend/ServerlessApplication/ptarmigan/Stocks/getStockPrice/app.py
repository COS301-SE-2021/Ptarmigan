import json
import requests
import boto3


def lambda_handler(event, context):
    contentList = getList()
    SymbolList = getTickerSymbols(contentList)
    priceList = getPriceList(SymbolList)

    priceDict = {contentList[i]: priceList[i] for i in range(len(contentList))}

    return {
        'statusCode': 200,
        'body': json.dumps(priceDict)
    }

def getList():

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

def getTickerSymbols():
    tickerSymbolList = []
    # should probably change this functions api since its pepega
    for stuff in list:
        requestUrl = f"https://api.polygon.io/v3/reference/tickers?market=stocks&search={stuff} &active=true&sort=ticker&order=asc&limit=10&apiKey=PNqoXU3luX7smsggLGPacHd8JnKZkDMV"
        requestReturn = requests.get(requestUrl)
        requestReturn = json.loads(requestReturn.text)
        requestResults = requestReturn['results']

        tickerSymbolList.append(requestResults[0]['ticker'])
    return (tickerSymbolList)