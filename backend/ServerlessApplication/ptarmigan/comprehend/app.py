import json
import boto3

def lambda_twitterComprehend(event, context):
    print(event["content"])
    returnObject = event
    event = event["content"][str(event["currentIndex"])]
    dbClient = boto3.resource("dynamodb")

    table = dbClient.Table('Twitter_Sentiment_Data')

    comprehend = boto3.client("comprehend")

    response = comprehend.detect_sentiment(Text=event["Text"], LanguageCode=event["lang"])
    event["sentiment"] = response["Sentiment"]

    table.put_item(
    Item={
        'Tweet_Id': str(event["Tweet Id"]),
        'Text': event["Text"],
        'lang': event["lang"],
        'Weight': str(event["Weight"]),
        'Sentiment': event["sentiment"]
        })

    returnObject["currentIndex"] = returnObject["currentIndex"] + 1

    if returnObject["currentIndex"] == returnObject["eventLength"]:
        returnObject["done"] = "true"

        # TODO: write code...

    return returnObject

