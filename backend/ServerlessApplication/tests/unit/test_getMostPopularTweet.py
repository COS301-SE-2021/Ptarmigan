import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getMostPopularTweet import app


class GetMostPopularTweet(unittest.TestCase):

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
       print("Place your shit over here")
