import json
import unittest

from ptarmigan.synthesize.getSentimentPeriod import app
from moto import mock_dynamodb2
import boto3

class TestGetSentiment(unittest.TestCase):

    def setup(self):
        self.testDatabaseOutput = '{ "BeginDate" : "1623005418000",'
        '"EndDate": "1623065669000", '
        ' "CompanyName": "Tesla" }'

    @mock_dynamodb2
    def test_LambdaFunc(self):
        boto3.setup_default_session()
        dynomodbTest = boto3.client("dynamodb")
        dynomodbTest.create_table(

        )
        dynomodbTest.put_item(

        )
        output = app.lambda_handler(self.testDatabaseOutput, "")
        self.assertEquals(0.21702209641803874,output)
