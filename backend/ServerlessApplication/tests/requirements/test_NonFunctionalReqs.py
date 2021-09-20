from datetime import time

from locust import HttpUser, TaskSet, task, between

import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def returnBucketList(self):
        self.client.post("/scraper/returnBucketList")

    @task
    def getDailySentiment(self):
        self.client.post("/senthisize/getDailySentiment", json={
            "company": "Bitcoin",
            "beginDate": 1628899200
         })

    @task
    def getMostPopularTweet(self):
        self.client.post("/senthisize/getMostPopularTweet",json={
            "BeginDate" :  1628564655,
            "EndDate":  1628659505,
            "CompanyName": "Tesla"
        })


    @task
    def returnStockPriceList(self):
        self.client.post("/stocks/returnStockPriceList")
