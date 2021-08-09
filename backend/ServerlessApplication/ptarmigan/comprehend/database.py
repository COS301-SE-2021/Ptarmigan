import boto3

class database:
    """This class will create a table if it exists, if not it will allow the user to add and remove from the db table"""
    def __init__(self, companyName):
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
                TableName=companyName
            )
        except self.dynamodbClient.exceptions.ResourceInUseException:
            print("The DB Already exists")
            # do something here as you require



