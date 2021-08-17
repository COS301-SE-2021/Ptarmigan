import json
from unittest import TestCase
from unittest.mock import patch

from ptarmigan.scraper.deleteBucketItem import app

class TestClass(TestCase):

    def setUp(self):
        self.delete_test_input = {"body": json.dumps({"content": "IBM"})}
        self.delete_invalid_input = {"body": {"context": "IBM"}}
        self.delete_not_found = {"body": {"content": "IBM"}}

    @patch('ptarmigan.scraper.deleteBucketItem.app.uploadBucketList')
    @patch('ptarmigan.scraper.deleteBucketItem.app.getBucketList')
    def test_if_item_is_deleted(self,mock_BucketList,mock_Upload):
        mock_Upload.return_value = True
        mock_BucketList.return_value = bytes(json.dumps({"Scrape-until": 1628659921.2764487,
                                        "scrape-detail": [{"content": "Bitcoin"}, {"content": "Microsoft"},
                                                          {"content": "IBM"}, {"content": "Tesla"},
                                                          {"content": "Apple"}]}).encode('UTF-8'))
        expected = {
                'statusCode': 200,
                'body': json.dumps('Item Deleted successfully and Content file has been updated')
            }

        testReturn = (app.lambda_handler(self.delete_test_input, ""))
        assert testReturn == expected

