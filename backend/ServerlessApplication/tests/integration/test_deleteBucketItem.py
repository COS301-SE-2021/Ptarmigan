import json
from unittest.mock import patch
import pytest
import unittest
import requests

baseUrl = "https://localhost:3000"

def fixture_event():
    return { "content" : "IBM" }

class Test_DeleteBucketItem(unittest.TestCase):
    def test_Delete_Bucket_return_success (self):
        api_url = "http://localhost:3000/scraper/deleteBucketItem"
        response = requests.post(api_url, json=fixture_event())
        response.json()
        print(response)

        assert response.status_code == 200

    def test_Delete_Bucket_Return_invalid_Input(self):
        api_url = "http://localhost:3000/scraper/deleteBucketItem"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 400