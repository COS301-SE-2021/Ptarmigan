import json
import snscrape.modules.twitter
import pandas as pd
import datetime

#helper function for handler
def return_tweet_list(content,scrapeTimeframe):
    tweets_list = []
    # Using TwitterSearchScraper to scrape data and append tweets to list
    # ["ar", "hi", "ko", "zh-TW", "ja", "zh", "de", "pt", "en", "it", "fr", "es"]
    for i, tweet in enumerate(snscrape.modules.twitter.TwitterSearchScraper(
            content + " min_faves:100" + " lang:ar OR lang:hi OR lang:ko OR lang:zh OR lang:ja OR lang:de OR lang:pt OR lang:en OR lang:it OR lang:fr OR lang:es since:" + scrapeTimeframe).get_items()):
        if i >= 100:
            break
        tweets_list.append([str(tweet.id), tweet.content, tweet.retweetCount,
                            tweet.likeCount, tweet.lang, tweet.date.timestamp()])
    # Creating a dataframe from the tweets list above
        #print(type(tweets_list[0][0]))
    return tweets_list

def scraper_handler(event, context):
    content = event['content']['content']
    scrape_since = int(event['Scrape-until'])
    scrape_timestamp = datetime.datetime.fromtimestamp(scrape_since)
    scrape_dateformat = scrape_timestamp.strftime('%Y-%m-%d')

    # call helper function
    tweets_list = return_tweet_list(content, scrape_dateformat)
    #create dataframe
    tweets_df = pd.DataFrame(tweets_list,
                             columns=['Tweet Id', 'Text', 'Retweets', 'Likes', 'lang', 'date'])
    # Weight Calc
    weightList = []
    for x in range(len(tweets_df)):
        # Calculate Weight and append to weight list
        weightList.append(1 + ((tweets_df.loc[x, 'Retweets']) * 3) + (tweets_df.loc[x, 'Likes']))
    # add list to dataframe
    tweets_df['Weight'] = weightList
    tweets_df['Company'] = content

    # Remove unnecessary fields from table for output
    tweets_df = tweets_df.drop(['Retweets', 'Likes'], axis=1)
    jsonOutput = tweets_df.to_json(orient='index')
    parsed = json.loads(jsonOutput)
    return parsed
    #return json.dumps(parsed)