import json
import os
import io
import boto3
import datetime
import time
from boto3.dynamodb.conditions import Key
import yfinance as yf

ENDPOINT_NAME = "sagemaker-scikit-learn-2021-09-19-13-07-12-463"
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

def get_inputs(companyName,ticker):
    # get all the inputs
    #get the stocks for today + yesterday
    endDate = datetime.date.today()
    startDate = endDate - datetime.timedelta(days=5)
    endDatestr = endDate.strftime("%Y-%m-%d")
    startDatestr = startDate.strftime("%Y-%m-%d")
    
    requestResults = yf.download(ticker, start=startDatestr, end=endDatestr)  
    
    if (endDate.weekday() == 6 or endDate.weekday() == 0): #if monday/friday get fridays stock do there should be no change
        todayStock = (requestResults["Close"].iloc[-1])
        yesterdayStock = (requestResults["Close"].iloc[-1])
    elif (endDate.weekday() == 5): #if saturday get the change between friday open and close
        todayStock = (requestResults["Close"].iloc[-1])
        yesterdayStock = (requestResults["Open"].iloc[-1])
    else: # if any other day get the last 2 days avalible 
        todayStock = (requestResults["Close"].iloc[-1])
        yesterdayStock = (requestResults["Close"].iloc[-2])

    #assign todays price
    close = todayStock
    #get the %change from yesterday to today
    changePercent = ((todayStock-yesterdayStock)/yesterdayStock)*100 
    #determine is the change was positive or negative
    if changePercent > 0.01:
        change = "Increase"
    elif changePercent < -0.01:
        change =  "Decrease"
    else:
        change =  "Neutral"
        
        
    #get sentiment of all tweets from today
    
    #total their weighs and get difference betweens positive and negative
    sentimentValue = getSentiment(companyName)
    #if positive = POSITIVE if neg = NEGATIVE
    if sentimentValue > 0:
        sentiment = "POSITIVE"
    elif sentimentValue < 0:
        sentiment = "NEGATIVE"
    else:
        sentiment = "NEUTRAL"
    #get the day of the week
    day = datetime.datetime.today().strftime('%A')
    
    
    categoricalArr = [change,day,sentiment]
    numericalArr = [close,changePercent,sentimentValue]
    encodedArr = encode_inputs(categoricalArr)
    outputArr = encodedArr + numericalArr
    return outputArr

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

def get_Prediction(inputArr):
    print(json.dumps(inputArr))
    response = runtime.invoke_endpoint(EndpointName=ENDPOINT_NAME,Body=json.dumps([inputArr]))
    result = json.loads(response['Body'].read().decode())
    if result[0] == 0:
        predictionReturn = "Decrease"
    elif result[0] == 1:
        predictionReturn = "Increase"
    elif result[0] == 2:
        predictionReturn = "Neutral"
    else:
        predictionReturn = "Unknown"
    return predictionReturn

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

def get_Ticker(companyName):
     # get list from s3 Bucket
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'
    try:
        fileobj = s3client.get_object(
            Bucket=bucketname,
            Key=file_to_read
        )
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("Cannot find file within bucket")
        }
    filedata = fileobj['Body'].read()

    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    listContents = filecontents['scrape-detail']

    for item in listContents:
        if item['content'] == companyName:
            return item['Ticker']
    return["no item found"]