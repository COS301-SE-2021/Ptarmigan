import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getGraphSentiment import app


class TestGetSentiment(unittest.TestCase):

    def setUp(self):
        self.testDatabaseOutput = {
            "BeginDate": 1623005418000,
            "Interval": "Week",
            "CompanyName": "Tesla"
        }

    @patch('ptarmigan.synthesize.getGraphSentiment.app.dbReturn')
    def test_if_sentiment_calculation(self, mock_dbReturn):
        mock_dbReturn.return_value = {
                    "Items": [{
                        "Tweet_Id": 7,
                        "Sentiment": "POSITIVE",
                        "TimeStamp": 1623058451000,
                        "Weight": "583",
                        "Text": "You dumb",
                        "CompanyName": "Tesla", "lang": "ja"
                    }]
        }

        expected = {
            'statusCode': 200,
            'body':
                {
                    'CompanyName': 'Tesla',
                    'Interval': 604800000,
                    'Data':
                        [{
                            'BeginDate': 1623005418000,
                            'EndDate': 1623610218000,
                            'IntervalData': 1.0
                        },
                        {
                            'BeginDate': 1623610218000,
                            'EndDate': 1624215018000,
                            'IntervalData': 1.0
                         }]
                }
        }
        output = app.lambda_handler(self.testDatabaseOutput, "")
        self.assertEquals(expected, output)
