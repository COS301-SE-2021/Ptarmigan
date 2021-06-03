import json
import boto3

def lambda_handler(event, context):
    dbClient = boto3.resource("dynamodb")

    table = dbClient.Table('Twitter_Sentiment_Data')

    supportedLanguage = ["ar", "hi", "ko", "zh-TW", "ja", "zh", "de", "pt", "en", "it", "fr", "es"]

    for item in event:

        if event[item]["lang"] in supportedLanguage:
            comprehend = boto3.client("comprehend")
            response = comprehend.detect_sentiment(Text=event[item]["Text"], LanguageCode=event[item]["lang"])
            event[item]["sentiment"] = response["Sentiment"]

            table.put_item(
                Item={
                    'Tweet_Id': str(event[item]["Tweet Id"]),
                    'Text': event[item]["Text"],
                    'lang': event[item]["lang"],
                    'Weight': str(event[item]["Weight"]),
                    'Sentiment': event[item]["sentiment"]
                })

        else:
            del event[item]

    return {
        'statusCode': 200,
        'body': event
    }
