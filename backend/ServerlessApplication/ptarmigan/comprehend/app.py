import json
import os

import boto3

def batchSentiment(items):
    print(len(items))

    newItems = []
    languages = []
    doneItems = []

    for j in items:
        if items[j]['lang'] not in languages:
            languages.append(items[j]['lang'])

    print("languages: ", languages)

    for j in languages:
        print(j)
        for i in items:
            if items[i]["lang"] == j:
                newItems.append(items[i])
                print("asdf")

            if len(newItems) == 25:
                print("Len is above 25")
                getSentimentBatch(newItems)

        if len(newItems):
            getSentimentBatch(newItems, j)


def getSentimentBatch(batchArray, lang):
    print("Getting sentiment")
    comprehend = boto3.client("comprehend")
    textList = []
    for i in batchArray:
        print(i)
        textList.append(i["Text"])


    request =  {
        "LanguageCode": lang,
        "TextList": textList
    }

    print("Request content: ", request)

    response = comprehend.batch_detect_sentiment(
        TextList=[
            json.dumps(textList)
        ],
        LanguageCode='en'
    )

    print("RES", response)





def lambda_twitterComprehend(event, context):

    batchSentiment(event)

    # dbClient = boto3.resource("dynamodb")
    #
    # tableName = os.environ["TABLE_NAME"]
    #
    # table = dbClient.Table(tableName)
    #
    # print("TableName",tableName)
    #
    # comprehend = boto3.client("comprehend")
    #
    # print(event)
    #
    # putItem = []
    #
    # for item in event:
    #     response = comprehend.detect_sentiment(Text=event[item]["Text"], LanguageCode=event[item]["lang"])
    #     event[item]["sentiment"] = response["Sentiment"]
    #
    #     newItem = {
    #         'PutRequest': {
    #             'Item': {
    #                 'Tweet_Id': int(event[item]["Tweet Id"]),
    #                 'Text': event[item]["Text"],
    #                 'lang': event[item]["lang"],
    #                 'Weight': str(event[item]["Weight"]),
    #                 'Sentiment': event[item]["sentiment"],
    #                 'TimeStamp': event[item]["date"],
    #                 'CompanyName': event[item]["Company"]
    #             }
    #         }
    #     }
    #     putItem.append(newItem)
    #
    # print("plasing items", json.dumps(putItem))
    #
    # dbClient.batch_write_item(
    #     RequestItems = {
    #         tableName : putItem
    #     }
    # )
    #
    return {
            "statusCode": 200,
            "body": "This task was successfull"
            }


