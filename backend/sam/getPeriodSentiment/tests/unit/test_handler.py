import json

import pytest
from unittest import TestCase
from hello_world import app


class TestClass(TestCase):
    def setUp(self):
        self.test_context ={
                              "BeginDate" : 1623005418000,
                              "EndDate": 1623065669000,
                              "CompanyName": "Tesla"
                            }

    def test_get_period(self):
        expected = 0.22625949087810593

        output = app.lambda_handler(self.test_context, {"stuff": "Stuff"})

        assert expected == output["body"]