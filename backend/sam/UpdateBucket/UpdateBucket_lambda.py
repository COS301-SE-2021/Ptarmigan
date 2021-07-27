import json
import boto3

def lambda_handler(event, context):
    # read file
    update = event['content']
    print(update)
    s3client = boto3.client('s3')
    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'
    fileobj = s3client.get_object(
        Bucket=bucketname,
        Key=file_to_read
    )
    # TODO write to file
    # TODO upload to bucket

    return()