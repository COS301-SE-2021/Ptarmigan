import json
import boto3

class database:
    """This class will create a table if it exists, if not it will allow the user to add and remove from the db table"""
    def __init__(self, companyName):
        print("Company: !!!!!!!!", companyName)
        self.tableName = companyName
        self.dynamodbClient = boto3.client('dynamodb')
        try:
            response = self.dynamodbClient.create_table(
                AttributeDefinitions=[
                    {
                        'AttributeName': 'Tweet_Id',
                        'AttributeType': 'N',
                    },
                    {
                        'AttributeName': 'TimeStamp',
                        'AttributeType': 'N',
                    }
                ],
                KeySchema=[
                    {
                        'AttributeName': 'Tweet_Id',
                        'KeyType': 'HASH',
                    },
                    {
                        'AttributeName': 'TimeStamp',
                        'KeyType': 'RANGE',
                    }
                ],
                ProvisionedThroughput={
                    'ReadCapacityUnits': 5,
                    'WriteCapacityUnits': 5,
                },
                TableName=self.tableName
            )
            #print("Table Did not exist")
        except self.dynamodbClient.exceptions.ResourceInUseException:
            #print("The DB Already exists")
            # do something here as you require

        #print("Something")


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

def LambdaInvokeStocks():
    lambdaClient = boto3.client('lambda')
    response = lambdaClient.invoke(
        FunctionName='arn:aws:lambda:eu-west-1:878292117449:function:getStockPrice',
        InvocationType='Event',
        LogType='None'
    )

def lambda_handler(event, context):
    # read context from passed json argument
    try:
        update = json.loads(event['body'])
        update = update['content']
    except:
        return {
            'statusCode': 400,
            'body': json.dumps('Bad Request - invalid JSON input')
        }

    try:
        database.database(update)
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("Somthing Went wrong with database table creation")
        }

    # connet to s3 and file the scrape conent file
    # decode file into python dict
    filedata = getBucketList()
    filecontents = (filedata.decode('utf-8'))
    filecontents = json.loads(filecontents)

    #append content onto the dict
    replaceContent = filecontents['scrape-detail']
    #check if item exists - if it does return
    for i in replaceContent:
        if i['content'] == update:
            return {
                'statusCode': 200,
                'body': json.dumps('Item is already in the file')
            }
    replaceLine = '{"content": "' + update + '"}'
    replaceLine = json.loads(replaceLine)
    replaceContent.append(replaceLine)

    filecontents['scrape-detail'] = replaceContent

    # #encode python dict to bytes for upload
    uploadByteStream = bytes(json.dumps(filecontents).encode('UTF-8'))

    # try upload return error is failed
    flag = uploadBucketList(uploadByteStream)
    if flag:
        return {
            'statusCode': 200,
            'body': json.dumps('Successfully Updated the Content to scrape.')
        }
    else:                           # else return success json
        return {
            'statusCode': 500,
            'body': json.dumps('Error updating Content file')
        }


