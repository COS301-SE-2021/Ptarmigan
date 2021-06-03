import json

# import requests
import boto3

def lambda_handler(event, context):
    print(event)
    event ={
    "0": {
        "Tweet Id": 1349868896208244739,
        "Text": "Tesla trascura le donne",
        "lang": "it",
        "Weight": 1
    }
}
    print("Some stuff happend")
    # print(event)
    supportedLanguage = ["ar", "hi", "ko", "zh-TW", "ja", "zh", "de", "pt", "en", "it", "fr", "es"]

    for item in event:
        # print(event[item]["Text"])

        if event[item]["lang"] in supportedLanguage:
            # print("This shit is working")

            comprehend = boto3.client("comprehend")
            response = comprehend.detect_sentiment(Text =event[item]["Text"], LanguageCode = event[item]["lang"])
            event[item]["sentement"] = response["Sentiment"]

            # print(event[item])

        else:
            del event[item]


    return {
        'statusCode': 200,
        'body': event
    }
