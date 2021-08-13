import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getSentimentPeriod import app


class TestGetSentiment(unittest.TestCase):

    def setUp(self):
        self.testDatabaseOutput = {
            "BeginDate" : 1623005418000,
            "EndDate": 1623065669000,
            "CompanyName": "Tesla"
        }

    @patch('ptarmigan.synthesize.getSentimentPeriod.app.dbReturn')
    def test_if_sentiment_calculation_is_correct(self, mock_dbReturn):
        mock_dbReturn.return_value = {
                    "Items": [{
                        "Tweet_Id": 7,
                        "Sentiment": "POSITIVE",
                        "TimeStamp": 1623058451000,
                        "Weight": 583,
                        "Text": "You dumb",
                        "CompanyName": "Tesla",
                        "lang": "ja"
                    }]
        }

        expected = {
            "statusCode": 200,
            "body": 1
        }
        output = app.lambda_handler(json.dumps(self.testDatabaseOutput), "")
        self.assertEquals(expected, output)