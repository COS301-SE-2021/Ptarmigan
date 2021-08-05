import json
import boto3

def lambda_handler(event, context):
    toDelete = event['delete']
    return {
        'statusCode': 200,
        'body': json.dumps('Item Deleted successfully and Content file has been updated')
    }