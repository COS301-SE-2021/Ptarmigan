import json

# import requests


def lambda_initializeArray(event, context):
    length = len(event)
    initialisedArray = {"done": 'false', "currentIndex": 0, "eventLength": len(event), "content": event}

    return initialisedArray

