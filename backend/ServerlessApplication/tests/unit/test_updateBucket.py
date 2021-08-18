import json
from unittest import TestCase
from unittest.mock import patch
from ptarmigan.scraper.UpdateBucket import app

class TestClass(TestCase):

    def setUp(self):
        self.update_test_input = {"body": json.dumps({"content": "Tencent"})}
        self.update_test_input_already_exists = {"body": json.dumps({"content": "IBM"})}
        self.delete_invalid_input = {"body": {"context": "IBM"}}

    @patch('ptarmigan.scraper.UpdateBucket.app.uploadBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.getBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.database')
    def test_if_item_is_updated(self, mockDb, mock_BucketList,mock_Upload):
        mockDb = "yes"
        mock_Upload.return_value = True
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                        "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                                                          {"content": "IBM"}, {"content": "Tesla"},
                                                          {"content": "Apple"}]}).encode('UTF-8'))
        expected ={
            'statusCode': 200,
            'body': json.dumps('Successfully Updated the Content to scrape.')
        }

        testReturn = (app.lambda_handler(self.update_test_input, ""))
        assert testReturn == expected

    @patch('ptarmigan.scraper.UpdateBucket.app.uploadBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.getBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.database')
    def test_if_item_is_updated(self, mockDb, mock_BucketList, mock_Upload):
        mockDb = "yes"
        mock_Upload.return_value = True
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                                         "scrape-detail": [{"content": "Bitcoin"},
                                                                           {"content": "Microsoft"},
                                                                           {"content": "IBM"}, {"content": "Tesla"},
                                                                           {"content": "Apple"}]}).encode('UTF-8'))
        expected = {
                'statusCode': 400,
                'body': json.dumps('Item is already in the file')
            }

        testReturn = (app.lambda_handler(self.update_test_input_already_exists, ""))
        assert testReturn == expected

    def test_Invalid_input(self):
        expected = {
            'statusCode': 400,
            'body': json.dumps('Bad Request - invalid JSON input')
        }

        testReturn = (app.lambda_handler(self.delete_invalid_input, ""))
        assert testReturn == expected

    @patch('ptarmigan.scraper.UpdateBucket.app.uploadBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.getBucketList')
    @patch('ptarmigan.scraper.UpdateBucket.app.database')
    def test_if_item_is_updated(self, mockDb, mock_BucketList, mock_Upload):
        mockDb = "yes"
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

        testReturn = (app.lambda_handler(self.update_test_input, ""))
        assert testReturn == expected
