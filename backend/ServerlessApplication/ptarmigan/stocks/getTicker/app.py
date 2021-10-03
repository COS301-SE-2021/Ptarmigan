import json

import requests

def getStockPrice(input):
    url = "https://api.polygon.io/v3/reference/tickers?search={}&active=true&sort=ticker&order=asc&limit=10&apiKey=4RTTEtcaiXt4pdaVkrjbfcQDygvKbiqp".format(input)
    print(url)
    response = requests.get(url)
    return response

def lambda_handler(event, context):
    # getAllFromDate(int(time.time())-86400, int(time.time()), "Tesla")
    companyName = ""
    ticker = ""
    print("aksjdf")
    try:
        body = {}
        if "body" in event:
            body = json.loads(event["body"])
        else:
            body = event

        companyName = body["companyName"]

    except:
        return {
            'statusCode': 400,
            'body': json.dumps("Invalid input")
        }

    return {
        'statusCode': 200,
        'body': json.dumps(getStockPrice(companyName).json())
    }

# if __name__ == '__main__':
#     print("You know something")
#     print(getStockPrice("Tesla").json())


