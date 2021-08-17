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
                "Tweet Id": "1427438051358384131",
                "Text": "Ah, welcome to IBM. This machine here handles all the oil refining in the country..we are not sure how exactly, and this one- this one does all the financial transactions..somehow. You wont be touching them, just follow these incan- instructions and learn them by rote.https://t.co/ZMYm2EEgB6 https://t.co/YEqXJWfA3w",
                "lang": "en",
                "date": 1629162726,
                "Weight": 307,
                "Company": "IBM"
              }
            }
        actual = app.batchSentiment(input)
        print("Actual", actual)
        expected = [{'ResultList': [{'Index': 0, 'Sentiment': 'POSITIVE', 'SentimentScore': {'Positive': 0.9300897717475891, 'Negative': 0.003447077004238963, 'Neutral': 0.06625871360301971, 'Mixed': 0.0002044376451522112}}], 'ErrorList': [], 'ResponseMetadata': {'RequestId': '1077e584-0291-4f63-a039-157499daf61a', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '1077e584-0291-4f63-a039-157499daf61a', 'content-type': 'application/x-amz-json-1.1', 'content-length': '206', 'date': 'Tue, 17 Aug 2021 17:50:16 GMT'}, 'RetryAttempts': 0}}]

        self.assertEquals(actual, expected)



    def test_lambda_handler(self):
        input = {
            "0": {
                "Tweet Id": "1427438051358384131",
                "Text": "Ah, welcome to IBM. This machine here handles all the oil refining in the country..we are not sure how exactly, and this one- this one does all the financial transactions..somehow. You wont be touching them, just follow these incan- instructions and learn them by rote.https://t.co/ZMYm2EEgB6 https://t.co/YEqXJWfA3w",
                "lang": "en",
                "date": 1629162726,
                "Weight": 307,
                "Company": "IBM"
            }
        }
        print()
        returnItem = app.lambda_twitterComprehend(input, "")
        # data = json.loads(returnItem["body"])
        # print(returnItem)
        assert returnItem["statusCode"] == 200