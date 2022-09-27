# Esto se puede hacer facilmente con una conversión a bytes directamente
# desde Tidyverse, sin alterar los datos originales, y produciendo dos gráficos de subida y bajada
# juntos y a parte el de latencia.
library(tidyverse)
library(ggplot2)
library(lubridate)

data <- read_csv("speedtest_dummy.csv")

# Compara subidas y bajadas totales a lo largo del tiempo
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot(aes(time)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Discerniendo por p2p
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot(aes(time)) + geom_line(aes(y=download, color=p2p)) + geom_line(aes(y=upload, color=p2p))

# Genera medias diarias
data %>%
  mutate(date=as.Date(time), download=download/1024, upload=upload/1024) %>%
  group_by(date) %>%
  summarise(date, download=mean(download), upload=mean(upload)) %>%
  distinct() %>%
  ggplot(aes(date)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Medias por hora
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  group_by(hour) %>%
  summarise(hour, download=mean(download), upload=mean(upload)) %>%
  distinct() %>%
  ggplot(aes(hour)) + geom_line(aes(y=download), color="dark green") + geom_line(aes(y=upload), color="dark blue")

# Medias por hora con p2p
data %>%
  mutate(hour=hour(time), download=download/1024, upload=upload/1024) %>%
  group_by(hour, p2p) %>%
  summarise(hour, p2p, download=mean(download), upload=mean(upload)) %>%
  ggplot(aes(hour)) + geom_line(aes(y=download, color=p2p)) + geom_line(aes(y=upload, color=p2p))

# Ver servidores
data %>%
  mutate(counter=1) %>%
  group_by(`server name`) %>%
  summarise(`server name`, sum(counter)) %>%
  distinct()

# O más sencillo con ggplot
ggplot(data, aes(`server name`, fill=`server name`)) + geom_bar() +
                  coord_flip() + theme(legend.position="none")

# Diagrama de cajas
data %>%
  mutate(download=download/1024, upload=upload/1024) %>%
  ggplot() + geom_boxplot(aes(download, color=p2p), orientation="y") + geom_boxplot(aes(upload, color=p2p), orientation="y")
