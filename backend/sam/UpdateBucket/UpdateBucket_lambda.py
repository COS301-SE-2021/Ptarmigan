import json
import boto3

def lambda_handler(event, context):
    # read file
    update = event['content']
    s3client = boto3.client('s3')
    bucketname = 'stepfunctestbucket'
    file_to_read = 'scrapeContent.json'
    fileobj = s3client.get_object(
        Bucket=bucketname,
        Key=file_to_read
    )

    # write to file
    filedata = fileobj['Body'].read()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    replaceContent = filecontents['scrape-detail']
    replaceLine = '{"content": "' + update + '"}'
    replaceLine = json.loads(replaceLine)
    replaceContent.append(replaceLine)

    filecontents['scrape-detail'] = replaceContent

    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))

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
        'body': json.dumps('Successfully Updated the Content to scrap.')
    }