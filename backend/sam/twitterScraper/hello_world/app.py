import json
import pandas as pd
import snscrape.modules.twitter as snt


def scrapet_handler(event, context):
    content = event['content']
    tweets_list = []

    for i, tweet in enumerate(snt.TwitterSearchScraper(content).get_items()):
        if i >= 3:
            break
        tweets_list.append([tweet.id, tweet.content, tweet.user.username, tweet.user.followersCount, tweet.retweetCount,
                            tweet.likeCount, tweet.lang, tweet.date])
    tweets_df = pd.DataFrame(tweets_list,
                             columns=['Tweet Id', 'Text', 'Username', 'Followers', 'Retweets', 'Likes', 'lang', 'Date'])
    jsonOutput = tweets_df.to_json(orient="index")
    parsed = json.loads(jsonOutput)

    return {
        'statusCode': 200,
        'body': json.dumps(parsed)
    }