library(tidyverse)
library(ggplot2)
library(lubridate)

data <- read_csv("speedtest_dummy.csv")

# Prepare data
data <- data %>%
  mutate(download = (download / 1024), upload = (upload / 1024),
         date = as.Date(time), hour = hour(time)) %>%
  gather(key = "type", value = "speed", c("download", "upload")) %>%
  mutate(full_type = str_c(type, p2p, sep = "_p2p"))

# Compares uploads and downloads along time
data %>%
  ggplot(aes(time, speed, color = type)) + geom_line()

# Separate by p2p status
data %>%
  ggplot(aes(time, speed, color = full_type)) + geom_line()

# Daily means
data %>%
  group_by(date, type) %>%
  summarise(date, type, speed = mean(speed)) %>%
  distinct() %>%
  ggplot(aes(date, speed, color = type)) + geom_line()

# Hourly means
data %>%
  group_by(hour, type) %>%
  summarise(hour, speed = mean(speed)) %>%
  distinct() %>%
  ggplot(aes(hour, speed, color = type)) + geom_line()

# Hourly means with p2p status
data %>%
  group_by(hour, full_type) %>%
  summarise(hour, full_type, speed = mean(speed)) %>%
  ggplot(aes(hour, speed, color = full_type)) + geom_line()

# Server count
ggplot(data, aes(`server name`, fill = `server name`)) + geom_bar() +
                  coord_flip() + theme(legend.position = "none")

# Boxplot
data %>%
  ggplot(aes(speed, color = type)) + geom_boxplot(orientation = "y")
