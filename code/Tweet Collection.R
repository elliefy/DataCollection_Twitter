install.packages("twitteR") #installs TwitteR library (twitteR) 
#loads TwitteR
library (twitteR)
library(rtweet)
library(dplyr)
library(ggplot2)
library(tidytext)
library(httpuv)

#Setting up your tweet token
api_key <- "your api key" 
api_secret <- "your api key" 
token <- "your api token" 
token_secret <- "your api token"
setup_twitter_oauth(api_key, api_secret, token, token_secret)

#Searching for Tweets
tweets <- searchTwitter("#COVID OR #community", n = 200, lang = "en")

#Output to a dataframe
tweets.df <-twListToDF(tweets)
write.csv(tweets.df, "tweets.csv") 

#Search for users
tmls <- get_timelines(c("wutrain", "KamalaHarris"), n = 500)
## plot the frequency of tweets for each user over time
tmls %>%
  filter(created_at > "2021-01-01") %>%
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
    title = "Frequency of Twitter statuses posted by Michelle Wu and KamalaHarris",
    subtitle = "Twitter status (tweet) counts aggregated by day from Jan 1 to Oct 12, 2021",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet")

## Plot for displaying locations of the users you have searched for
users <- search_users("#COVID vaccine", n = 50)
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
       title = "Where Twitter users are from - unique locations ")
