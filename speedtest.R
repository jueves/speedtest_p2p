library(tidyverse)
library(ggplot2)
library(lubridate)

data <- read_csv("speedtest_dummy.csv")

# Compares uploads and downloads along time
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot(aes(time)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Separate by p2p status
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot(aes(time)) + geom_line(aes(y=download, color=p2p)) + geom_line(aes(y=upload, color=p2p))

# Daily means
data %>%
  mutate(date=as.Date(time), download=download/1024, upload=upload/1024) %>%
  group_by(date) %>%
  summarise(date, download=mean(download), upload=mean(upload)) %>%
  distinct() %>%
  ggplot(aes(date)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Hourly means
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  group_by(hour) %>%
  summarise(hour, download=mean(download), upload=mean(upload)) %>%
  distinct() %>%
  ggplot(aes(hour)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Hourly means with p2p status
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  group_by(hour, p2p) %>%
  summarise(hour, p2p, download=mean(download), upload=mean(upload)) %>%
  ggplot(aes(hour)) + geom_line(aes(y=download, color=p2p)) + geom_line(aes(y=upload, color=p2p))

# Server count
ggplot(data, aes(`server name`, fill=`server name`)) + geom_bar() +
                  coord_flip() + theme(legend.position="none")

# Boxplot
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot() + geom_boxplot(aes(download, color=p2p), orientation="y") + geom_boxplot(aes(upload, color=p2p), orientation="y")
