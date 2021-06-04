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

    def test_scraper_returns_tweets(self):
        testreturn = (ls.scrapet_handler(json.loads(self.test_tweet_context), ""))

        assert isinstance(testreturn,str)

        testreturn = json.loads(testreturn)

        testreturn1 = testreturn['0']

        assert isinstance(testreturn1['Text'], str)
        assert isinstance(testreturn1['lang'], str)
        assert isinstance(testreturn1['date'], int)
        assert isinstance(testreturn1['Weight'], int)
