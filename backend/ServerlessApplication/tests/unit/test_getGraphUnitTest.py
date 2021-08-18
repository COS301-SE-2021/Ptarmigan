import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getGraphSentiment import app


class TestGetSentiment(unittest.TestCase):

    def setUp(self):
        self.testDatabaseOutput = {"body" : {
            "BeginDate": 1623005418,
            "Interval": "Week",
            "CompanyName": "Tesla"
        }}

        # {
        #     "BeginDate": 1628554586,
        #     "Interval": "Day",
        #     "CompanyName": "Microsoft"
        # }

    @patch('ptarmigan.synthesize.getGraphSentiment.app.dbReturn')
    def test_if_sentiment_calculation_graph_returns_correct_data(self, mock_dbReturn):
        mock_dbReturn.return_value = {
                    "Items": [{
                        "Tweet_Id": 7,
                        "Sentiment": "POSITIVE",
                        "TimeStamp": 1623058451,
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
                    'Interval': 604800,
                    'Data':
                        [
                        {
                            'BeginDate': 1623005418,
                            'EndDate': 1623610218,
                            'IntervalData': 1.0
                        },
                        {
                            'BeginDate': 1623610218,
                            'EndDate': 1624215018,
                            'IntervalData': 1.0
                        },
                        {
                            'BeginDate': 1624215018,
                            'EndDate': 1624819818,
                            'IntervalData': 1.0
                        }]
                }
        }
        output = app.lambda_handler(self.testDatabaseOutput, "")
        print(output)
        self.assertEqual(200, 200)
