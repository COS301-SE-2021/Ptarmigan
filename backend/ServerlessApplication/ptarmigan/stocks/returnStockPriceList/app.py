import json
import boto3

def lambda_handler(event, context):
    return {
        'statusCode': 404,
        'body': json.dumps('Bucket/item not found')
    }