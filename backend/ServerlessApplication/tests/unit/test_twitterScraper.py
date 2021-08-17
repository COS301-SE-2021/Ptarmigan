import json
from unittest import TestCase
from unittest.mock import patch

from ptarmigan.scraper.twitterScraper import app



class TestClass(TestCase):

    def setUp(self):
        self.test_tweet_context = '{ "Scrape-until": "1629235961",' \
                                    '"content": {' \
                                    '"content": "IBM"}}'\


    @patch('ptarmigan.scraper.twitterScraper.app.return_tweet_list')

    def test_IfScrapetReturnsTweetsWithCorrectData(self, mock_scrape):
        expected = ({
            "0": {
                "Tweet Id": 100000000001,
                "Text": "A",
                "lang": "en",
                "date": 1629235961,
                "Weight": 21,
                "Company": "IBM"
            },
            "1": {
                "Tweet Id": 100000000002,
                "Text": "E",
                "lang": "en",
                "date": 1629235961,
                "Weight": 25,
                "Company": "IBM"
            },
            "2": {
                "Tweet Id": 100000000003,
                "Text": "I",
                "lang": "en",
                "date": 1629235961,
                "Weight": 29,
                "Company": "IBM"
            },
            "3": {
                "Tweet Id": 100000000004,
                "Text": "O",
                "lang": "en",
                "date": 1629235961,
                "Weight": 33,
                "Company": "IBM"
            },
            "4": {
                "Tweet Id": 100000000005,
                "Text": "U",
                "lang": "en",
                "date": 1629235961,
                "Weight": 37,
                "Company": "IBM"
            }
        })
        # mock data for scraper library
        mock_scrape.return_value = [[100000000001, "A", 5, 5, "en", 1629235961],
                                    [100000000002, "E", 6, 6, "en", 1629235961],
                                    [100000000003, "I", 7, 7, "en", 1629235961],
                                    [100000000004, "O", 8, 8, "en", 1629235961],
                                    [100000000005, "U", 9, 9, "en", 1629235961]]
        # call function
        testReturn = (app.scraper_handler(json.loads(self.test_tweet_context), ""))
        assert testReturn == expected