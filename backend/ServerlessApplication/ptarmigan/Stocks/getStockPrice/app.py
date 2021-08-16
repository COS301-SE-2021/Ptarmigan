import json
import requests

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

    return (listContents)