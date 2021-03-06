import json
import boto3

def lambda_handler(event, context):
    try:
        delete = json.loads(event['body'])
        delete = delete['content']
    except:
        return {
            'statusCode': 400,
            'body': json.dumps('Bad Request - invalid JSON input')
        }
    filedata = getBucketList()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)
    replaceContent = filecontents['scrape-detail']

    delFlag = False

    for i in replaceContent:
        if i['content'] == delete:
            replaceContent.remove(i)
            delFlag = True
            break

    filecontents['scrape-detail'] = replaceContent
    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))


    if delFlag == True:
        flag = uploadBucketList(uploadByteStream)
        if flag:
            return {
                'statusCode': 200,
                'body': json.dumps('Item Deleted successfully and Content file has been updated')
            }
        else:
            return {
                'statusCode': 500,
                'body': json.dumps('Error updating Content file')
            }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps('Item not found.')
        }

def getBucketList():
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    #try read file from bucket
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
    return filedata

def uploadBucketList(uploadByteStream):
    s3client = boto3.client('s3')

    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'

    try:
        s3client.put_object(
            Bucket=bucketname,
            Key=file_to_read,
            Body=uploadByteStream)
        return True
    except:
        return False
