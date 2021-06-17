import json

import pytest
from unittest import TestCase
from hello_world import app


class TestClass(TestCase):
    def setUp(self):
        self.test_context = "some"
        # Input data

    def get_sentiment_graph(self):
        testReturn = (app.lambda_handler(json.loads(self.test_context)), json.dumps("{}"))
        print("some")

        assert isinstance(testReturn, str)