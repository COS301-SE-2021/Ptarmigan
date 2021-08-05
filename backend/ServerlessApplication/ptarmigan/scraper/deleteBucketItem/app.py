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

    replaceContent = filecontents['scrape-detail']

    for i in replaceContent:
        if i['content'] == toDelete:
            replaceContent.remove(i)
            delFlag = True
            break

    filecontents['scrape-detail'] = replaceContent

    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))



    if delFlag == True:
        try:
            s3client.put_object(
                Bucket=bucketname,
                Key=file_to_read,
                Body=uploadByteStream)
        except:
            return {
                'statusCode': 500,
                'body': json.dumps('Error updating Content file')
            }

        return {
            'statusCode': 200,
            'body': json.dumps('Item Deleted successfully and Content file has been updated')
        }
    else:
        return {
            'statusCode': 400,
            'body': json.dumps('Item not found.')
        }