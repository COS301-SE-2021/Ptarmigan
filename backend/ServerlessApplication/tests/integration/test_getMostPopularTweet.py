import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app
import requests

baseUrl = "https://localhost:3000"

def fixture_event():
    return {
            "BeginDate" :  1628564655,
            "EndDate":  1628659505,
            "CompanyName": "Tesla"
        }

class TestGetMostPopularTweet(unittest.TestCase):
    def test_get_most_popular_tweet_valid_inputs(self):
        api_url = "http://localhost:3000/senthisize/getMostPopularTweet"
        response = requests.post(api_url, json=fixture_event())
        response.json()
        print(response)

        assert response.status_code == 200

    def test_get_most_popular_tweet_invalid_inputs(self):
        api_url = "http://localhost:3000/senthisize/getMostPopularTweet"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 400

