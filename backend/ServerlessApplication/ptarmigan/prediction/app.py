import json
import os
import io
import boto3
import datetime
import time
from boto3.dynamodb.conditions import Key
import yfinance as yf

ENDPOINT_NAME = "sagemaker-scikit-learn-2021-09-18-19-35-22-824"
runtime = boto3.client('runtime.sagemaker')

def lambda_handler(event, context):
    # get company name
    try:
        company = event['context']
    except:
        return {
        'statusCode': 400,
        'body': json.dumps("Invalid inputs")
    }
    dataArr = get_inputs(company)
    #print(dataArr)
    prediction = get_Prediction(dataArr)
    return {
        'statusCode': 200,
        'body': json.dumps(prediction)
    }

def getSentiment(companyName):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(companyName)
    
    beginDate = int(time.time())
    endDate = tstoday = datetime.datetime.combine(datetime.date.today(), datetime.datetime.min.time())
    endDate = int(endDate.timestamp())
    
    response = table.scan(FilterExpression=Key('Tweet_Id').gt(1)&Key('TimeStamp').between(endDate, beginDate))
    print(response["Items"])
    return calculateSentiment(response["Items"])

    def calculateSentiment(content):
        posSum = 0
    negSum = 0
    
    for element in content:
        weight = int(element["Weight"])
        if element["Sentiment"] == "POSITIVE":
            posSum = posSum + weight
        if element["Sentiment"] == "NEGATIVE":
            negSum = negSum + weight

    diff = ((posSum - negSum) /1000)

    return (diff)