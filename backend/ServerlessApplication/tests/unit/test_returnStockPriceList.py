import json
from unittest import TestCase
from unittest.mock import patch

from ptarmigan.stocks.returnStockPriceList import app

class TestClass(TestCase):

    def setUp(self):
        self.empty_Json_input = {}


    @patch('ptarmigan.stocks.returnStockPriceList.app.returnListFromS3')
    def test_if_item_is_returned(self,mock_BucketList):
        mock_BucketList.return_value = bytes(json.dumps({"statusCode": 200,
        "body": {"Bitcoin": "47215.05000000", "Microsoft": "292.8500", "Tesla": "717.1700", "Apple": "149.1000"}}).encode('UTF-8'))

        expected = {
                'statusCode': 200,
                'body': json.dumps({"statusCode": 200, "body": {"Bitcoin": "47215.05000000", "Microsoft": "292.8500", "Tesla": "717.1700", "Apple": "149.1000"}})
                    }

        testReturn = (app.lambda_handler(self.empty_Json_input, ""))
        assert testReturn == expected