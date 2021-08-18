import json
from unittest.mock import patch
import pytest
import unittest
import requests

baseUrl = "https://localhost:3000"


class Test_returnBucketList(unittest.TestCase):

    def test_return_Bucket_List_Success(self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/scraper/returnBucketList"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 200
