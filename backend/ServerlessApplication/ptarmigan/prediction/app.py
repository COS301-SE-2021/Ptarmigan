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
def encode_inputs(data): #[increse,monday,POSITIVE]
    encodedArrayOutput = []
    #one hot encode the change
    if data[0] == "Increase":
        encodedArrayOutput.extend([0,1,0])
    elif data[0] == "Decrease":
        encodedArrayOutput.extend([1,0,0])
    else: #else neutral
        encodedArrayOutput.extend([0,0,1])
        
    #encode the day
    if data[1] == "Monday":
        encodedArrayOutput.extend([0,1,0,0,0,0,0])
    elif data[1] == "Tuesday":
        encodedArrayOutput.extend([0,0,0,0,0,1,0])
    elif data[1] == "Wednesday":
        encodedArrayOutput.extend([0,0,0,0,0,0,1])
    elif data[1] == "Thursday":
        encodedArrayOutput.extend([0,0,0,0,1,0,0])
    elif data[1] == "Friday":
        encodedArrayOutput.extend([1,0,0,0,0,0,0])
    elif data[1] == "Saturday":
        encodedArrayOutput.extend([0,0,1,0,0,0,0])
    else: # "Sunday":
        encodedArrayOutput.extend([0,0,0,1,0,0,0])
    
    #encode the sentiment
    if data[2] == "NEGATIVE":
        encodedArrayOutput.extend([1,0])
    else: #positive
        encodedArrayOutput.extend([0,1])
        
    return encodedArrayOutput
    
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