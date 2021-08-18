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

class TestGetGraphSentiment:
    def test_get_sentiment_graph_valid_inputs(self):
        api_url = "http://localhost:3000/senthisize/getGraphSentiment"
        response = requests.post(api_url, json=fixture_event())
        response.json()
        print(response)

        assert response.status_code == 200

    def test_get_sentiment_graph_invalid_inputs(self):
        api_url = "http://localhost:3000/senthisize/getGraphSentiment"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 400

