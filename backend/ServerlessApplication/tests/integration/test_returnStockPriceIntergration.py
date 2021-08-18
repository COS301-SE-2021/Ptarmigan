import json
from unittest.mock import patch
import pytest
import unittest
from ptarmigan.comprehend import app
import requests

baseUrl = "https://localhost:3000"

class Test_StockPriceListReturn(unittest.TestCase):
    def test_get_return_list_successful(self):
        api_url = "http://localhost:3000/stocks/returnStockPriceList"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 200
