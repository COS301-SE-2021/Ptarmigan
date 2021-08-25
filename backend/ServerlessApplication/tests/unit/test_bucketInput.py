import json
from unittest import TestCase
from unittest.mock import patch
import time
from ptarmigan.scraper.bucketInput import app

class TestClass(TestCase):

    def setUp(self):
        self.noInput = {}


    @patch('ptarmigan.scraper.bucketInput.app.uploadBucketList')
    @patch('ptarmigan.scraper.bucketInput.app.getBucketList')
    def test_return_Bucket_file(self,mock_BucketList,mock_Upload):
        mock_Upload.return_value = True
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                        "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                                                          {"content": "IBM"}, {"content": "Tesla"},
                                                          {"content": "Apple"}]}).encode('UTF-8'))
        expected = {"Scrape-until": 1628659921.2764487,
                    "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                    {"content": "IBM"}, {"content": "Tesla"},
                    {"content": "Apple"}]}

        testReturn = (app.lambda_handler(self.noInput, ""))
        assert testReturn == expected

    @patch('ptarmigan.scraper.bucketInput.app.uploadBucketList')
    @patch('ptarmigan.scraper.bucketInput.app.getBucketList')
    def test_return_Bucket_file(self, mock_BucketList, mock_Upload):
        mock_Upload.return_value = False
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                                         "scrape-detail": [{"content": "Bitcoin"},
                                                                           {"content": "Microsoft"},
                                                                           {"content": "IBM"}, {"content": "Tesla"},
                                                                           {"content": "Apple"}]}).encode('UTF-8'))
        expected = {
            'statusCode': 500,
            'body': json.dumps('Error updating Content file')
        }

        testReturn = (app.lambda_handler(self.noInput, ""))
        assert testReturn == expected