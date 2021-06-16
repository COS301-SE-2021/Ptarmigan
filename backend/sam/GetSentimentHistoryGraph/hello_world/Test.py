import json
import time
import boto3
from boto3.dynamodb.conditions import Key
from unittest import TestCase
from unittest.mock import patch
import app


class TestClass(TestCase):
    def setUp(self):
        self.testData = '''{
                          "BeginDate": 1623027220000, 
                          "Interval": "Day",
                          "CompanyName": "Tesla"
                        }'''

    def testVeryDescriptively(self):
        expected = {"statusCode": 200,
                    "body": {
                        "CompanyName": "Tesla",
                        "Interval": 86400000,
                        "Data": [
                            {
                                "BeginDate": 1623027220000,
                             "EndDate": 1623113620000,
                             "IntervalData": 0.25011217469338914
                             },
                            {"BeginDate": 1623113620000, "EndDate": 1623200020000, "IntervalData": 0},
                            {"BeginDate": 1623200020000, "EndDate": 1623286420000, "IntervalData": 0},
                            {"BeginDate": 1623286420000, "EndDate": 1623372820000, "IntervalData": 0},
                            {"BeginDate": 1623372820000, "EndDate": 1623459220000, "IntervalData": 0},
                            {"BeginDate": 1623459220000, "EndDate": 1623545620000, "IntervalData": 0},
                            {"BeginDate": 1623545620000, "EndDate": 1623632020000, "IntervalData": 0},
                            {"BeginDate": 1623632020000, "EndDate": 1623718420000, "IntervalData": 0},
                            {"BeginDate": 1623718420000, "EndDate": 1623804820000, "IntervalData": 0},
                            {"BeginDate": 1623804820000, "EndDate": 1623891220000, "IntervalData": 0}
                        ]
                    }
                }



        test = app.lambda_handler(json.loads(self.testData), "")
        print(test)
        assert test == expected



