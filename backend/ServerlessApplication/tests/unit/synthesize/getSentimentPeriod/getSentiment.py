import json
import pytest

from ptarmigan.synthesize.getSentimentPeriod import app

@pytest.fixture()

def fixture_event():
    return {
                "BeginDate" : 1623005418000,
                "EndDate": 1623065669000,
                "CompanyName": "Tesla"
            }


class TestgetSentimentPeriod:
    def test_get_sentiment_period(self, fixture_event):
        expected = 0.21702209641803874

        output = app.lambda_handler(fixture_event, "")

        assert expected == output["body"]