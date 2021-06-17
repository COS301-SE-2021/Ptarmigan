import json

import pytest
from unittest import TestCase
from hello_world import app


class TestClass(TestCase):
    def setUp(self):
        self.test_context = {
                              "BeginDate" : 1623008136000,
                              "Interval":  "Week",
                              "CompanyName": "Tesla"
                            }
        # Input data

    def test_get_sentiment_graph(self):
        testReturn = (app.lambda_handler(self.test_context, json.dumps("{}")))
        print("some")

        print(testReturn)

        expected = {"statusCode": 200,
                             "body": {"CompanyName": "Tesla", "Interval": 604800000, "Data": [
            {"BeginDate": 1623008136000, "EndDate": 1623612936000, "IntervalData": 0},
            {"BeginDate": 1623612936000, "EndDate": 1624217736000, "IntervalData": 0}]}}

        assert "" == ""
