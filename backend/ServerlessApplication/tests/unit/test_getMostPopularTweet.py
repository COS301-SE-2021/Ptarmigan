import json
import unittest
from unittest.mock import patch
from ptarmigan.synthesize.getMostPopularTweet import app


class GetMostPopularTweet(unittest.TestCase):

    def setUp(self):
        self.testDatabaseOutput = {
                "BeginDate":  1628564655,
                "EndDate":  1628659505,
                "CompanyName": "Tesla"
            }


        # {
        #     "BeginDate": 1628554586,
        #     "Interval": "Day",
        #     "CompanyName": "Microsoft"
        # }

    @patch('ptarmigan.synthesize.getMostPopularTweet.app.dbCall')
    def test_get_most_popular_tweet(self, mock_dbReturn):
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
                            }
                         ]
        }

        expected = {'statusCode': 200,
                    'body': '{"Tweet_Id": "1425033022500392962", "Weight": "500"}'
                    }

        output = app.lambda_handler(self.testDatabaseOutput, "")
        self.assertEquals(output, expected)

    @patch('ptarmigan.synthesize.getMostPopularTweet.app.dbCall')
    def test_invalid_inputs(self, mock_dbReturn):
        mock_dbReturn.return_value = {
            "Items": [
                {
                    'Tweet_Id': 1425033022500392962,
                    'Sentiment': 'NEUTRAL',
                    'TimeStamp': 1628589323,
                    'Weight': '500',
                    'Text': '“gUaRaNtEe yOu CoUld bUy a tEslA” 💀 https://t.co/9RvRZCZODw https://t.co/fynaiadZ1t',
                    'CompanyName': 'Tesla',
                    'lang': 'en'
                }
            ]
        }

        invalidInput = {
            "EndDate": 1628659505,
            "CompanyName": "Tesla"
        }

        expected = {'statusCode': 400, 'body': '"Invalid Inputs"'}

        output = app.lambda_handler(invalidInput, "")
        print(output)
        self.assertEquals(output, expected)

