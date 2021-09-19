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