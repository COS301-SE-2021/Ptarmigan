
import boto3

def batchSentiment(items):
    print(len(items))

    newItems = []
    languages = []
    doneItems = []

    for j in items:
        if items[j]['lang'] not in languages:
            languages.append(items[j]['lang'])

    print("languages: ", languages)

    for j in languages:
        print(j)
        for i in items:
            if items[i]["lang"] == j:
                newItems.append(items[i])
                print("asdf")

            if len(newItems) == 25:
                print("Len is above 25")
                doneItems.append(getSentimentBatch(newItems, j))
                newItems = []

        if len(newItems):
            doneItems.append(getSentimentBatch(newItems, j))
            newItems= []

    print(doneItems)
    return doneItems



def getSentimentBatch(batchArray, lang):
    print("Getting sentiment")
    comprehend = boto3.client("comprehend")
    textList = []
    for i in batchArray:
        print(i)
        textList.append(i["Text"])

    response = comprehend.batch_detect_sentiment(
        TextList=textList,
        LanguageCode='en'
    )

    print("Res", response)

    for i in response["ResultList"]:
        batchArray[i["Index"]]["Sentiment"] = i["Sentiment"]
        # print("DOne ", batchArray[i["Index"]])
    # Remember to remove sentimens with errors
    return batchArray






def lambda_twitterComprehend(event, context):
    dbClient = boto3.resource("dynamodb")
    processedData = batchSentiment(event)
    try:
        # db.writeToDB(processedData)
        putItem = []
        tableName = event['0']["Company"]
        for item in processedData[0]:
            newItem = {
                'PutRequest': {
                    'Item': {
                        'Tweet_Id': int(item["Tweet Id"]),
                        'Text': item["Text"],
                        'lang': item["lang"],
                        'Weight': str(item["Weight"]),
                        'Sentiment': item["Sentiment"],
                        'TimeStamp': int(item["date"]),
                        'CompanyName': item["Company"]
                    }

                }
            }
            putItem.append(newItem)

        print("PutItems ", putItem)

        dbClient.batch_write_item(
            RequestItems={
                tableName: putItem
            }
        )
    except:
        {
            "statusCode": 200,
            "body": "No tweets scraped, successful execution"
        }
    return {
            "statusCode": 200,
            "body": "This task was successful"
            }


