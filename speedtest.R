library(tidyverse)
library(ggplot2)
library(lubridate)

data <- read_csv("speedtest_dummy.csv")

# Compares uploads and downloads along time
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  ggplot(aes(time, speed, color=type)) + geom_line()

# Separate by p2p status
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  mutate(type=str_c(type, p2p, sep="_p2p")) %>%
  ggplot(aes(time, speed, color=type)) + geom_line()

# Daily means
data %>%
  mutate(date=as.Date(time), download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  group_by(date, type) %>%
  summarise(date, type, speed=mean(speed)) %>%
  distinct() %>%
  ggplot(aes(date, speed, color=type)) + geom_line()

# Hourly means
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  group_by(hour, type) %>%
  summarise(hour, speed=mean(speed)) %>%
  distinct() %>%
  ggplot(aes(hour, speed, color=type)) + geom_line()

# Hourly means with p2p status
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  mutate(type=str_c(type, p2p, sep="_p2p")) %>%
  group_by(hour, type) %>%
  summarise(hour, type, speed=mean(speed)) %>%
  ggplot(aes(hour,speed, color=type)) + geom_line()

# Server count
ggplot(data, aes(`server name`, fill=`server name`)) + geom_bar() +
                  coord_flip() + theme(legend.position="none")

# Boxplot
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  gather(key="type", value="speed", c('download', 'upload')) %>%
  mutate(type=str_c(type, p2p, sep="_p2p")) %>%
  ggplot(aes(speed, color=type)) + geom_boxplot(orientation="y")
