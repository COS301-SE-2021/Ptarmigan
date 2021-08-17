import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app

# {'ResultList': [{'Index': 0, 'Sentiment': 'POSITIVE', 'SentimentScore': {'Positive': 0.9300897717475891, 'Negative': 0.003447077004238963, 'Neutral': 0.06625871360301971, 'Mixed': 0.0002044376451522112}}], 'ErrorList': [], 'ResponseMetadata': {'RequestId': '1077e584-0291-4f63-a039-157499daf61a', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '1077e584-0291-4f63-a039-157499daf61a', 'content-type': 'application/x-amz-json-1.1', 'content-length': '206', 'date': 'Tue, 17 Aug 2021 17:50:16 GMT'}, 'RetryAttempts': 0}}
@pytest.fixture()
def fixture_event():
    return {
                "0": {
                    "Text": "We can't underestimate the next few days for #Tesla. Plaid is the next generation, Plaid is a new level of technology, Plaid is when the entire world looks at EVs &amp; realises they are our undeniable future. Plaid is the answer to clean transport, the final nail in the ICE coffin. https://t.co/kRgIU7Dmya",
                    "lang": "en",
                    "date": 1623065669,
                    "Weight": 177,
                    "Tweet Id": "0",
                    "CompanyName": "Tesla"
                }
            }

class TestComprehend(unittest.TestCase):
    @patch('ptarmigan.comprehend.app.getSentimentBatch')
    def test_batchSentiment(self, mock):
        mock.return_value = {'ResultList': [{'Index': 0, 'Sentiment': 'POSITIVE', 'SentimentScore': {'Positive': 0.9300897717475891, 'Negative': 0.003447077004238963, 'Neutral': 0.06625871360301971, 'Mixed': 0.0002044376451522112}}], 'ErrorList': [], 'ResponseMetadata': {'RequestId': '1077e584-0291-4f63-a039-157499daf61a', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '1077e584-0291-4f63-a039-157499daf61a', 'content-type': 'application/x-amz-json-1.1', 'content-length': '206', 'date': 'Tue, 17 Aug 2021 17:50:16 GMT'}, 'RetryAttempts': 0}}
        input = {
                "0": {
                    "Text": "We can't underestimate the next few days for #Tesla. Plaid is the next generation, Plaid is a new level of technology, Plaid is when the entire world looks at EVs &amp; realises they are our undeniable future. Plaid is the answer to clean transport, the final nail in the ICE coffin. https://t.co/kRgIU7Dmya",
                    "lang": "en",
                    "date": 1623065669,
                    "Weight": 177,
                    "Tweet Id": "0",
                    "CompanyName": "Tesla"
                }
            }
        actual = app.batchSentiment(input)

        expected = [{'Index': 0, 'Sentiment': 'POSITIVE', 'SentimentScore': {'Positive': 0.9300897717475891, 'Negative': 0.003447077004238963, 'Neutral': 0.06625871360301971, 'Mixed': 0.0002044376451522112}}]

        self.assertEquals(actual, expected)



    def test_lambda_handler(self, fixture_event):
        returnItem = app.lambda_twitterComprehend(fixture_event, "")
        # data = json.loads(returnItem["body"])

        assert returnItem["statusCode"] == 200