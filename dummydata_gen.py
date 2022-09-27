import requests
import pandas as pd
import random
import datetime

# Format changes after line 5472
data = pd.read_csv("speedtest.csv", nrows=5471)

# Create dummy data
time_vector = [datetime.datetime(2022, 6, 1)]
p2p_vector = [False]

for i in range(1, len(data)):
  time_vector.append(time_vector[-1] + datetime.timedelta(minutes=10))
  p2p_vector.append(random.random() > 0.5)

data['time'] = time_vector
data['p2p'] = p2p_vector
data['share url'] = "https://www.speedtest.net/result/c/00000000-0000-0000-0000-00000000000000"
  
data['server id'] = random.choices([1001, 1002, 1003], weights=[0.85, 0.1, 0.05], k=len(data))

server_dic = {1001:"Alice server", 1002:"Bob server", 1003:"Unknown server"}
server_name_vector = []

for server_id in data['server id']:
  server_name_vector.append(server_dic[server_id])

data['server name'] = server_name_vector

# Export
data.to_csv("speedtest_dummy.csv", index=False, quoting=1)
