import json
import pytest
import unittest
from ptarmigan.synthesize.getGraphSentiment import app

@pytest.fixture()

def fixture_event():
    return {"body" : {
            "BeginDate": 1623005418000,
            "Interval": "Week",
            "CompanyName": "Tesla"
        }}

class TestGetGraphSentiment(unittest.TestCase):
    def test_get_sentiment_graph(self):
        testReturn = app.lambda_handler(fixture_event, "")
        print("some")

        expected = {
                        "statusCode": 400,
                        "body":
                            {
                                "CompanyName": "Tesla", "Interval": 604800000, "Data": [
                                    {
                                        "BeginDate": 1623008136000, "EndDate": 1623612936000, "IntervalData": 0
                                    },
                                    {
                                        "BeginDate": 1623612936000, "EndDate": 1624217736000, "IntervalData": 0
                                    }
                                ]
                        }
                    }

        assert expected["statusCode"] == testReturn["statusCode"]

    def test_when_invalid_input(self):
        expected = 400

        input = {
                    "Interval": "Week",
                    "CompanyName": "Tesla"
                }

        ret = (app.lambda_handler(input, json.dumps("{}")))
        print(ret)

        assert ret["statusCode"] == 400

    def test_getInterval_week(self):
        input = "Week"
        expected = 60*60*24*7

        assert app.getInterval(input) == expected

    def test_getInterval_day(self):
        input = "Day"
        expected = 60 * 60 * 24

        assert app.getInterval(input) == expected

    def test_getInterval_second(self):
        input = "Second"
        expected = 1

        assert app.getInterval(input) == expected

    def test_getInterval_hour(self):
        input = "Hour"
        expected = 60*60

        assert app.getInterval(input) == expected

    def test_getInterval_minute(self):
        input = "Minute"
        expected = 60

        assert app.getInterval(input) == expected

    def test_getInterval_month(self):
        input = "Month"
        expected = 60*60*24*30

        assert app.getInterval(input) == expected

    def test_calculate_sentiment(self):
        input = [{'Tweet_Id': 7, 'Sentiment': 'POSITIVE', 'TimeStamp': 1623058451, 'Weight': '583', 'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7', 'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = 1

        assert app.calculateSentiment(input) == expected
