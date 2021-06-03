import json

# import requests
import boto3


def lambda_handler(event, context):
    'use strict'
    # const
    # AWS = require('aws-sdk');
    #
    # AWS.config.update({region: "eu-west-1"});
    #
    # exports.handler = async (event, context, callback) = > {
    #     const
    # ddb = new
    # AWS.DynamoDB({apiVersion: "2012-10-08"});
    # const
    # documentClient = new
    # AWS.DynamoDB.DocumentClient({region: "eu-west-1"});
    #
    # const
    # params = {
    #     TableName: "Twitter_Sentiment_Data",
    #     Item: {
    #         Tweet_Id: "202052523423",
    #         Text: "Bitcoin is Trash",
    #         lang: "en",
    #         Weight: "1"
    #
    #     }
    #
    #     Item: {
    #         Tweet_Id: "202052523423",
    #         Text: "Bitcoin is Trash",
    #         lang: "en",
    #         Weight: "1"
    #
    #     }
    # }
    # try{
    # const data = await documentClient.put(params).promise();
    # console.log(data);
    # }catch(err){
    # console.log(err);
    # }
    #
    # }

    # print(event)
    dbClient = boto3.resource("dynamodb")

    table = dbClient.Table('Twitter_Sentiment_Data')
    # table.put_item(
    #     Item={
    #         'Tweet_Id': "789456123",
    #         'Text': "Benjamin is not great",
    #         'lang': "en",
    #         'Weight': "1"
    #     })
    # print(res)
    # print(event)
    supportedLanguage = ["ar", "hi", "ko", "zh-TW", "ja", "zh", "de", "pt", "en", "it", "fr", "es"]

    for item in event:
        # print(event[item]["Text"])

        if event[item]["lang"] in supportedLanguage:
            # print("This shit is working")

            comprehend = boto3.client("comprehend")
            response = comprehend.detect_sentiment(Text=event[item]["Text"], LanguageCode=event[item]["lang"])
            event[item]["sentiment"] = response["Sentiment"]

            # itemObject = {
            #         'Tweet_Id': event[item]["Tweet Id"],
            #         'Text': event[item]["Text"],
            #         'lang': event[item]["lang"],
            #         'Weight': event[item]["Weight"]
            #     }

            # print(itemObject)

            table.put_item(
                Item={
                    'Tweet_Id': str(event[item]["Tweet Id"]),
                    'Text': event[item]["Text"],
                    'lang': event[item]["lang"],
                    'Weight': str(event[item]["Weight"]),
                    'Sentiment': event[item]["sentiment"]
                })

            # print(event[item])

        else:
            del event[item]

    return {
        'statusCode': 200,
        'body': event
    }
