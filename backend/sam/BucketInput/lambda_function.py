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
    print(updated['Scrape-until'])

    # TODO update time stamp and overwrite file
    return contents