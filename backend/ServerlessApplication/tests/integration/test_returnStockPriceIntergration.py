import json
from unittest.mock import patch
import pytest
import unittest
import requests

baseUrl = "https://localhost:3000"

class Test_StockPriceListReturn(unittest.TestCase):
    def test_get_return_list_successful(self):
        api_url = "https://cn9x0zd937.execute-api.eu-west-1.amazonaws.com/Prod/stocks/returnStockPriceList"
        response = requests.post(api_url, json={})
        response.json()
        print(response)

        assert response.status_code == 200
