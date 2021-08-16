import json
import boto3


def lambda_handler(event, context):
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

    return {
        'statusCode': 200,
        'body': json.dumps(filecontents)
    }