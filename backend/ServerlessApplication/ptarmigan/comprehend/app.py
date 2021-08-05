import json
import os

import boto3


def lambda_twitterComprehend(event, context):
    dbClient = boto3.resource("dynamodb")

    tableName = os.environ["TABLE_NAME"]

    table = dbClient.Table(tableName)

    print("TableName",tableName)

    comprehend = boto3.client("comprehend")

    print(event)

    putItem = []

    for item in event:
        response = comprehend.detect_sentiment(Text=event[item]["Text"], LanguageCode=event[item]["lang"])
        event[item]["sentiment"] = response["Sentiment"]

        newItem = {
            'PutRequest': {
                'Item': {
                    'Tweet_Id': int(event[item]["Tweet Id"]),
                    'Text': event[item]["Text"],
                    'lang': event[item]["lang"],
                    'Weight': str(event[item]["Weight"]),
                    'Sentiment': event[item]["sentiment"],
                    'TimeStamp': event[item]["date"],
                    'CompanyName': event[item]["Company"]
                }
            }
        }
        putItem.append(newItem)

    print("plasing items", json.dumps(putItem))

    dbClient.batch_write_item(
        RequestItems = {
            tableName : putItem
        }
    )

    return {
            "statusCode": 200,
            "body": "This task was successfull"
            }


