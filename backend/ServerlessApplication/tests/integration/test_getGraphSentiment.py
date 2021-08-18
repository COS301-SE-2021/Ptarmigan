import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app
import requests

baseUrl = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com"

def fixture_event():
    return {"body" : {
            "BeginDate": 1623005418000,
            "Interval": "Week",
            "CompanyName": "Tesla"
        }}

class TestGetGraphSentiment:
    def test_get_sentiment_graph(self):
        url = baseUrl + "/Prod/senthisize/getGraphSentiment"
        res = requests.get(url, params=fixture_event())
        print(res)
        assert res.status_code == 200
