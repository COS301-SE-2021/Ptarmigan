import json

def lambda_handler(context, event):
    print("some")

    return {
        "StatusCode": 400,
        "Body": "This shit is lit"
    }
