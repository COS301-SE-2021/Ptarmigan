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

    return {
        'statusCode': 400,
        'body': json.dumps("Hello")
    }