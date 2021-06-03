import unittest
from unittest import TestCase
from unittest.mock import patch
from unittest.mock import MagicMock
import os
import json
import snscrape.modules.twitter as snt
import backend.sam.twitterScraper.lambda_scrapet as ls

class TestClass(TestCase) :

    def setUp(self) -> None:
        self.test_tweet_context ='{ "content": "Bitcoin"}'

    @patch('snt.TwitterSearchScraper')
    def test_IfScrapetReturnsTweetsWithCorrectData(self,mock_scrape):
        expected = ({
    "0": {
        "Text": "I'm interviewing @cameron &amp; @tyler at the Bitcoin Conference tomorrow.\n\nGemini is one of the most secure &amp; reliable crypto platforms. You can buy, sell, store, earn interest, or learn crypto - Gemini does it all. They even sponsor the podcast \ud83d\ude02\n\nSign up: https://t.co/WbdVHdxvH8",
        "lang": "en",
        "date": 1622747771000,
        "Weight": 193
    },
    "1": {
        "Text": "If you can\u2019t attend the conference, make sure to tune into the Day 1 livestream on YouTube:\n\nhttps://t.co/REqyW6sunm",
        "lang": "en",
        "date": 1622746176000,
        "Weight": 203
    },
    "2": {
        "Text": "I SAID BUY MORE  #BITCOIN #BitcoinConference https://t.co/VL7Yww6Fx2",
        "lang": "en",
        "date": 1622746104000,
        "Weight": 2568
    }
    })

        #mock data for scraper lbrary
        mock_scrape.return_value = MagicMock({
    "0": {
        "Text": "I'm interviewing @cameron &amp; @tyler at the Bitcoin Conference tomorrow.\n\nGemini is one of the most secure &amp; reliable crypto platforms. You can buy, sell, store, earn interest, or learn crypto - Gemini does it all. They even sponsor the podcast \ud83d\ude02\n\nSign up: https://t.co/WbdVHdxvH8",
        "Retweets": 8,
        "Likes": 168,
        "lang": "en",
        "date": 1622747771000
    },
    "1": {
        "Text": "If you can\u2019t attend the conference, make sure to tune into the Day 1 livestream on YouTube:\n\nhttps://t.co/REqyW6sunm",
        "Retweets": 25,
        "Likes": 127,
        "lang": "en",
        "date": 1622746176000
    },
    "2": {
        "Text": "I SAID BUY MORE  #BITCOIN #BitcoinConference https://t.co/VL7Yww6Fx2",
        "Retweets": 184,
        "Likes": 3016,
        "lang": "en",
        "date": 1622746104000
    }
})
        testreturn = (ls.scrapet_handler(json.loads(self.test_tweet_context),""))
        assert json.dumps(testreturn) == expected

