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
<pre class="r"><code>token <- create_token(
  app = "Yourname_twitter_app",
  consumer_key = "Your token",
  consumer_secret = "Your token information")</code></pre>

Searching for Tweets
----------------
<pre class="r"><code>rstats_tweets <- search_tweets(q = "#Covid",
                               n = 200) #max 18,000 every 15 minutes
                     head(rstats_tweets, n = 2) #looks at the top 2 tweets
                     colnames(rstats_tweets) # check column names
                               </code></pre>

Scrape from a Timeline
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

Scrape time
----------------
<p>Use similar methods to scrape the time for all the articles. We create another function timeScraper, and apply it to the html content.</p>
<pre class="r"><code>timeScraper <- function(x) {
  timestampHold <- as.character(html_text(html_nodes(x, ".submitted-date"))) %>% str_replace_all("[\n]", "")
  matrix(unlist(timestampHold))
  timestampHold[1]} 
timestamp <- lapply(xml, timeScraper) #list of timestamps
head(timestamp)</code></pre>

Output as a dataframe
----------------
<p>Create a dataframe for the text and time we scraped above</p>
<pre class="r"><code>articleDF <- data.frame(storyID = as.character(storyURL[,1]), 
                        headline = as.character(storyURL[,3]), 
                        matrix(unlist(articleText), nrow = num), 
                        matrix(unlist(timestamp), nrow = num), 
                        themes = as.character(storyURL[,7]))
names(articleDF)[3] <- 'text'
names(articleDF)[4] <- 'time'
#review the output
#articleDF[1: 2, ]
write.csv(articleDF, file = "TheHill_TrumpCovid_text.csv")</code></pre>

Further readings
----------------
The official documentation for the package [`rvest`](https://cran.r-project.org/web/packages/rvest/rvest.pdf)

[Simple web scraping for R in Github](https://github.com/tidyverse/rvest);

[RStudio Blog: rvest: easy web scraping with R] (https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/);

Real-world applications: [Most popular films](https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/), [Trip Advisor Reviews](https://www.johnlittle.info/project/custom/rfun-scrape/rvest_demo.nb.html), [IMDb pages](https://stat4701.github.io/edav/2015/04/02/rvest_tutorial/).





