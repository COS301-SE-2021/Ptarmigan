import json
import snscrape.modules.twitter
import pandas as pd
import datetime


# helper function for handler
# Params
# content - string
# scrapetimeframe - datetime(unix Timestamp)
def returnTweetList(content, scrapetimeframe):
    tweets_list = []
    # Using TwitterSearchScraper to scrape data and append tweets to list
    # ["ar", "hi", "ko", "zh-TW", "ja", "zh", "de", "pt", "en", "it", "fr", "es"]
    # min_faves filters the results based on likes
    for i, tweet in enumerate(snscrape.modules.twitter.TwitterSearchScraper(
            content + " min_faves:100" +
            " lang:ar OR lang:hi OR lang:ko OR lang:zh OR lang:ja OR lang:de OR "
            "lang:pt OR lang:en OR lang:it OR lang:fr OR lang:es since:" + scrapetimeframe).get_items()):
        # only retrieves the first n tweets
        if i >= 100:
            break
        tweets_list.append([tweet.id, tweet.content, tweet.retweetCount,
                            tweet.likeCount, tweet.lang, tweet.date])
    # Creating a dataframe from the tweets list above
    return tweets_list


# Params
# event - json object (contains content and scrape_since)
def scrapetHandler(event, context):
    # Extract from json objects
    content = event['content']['content']

    scrape_since = int(event['scrape-until'])
    scrape_timestamp = datetime.datetime.fromtimestamp(scrape_since)
    scrape_dateformat = scrape_timestamp.strftime('%Y-%m-%d')

    # call helper function
    tweets_list = returnTweetList(content, scrape_dateformat)
    # create dataframe
    tweets_df = pd.DataFrame(tweets_list,
                             columns=['Tweet Id', 'Text', 'Retweets', 'Likes', 'lang', 'date'])

    # print (tweets_df.to_string)
    # Weight Calc
    weightList = []
    for x in range(len(tweets_df)):
        # Calculate Weight and append to weight list
        weightList.append(1 + ((tweets_df.loc[x, 'Retweets']) * 3) + (tweets_df.loc[x, 'Likes']))
    # add list to dataframe
    tweets_df['Weight'] = weightList
    # append company name dataframe
    tweets_df['Company'] = content

    # Remove unnecessary fields from table for output
    tweets_df = tweets_df.drop(['Retweets', 'Likes'], axis=1)

    # Convert to json and return
    jsonOutput = tweets_df.to_json(orient="index")
    parsed = json.loads(jsonOutput)
    return json.dumps(parsed, indent=4)