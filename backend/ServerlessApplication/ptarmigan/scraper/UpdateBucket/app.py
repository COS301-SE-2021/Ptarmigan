import json

import boto3
from ptarmigan.scraper.UpdateBucket import database
# Creating functions to to replace s3 calls
def getBucketList():
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    #try read file from bucket
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
    return filedata

def uploadBucketList(uploadByteStream):
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    try:
        s3client.put_object(
            Bucket=bucketname,
            Key=file_to_read,
            Body=uploadByteStream)
        return True
    except:
        return False

def LambdaInvokeStocks():
    lambdaClient = boto3.client('lambda')
    response = lambdaClient.invoke(
        FunctionName='arn:aws:lambda:eu-west-1:878292117449:function:getStockPrice',
        InvocationType='Event',
        LogType='None'
    )

def lambda_handler(event, context):
    # read context from passed json argument
    try:
        update = json.loads(event['body'])
        update = update['content']
    except:
        return {
            "isBase64Encoded": False,
            'statusCode': 400,
            "headers": {
                "Content-Type": "application/json"
            },
            'body': json.dumps('Bad Request - invalid JSON input')
        }

    try:
        database.database(update)
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("Somthing Went wrong with database table creation")
        }

    # connet to s3 and file the scrape conent file
    # decode file into python dict
    filedata = getBucketList()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    #append content onto the dict
    replaceContent = filecontents['scrape-detail']
    #check if item exists - if it does return
    for i in replaceContent:
        if i['content'] == update:
            return {
                'statusCode': 400,
                'body': json.dumps('Item is already in the file')
            }
    replaceLine = '{"content": "' + update + '"}'
    replaceLine = json.loads(replaceLine)
    replaceContent.append(replaceLine)

    filecontents['scrape-detail'] = replaceContent

    # #encode python dict to bytes for upload
    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))

    # try upload return error is failed
    flag = uploadBucketList(uploadByteStream)
    if flag:
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully Updated the Content to scrape.')
        }
    else:                           # else return success json
        return {
            'statusCode': 500,
            'body': json.dumps('Error updating Content file')
        }
