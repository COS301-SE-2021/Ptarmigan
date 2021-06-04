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

    @patch('backend.sam.twitterScraper.lambda_scrapet.return_tweet_df')
    def test_IfScrapetReturnsTweetsWithCorrectData(self, mock_scrape):
        expected = ({
            "0": {
                "Text": "I SAID BUY MORE  #BITCOIN #BitcoinConference https://t.co/VL7Yww6Fx2",
                "lang": "en",
                "date": 1622746104000,
                "Weight": 2568
            }
        })
        #expected = '{}'
        # mock data for scraper lbrary
        mock_scrape.return_value = pandas.DataFrame()
        testReturn = (ls.scrapet_handler(json.loads(self.test_tweet_context), ""))
        #print(testReturn)
        #print(expected)
        #print(type(expected))
        #print(type(testReturn))
        assert testReturn == expected
