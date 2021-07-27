import json
import boto3

def lambda_handler(event, context):
    # read file
    update = event['content']
    print(update)
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
    #filecontents['scrape-detail'] = {'content' : 'yes'}

    print(type(replaceContent))

    # TODO upload to bucket

    return {
        'statusCode': 200,
        'body': json.dumps('nice')
    }