import boto3
from boto3.dynamodb.conditions import Key

def dbGetDay(tableName, startDate):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tableName)

    response = table.scan(
        FilterExpression=Key('TimeStamp').gt(startDate)
    )

    return response


def lambda_handler(event, context):
    """This function will return a simple day stock along with the sentiment of a day """

    list = dbGetDay("TeslaDaily",1628899200)["Items"]

    returnItems = []

    for i in list:
        ret


