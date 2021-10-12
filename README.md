Preparation - Install packages
----------------
<pre class="r"><code>knitr::opts_chunk$set(echo = TRUE)
library(rtweet)
library(dplyr)
library(ggplot2)
library(tidytext)
library(httpuv)

</code></pre>

Setting up your rtweet token
----------------
1 - You need to get your token from [Twitter API first](https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api).

2 - Use the own token
<pre class="r"><code>
Stoken <- create_token(
  app = "your twitter name",
  consumer_key = "your token",
  consumer_secret = "your token")</code></pre>

Searching for Tweets
----------------
<pre class="r"><code>rstats_tweets <- search_tweets(q = "#COVID",
                               n = 200) #max 18,000 every 15 minutes
                               </code></pre>
                               
Output to a dataframe
rawtweets <- as.data.frame (rstats_tweets)
write.rawtweets(df, file='rawtweets.csv')

Search for users
----------------
Code Source: https://rtweet.info/

<pre class="r"><code>## get user IDs of accounts followed by Ellie Yang @elliefanyang
tmls <- get_timelines(c("Emoji Mashup Bot", "KamalaHarris"), n = 500)

## plot the frequency of tweets for each user over time
tmls %>%
  filter(created_at > "2018-10-01") %>%
  group_by(screen_name) %>%
  ts_plot("days", trim = 1L) +
  geom_point() +
  theme_minimal() +
  theme(
    legend.title = ggplot2::element_blank(),
    legend.position = "bottom",
    plot.title = ggplot2::element_text(face = "bold")) +
  labs(
    x = NULL, y = NULL,
    title = "Frequency of Twitter statuses posted by Emoji Mashup Bot and KamalaHarris",
    subtitle = "Twitter status (tweet) counts aggregated by day from October 1 to 17, 2018",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )</code></pre>
    
Plot for displaying locations of the users you have searched for
----------------
Source: https://www.earthdatascience.org/courses/earth-analytics/get-data-using-apis/use-twitter-api-r/

<pre class="r"><code>users <- search_users("#covid", n = 50)
users %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location, n)) %>%
  na.omit() %>%
  top_n(20) %>%
  ggplot(aes(x = location, y = n)) +
  geom_col() +
  coord_flip() +
      labs(x = "Count",
      y = "Location",
      title = "Where Twitter users are from - unique locations ")</code></pre>





