import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app
import requests

baseUrl = "https://localhost:3000"

def fixture_event():
    return {
    "BeginDate": 1628554586,
    "Interval": "Day",
    "CompanyName": "Microsoft"
}

class TestGetGraphSentiment(unittest.TestCase):
    def test_get_sentiment_graph_valid_inputs(self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/senthisize/getGraphSentiment"
        response = requests.post(api_url, json=fixture_event())
        response.json()
        print(response)

        assert response.status_code == 200

    def test_get_sentiment_graph_invalid_inputs(self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/senthisize/getGraphSentiment"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 400

