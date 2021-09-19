import json
from unittest.mock import patch
import pytest
import unittest
import requests

baseUrl = "https://localhost:3000"

def fixture_event():
    return { "content" : "IBM" }

class Test_UpdateBucketReturn(unittest.TestCase):
    def test_Update_bucket_return_success (self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/UpdateBucket"
        response = requests.post(api_url, json=fixture_event())
        response.json()
        print(response)

        assert response.status_code == 400

    def test_Update_Bucket_return_Invalid_Input (self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/UpdateBucket"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 400