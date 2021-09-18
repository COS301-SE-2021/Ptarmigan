import json
import pytest
import unittest
from unittest.mock import patch

from ptarmigan.synthesize.writeDayIntoDB import app



@pytest.fixture()
#
def fixture_event():
    return {"body" : {
        "company": "Tesla",
        "beginDate": 1628899200
    }}

# class TestGetDailySentiemnt(unittest.TestCase):

class TestGetDailySentiemnt(unittest.TestCase):
    # @ patch("ptarmigan.synthesize.getDailySentiment.app.dbGetDay")
    def test_if_sentiment_calculation_is_correct_positive(self):

        input = [{'Tweet_Id': 7, 'Sentiment': 'POSITIVE', 'TimeStamp': 1623058451, 'Weight': '583',
                  'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7',
                  'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = 1

        assert app.calculateSentiment(input) == expected

    def test_if_sentiment_calculation_is_correct_neutral(self):

        input = [{'Tweet_Id': 7, 'Sentiment': 'NEUTRAL', 'TimeStamp': 1623058451, 'Weight': '583',
                  'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7',
                  'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = 0

        assert app.calculateSentiment(input) == expected

    def test_if_sentiment_calculation_is_correct_negative(self):

        input = [{'Tweet_Id': 7, 'Sentiment': 'NEGATIVE', 'TimeStamp': 1623058451, 'Weight': '583',
                  'Text': '1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody ♬ https://t.co/Z9KL6NGdG7',
                  'CompanyName': 'Tesla', 'lang': 'ja'}]

        expected = -1

        assert app.calculateSentiment(input) == expected

    def test_if_getStockPriceOnAGivenDay_stock(self):
        expected = 759
        actual = app.getStockPriceOnAGivenDay(1631836800, "TSLA")

        assert expected == actual

    def test_if_oneItem_works(self):



