import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getMostPopularTweet import app


class GetMostPopularTweet(unittest.TestCase):

    def setUp(self):
        self.testDatabaseOutput = {"body": {
            "BeginDate":  1628564655,
            "EndDate":  1628659505,
            "CompanyName": "Tesla"
        }}

        # {
        #     "BeginDate": 1628554586,
        #     "Interval": "Day",
        #     "CompanyName": "Microsoft"
        # }

    @patch('ptarmigan.synthesize.getMostPopularTweet.app.dbCall')
    def test_if_sentiment_calculation_graph_returns_correct_data(self, mock_dbReturn):
        mock_dbReturn.return_value = {
                    "Items": [
                        {
                        'Tweet_Id':1425033022500392962,
                        'Sentiment': 'NEUTRAL',
                        'TimeStamp': 1628589323,
                        'Weight': '500',
                        'Text': '“gUaRaNtEe yOu CoUld bUy a tEslA” 💀 https://t.co/9RvRZCZODw https://t.co/fynaiadZ1t',
                        'CompanyName': 'Tesla',
                        'lang': 'en'
                            },
                        {
                         'Tweet_Id': 1425311842499502082,
                         'Sentiment': 'NEUTRAL',
                         'TimeStamp': 1628655798,
                         'Weight': '3',
                         'Text': '@finKlEiNhoRN22 @Irate_Prankster @NorthernAndrew_ The wife reminds me of Grimes married to Tesla',
                         'CompanyName': 'Tesla',
                         'lang': 'en'
                         }
                         ]
        }

        expected = {"statusCode": 200,
             "body":
              {"Tweet_Id": "1425087591456534529",
               "Weight": "3108"}
             }

        output = app.lambda_handler(self.testDatabaseOutput, "")
        print(output)
        self.assertEquals(output, expected)

