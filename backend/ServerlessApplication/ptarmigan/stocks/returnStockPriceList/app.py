import json
import boto3


def lambda_handler(event, context):

    filedata = returnListFromS3()
    filecontents = json.loads((filedata.decode('utf-8')))

    return {
        'statusCode': 200,
        'body': json.dumps(filecontents)
    }

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
        return filedata
    except:
        return {
            'statusCode': 404,
            'body': json.dumps('Bucket/item not found')
        }