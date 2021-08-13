import json
import pytest
from moto import mock_dynamodb2

from ptarmigan.synthesize.getSentimentPeriod import app



@pytest.fixture()

def fixture_event():
    return {
                "BeginDate": 1623005418,
                "EndDate": 1623065669,
                "CompanyName": "Tesla"
            }


class TestgetSentimentPeriod:
    def test_get_sentiment_period(self, fixture_event):
        expected = 0.21702209641803874

        output = app.lambda_handler(fixture_event, "")

        assert expected == output["body"]