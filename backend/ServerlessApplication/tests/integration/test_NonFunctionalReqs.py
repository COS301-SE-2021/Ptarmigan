import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app
import requests

def fixture_event():
    return {"context": "Tesla"}

class Test_Prediction(unittest.TestCase):

    def test_return_prediction_success(self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/prediction"
        response = requests.post(api_url, json=fixture_event)
        response.json()
        print(response)

        assert response.status_code == 200