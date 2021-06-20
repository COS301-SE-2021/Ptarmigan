import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getSentimentPeriod import app


class TestGetSentiment(unittest.TestCase):

    def setup(self):
        self.testDatabaseOutput = '{ "BeginDate" : "1623005418000",'
        '"EndDate": "1623065669000", '
        ' "CompanyName": "Tesla" }'

    @patch('ptarmigan.synthesize.getSentimentPeriod.app.dbReturn')
    def test_LambdaFunc(self, mock_dbReturn):
        mock_dbReturn.return_value = json.dumps(
            '{"Items": [{"Tweet_Id": "7"), "Sentiment": "NEUTRAL", "TimeStamp": "1623058451000", "Weight": "583", '
            '"Text": "1891年、ニコラ・テスラによって設計された電気共振トランス回路、\n"Tesla coils"により再生されたBohemian Rhapsody '
            '♬ https://t.co/Z9KL6NGdG7", "CompanyName": "Tesla", "lang": "ja"}')
        output = app.lambda_handler(self.testDatabaseOutput, "")
        self.assertEquals(0, output)
