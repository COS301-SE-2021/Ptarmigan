import json
from unittest.mock import patch
import pytest
import unittest
import requests

baseUrl = "https://localhost:3000"

class Test_BucketInputTest(unittest.TestCase):
    def test_Bucket_Input_Success(self):
        api_url = "http://localhost:3000/scraper/bucketInput"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 200