import json
from unittest import TestCase
from unittest.mock import patch

from ptarmigan.scraper.returnBucketList import app

class TestClass(TestCase):

    def setUp(self):
        self.empty_Json_input = {}


    @patch('ptarmigan.scraper.returnBucketList.app.getBucketList')
    def test_if_item_is_returned(self,mock_BucketList):
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                        "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                                                          {"content": "IBM"}, {"content": "Tesla"},
                                                          {"content": "Apple"}]}).encode('UTF-8'))
        expected = {
                'statusCode': 200,
                'body': json.dumps({"Scrape-until": 1628659921.2764487,
                                        "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                                                          {"content": "IBM"}, {"content": "Tesla"},
                                                          {"content": "Apple"}]})
            }

        testReturn = (app.lambda_handler(self.empty_Json_input, ""))
        assert testReturn == expected