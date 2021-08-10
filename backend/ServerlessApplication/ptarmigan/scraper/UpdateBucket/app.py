import json
import boto3
import database

def lambda_handler(event, context):

    # read context from passed json argument
    update = event['content']

    database.database(update)

    #connet to s3 and file the scrape conent file
    s3client = boto3.client('s3')
    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'
    fileobj = s3client.get_object(
        Bucket=bucketname,
        Key=file_to_read
    )

    # decode file into python dict
    filedata = fileobj['Body'].read()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    #append content onto the dict
    replaceContent = filecontents['scrape-detail']
    replaceLine = '{"content": "' + update + '"}'
    replaceLine = json.loads(replaceLine)
    replaceContent.append(replaceLine)

    filecontents['scrape-detail'] = replaceContent

    #encode python dict to bytes for upload
    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))

    #try upload return error is failed
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
    #else return success json
    return {
        'statusCode': 200,
        'body': json.dumps('Successfully Updated the Content to scrap.')
    }