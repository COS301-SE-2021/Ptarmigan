import json
import boto3


def lambda_twitterComprehend(event, context):
    dbClient = boto3.resource("dynamodb")

    table = dbClient.Table('Test')

    comprehend = boto3.client("comprehend")

    print(event)

    for item in event:
        response = comprehend.detect_sentiment(Text=event[item]["Text"], LanguageCode=event[item]["lang"])
        event[item]["sentiment"] = response["Sentiment"]

        table.put_item(
            Item={
                'Tweet_Id': int(event[item]["Tweet Id"]),
                'Text': event[item]["Text"],
                'lang': event[item]["lang"],
                'Weight': str(event[item]["Weight"]),
                'Sentiment': event[item]["sentiment"],
                'TimeStamp': event[item]["date"],
                'CompanyName': event[item]["CompanyName"]
            })

        # TODO: write code...
        # TODO: write code...

    # response = comprehend.detect_sentiment(Text=event["Text"], LanguageCode=event["lang"])
    # event["sentiment"] = response["Sentiment"]

    # table.put_item(
    # Item={
    #     'Tweet_Id': str(event["Tweet Id"]),
    #     'Text': event["Text"],
    #     'lang': event["lang"],
    #     'Weight': str(event["Weight"]),
    #     'Sentiment': event["sentiment"]
    #     })

    # returnObject["currentIndex"] = returnObject["currentIndex"] + 1

    # if returnObject["currentIndex"] == returnObject["eventLength"]:
    #     returnObject["done"] = "true"

    # TODO: write code...

    return {
            "statusCode": 200,
            "body": "This task was successfull"
            }

# import json
# import boto3

# def lambda_twitterComprehend(event, context):
#     print(event["content"])
#     returnObject = event
#     event = event["content"][str(event["currentIndex"])]
#     dbClient = boto3.resource("dynamodb")

#     table = dbClient.Table('Twitter_Sentiment_Data')

#     comprehend = boto3.client("comprehend")

#     response = comprehend.detect_sentiment(Text=event["Text"], LanguageCode=event["lang"])
#     event["sentiment"] = response["Sentiment"]

#     # table.put_item(
#     # Item={
#     #     'Tweet_Id': str(event["Tweet Id"]),
#     #     'Text': event["Text"],
#     #     'lang': event["lang"],
#     #     'Weight': str(event["Weight"]),
#     #     'Sentiment': event["sentiment"]
#     #     })

#     returnObject["currentIndex"] = returnObject["currentIndex"] + 1

#     if returnObject["currentIndex"] == returnObject["eventLength"]:
#         returnObject["done"] = "true"

#         # TODO: write code...

#     return returnObject
