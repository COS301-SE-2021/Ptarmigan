import json
import pytest
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getDailySentiment import app

@pytest.fixture()

def fixture_event():
    return {"body" : {
        "company": "Tesla",
        "beginDate": 1628899200
    }}

class TestGetDailySentiemnt(unittest.TestCase):
    @patch("ptarmigan.synthesize.getDailySentiment.app.dbGetDay")
    def test_get_daily_sentiment(self):
        testReturn = app.lambda_handler(fixture_event, "")
        print("some")

        expected = {
            "statusCode": 400,
            "body":
                {
                    [
                        {
                            "TimeStamp": "1629676800",
                            "Sentiment": "0.0",
                            "Stock": "706.5"
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


    def test_calculate_sentiment(self):
        input = [{'Tweet_Id': 7, 'Sentiment': 'POSITIVE', 'TimeStamp': 1623058451, 'Weight': '583', 'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7', 'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = 1

        assert app.calculateSentiment(input) == expected
