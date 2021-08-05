import json
import boto3

def lambda_handler(event, context):
    toDelete = event['delete']

    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    fileobj = s3client.get_object(
        Bucket=bucketname,
        Key=file_to_read
    )

    filedata = fileobj['Body'].read()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    return {
        'statusCode': 200,
        'body': json.dumps('Item Deleted successfully and Content file has been updated')
    }