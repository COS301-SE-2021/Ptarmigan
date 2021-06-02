import json
import snscrape.modules.twitter as snt
import pandas as pd


def scrapet_handler(event, context):
    content = event['content']

    tweets_list = []

    # Using TwitterSearchScraper to scrape data and append tweets to list
    for i, tweet in enumerate(snt.TwitterSearchScraper(content).get_items()):
        if i >= 25:
            break
        tweets_list.append([tweet.content, tweet.retweetCount,
                            tweet.likeCount, tweet.lang, tweet.date])

    # Creating a dataframe from the tweets list above
    tweets_df = pd.DataFrame(tweets_list,
                             columns=['Text', 'Retweets', 'Likes', 'lang', 'date'])

    # Weight Calc
    weightList = []
    for x in range(len(tweets_df)):
        # Calculate Weight and append to weight list
        weightList.append(1 + ((tweets_df.loc[x, 'Retweets']) * 3) + (tweets_df.loc[x, 'Likes']))
    # add list to dataframe
    tweets_df['Weight'] = weightList

    #Remove unnecessary fields from table for output
    tweets_df = tweets_df.drop(['Retweets', 'Likes'], axis=1)

    jsonOutput = tweets_df.to_json(orient="index")
    parsed = json.loads(jsonOutput)
    return json.dumps(parsed, indent=4)
