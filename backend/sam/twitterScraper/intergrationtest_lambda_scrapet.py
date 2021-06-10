import json
from unittest import TestCase

import backend.sam.twitterScraper.lambda_scrapet as ls


class TestClass(TestCase):

    def setUp(self):
        self.test_tweet_context = '{"content": "Tesla"}'

    def test_scraper_returns_tweets(self):
        testreturn = (ls.scrapet_handler(json.loads(self.test_tweet_context), ""))

        #print(testreturn)
        #check the function returns a string
        assert isinstance(testreturn,str)
        #turn the string back into dict
        testreturn = json.loads(testreturn)
        testreturn1 = testreturn['0']

        #check that the right types are returned in the dict object
        assert isinstance(testreturn1['Text'], str)
        assert isinstance(testreturn1['lang'], str)
        assert isinstance(testreturn1['date'], int)
        assert isinstance(testreturn1['Weight'], int)
