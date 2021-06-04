import json
from unittest import TestCase
from unittest.mock import MagicMock
from unittest.mock import patch

import pandas
import snscrape.modules.twitter as snt
import backend.sam.twitterScraper.lambda_scrapet as ls


class TestClass(TestCase):

    def setUp(self):
        self.test_tweet_context = '{"content": "Bitcoin"}'

    @patch('backend.sam.twitterScraper.lambda_scrapet.return_tweet_list')
    def test_IfScrapetReturnsTweetsWithCorrectData(self, mock_scrape):
        expected = ({
            "0": {
                "Text": "A",
                "lang": "en",
                "date": 1622746104001,
                "Weight": 21
            },
            "1": {
                "Text": "E",
                "lang": "en",
                "date": 1622746104002,
                "Weight": 25
            },
            "2": {
                "Text": "I",
                "lang": "en",
                "date": 1622746104003,
                "Weight": 29
            },
            "3": {
                "Text": "O",
                "lang": "en",
                "date": 1622746104004,
                "Weight": 33
            },
            "4": {
                "Text": "U",
                "lang": "en",
                "date": 1622746104005,
                "Weight": 37
            }
        })
        expected = json.dumps(expected,indent=4)
        #expected = '{}'
        # mock data for scraper lbrary
        mock_scrape.return_value = [["A", 5, 5, "en", 1622746104001],["E", 6, 6, "en", 1622746104002],["I", 7, 7, "en", 1622746104003],["O", 8, 8, "en", 1622746104004],["U", 9, 9, "en", 1622746104005],]
        #call function
        testReturn = (ls.scrapet_handler(json.loads(self.test_tweet_context), ""))

        assert testReturn == expected
