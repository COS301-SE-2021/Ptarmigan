import datetime
import json
import boto3

def lambda_handler(event, context):
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    fileobj = s3client.get_object(
        Bucket=bucketname,
        Key=file_to_read
    )

    filedata = fileobj['Body'].read()
    contents = (filedata.decode('utf-8'))
    contents = json.loads(contents)

    updated = (filedata.decode('utf-8'))
    updated = json.loads(updated)

    updated['Scrape-until'] = datetime.datetime.now()

    uploadByteStream = bytes(json.dumps(updated).encode('UTF-8'))

    s3client.put_object(
        Bucket=bucketname,
        Key=file_to_read,
        Body=uploadByteStream)

    # TODO update time stamp and overwrite file
    return contents