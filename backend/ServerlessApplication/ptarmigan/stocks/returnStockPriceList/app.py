import json
import boto3


def lambda_handler(event, context):
    return returnListFromS3()


def returnListFromS3():
    try:
        s3client = boto3.client('s3')
        bucketname = 'stepfunctestbucket'
        file_to_read = 'priceList.json'
        fileobj = s3client.get_object(
            Bucket=bucketname,
            Key=file_to_read
        )

        filedata = fileobj['Body'].read()
        filecontents = (filedata.decode('utf-8'))
        return {
            'statusCode': 200,
            'body': json.loads(filecontents)
        }
    except:
        return {
            'statusCode': 404,
            'body': json.dumps('Bucket/item not found')
        }