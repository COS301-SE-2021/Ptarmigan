import json
import pytest

from ptarmigan.comprehend import app

@pytest.fixture()

def fixture_event():
    return {
                "0": {
                    "Text": "We can't underestimate the next few days for #Tesla. Plaid is the next generation, Plaid is a new level of technology, Plaid is when the entire world looks at EVs &amp; realises they are our undeniable future. Plaid is the answer to clean transport, the final nail in the ICE coffin. https://t.co/kRgIU7Dmya",
                    "lang": "en",
                    "date": 1623065669,
                    "Weight": 177,
                    "Tweet Id": "0",
                    "CompanyName": "Tesla"
                }
            }

class TestComprehend:
    def test_lambda_handler(self, fixture_event):
        returnItem = app.lambda_twitterComprehend(fixture_event, "")
        # data = json.loads(returnItem["body"])

        assert returnItem["statusCode"] == 200