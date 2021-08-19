import json
import boto3
import time

def lambda_handler(event, context):
    filedata = getBucketList()
    contents = (filedata.decode('utf-8'))
    contents = json.loads(contents)

    updated = (filedata.decode('utf-8'))
    updated = json.loads(updated)
    updated['Scrape-until'] = time.time()

    uploadByteStream = bytes(json.dumps(updated).encode('UTF-8'))

    flag = uploadBucketList(uploadByteStream)
    if flag:
        return contents
    else:
        return {
            'statusCode': 500,
            'body': json.dumps('Error updating Content file')
        }


def getBucketList():
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    # try read file from bucket
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