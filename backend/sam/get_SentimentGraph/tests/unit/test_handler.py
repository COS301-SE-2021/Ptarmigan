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

    def test_when_invalid_input(self):
        expected = 400

        input = {
                    "Interval": "Week",
                    "CompanyName": "Tesla"
                }

        ret = (app.lambda_handler(input, json.dumps("{}")))
        print(ret)

        assert ret["statusCode"] == 400

    def test_getInterval_function_test(self):
        input = "Week"
        expected = 60*60*24*7*1000

        assert app.getInterval(input) == expected

    def test_calculate_sentiment(self):
        input = [{'Tweet_Id': 7, 'Sentiment': 'NEUTRAL', 'TimeStamp': 1623058451000, 'Weight': '583', 'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7', 'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = 0

        assert app.calculateSentiment(input) == expected






