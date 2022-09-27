import requests
import pandas as pd
import random
import datetime

# Gets an old dataset, without time or p2p status and adds these variables using
# fake values. It also replaces sensitive data with fake values.

# In the current dataset, format changes after line 5472
data = pd.read_csv("speedtest.csv", nrows=5471)

# Create dummy data
random.seed(0)
data['share url'] = "https://www.speedtest.net/result/c/00000000-0000-0000-0000-00000000000000"
data['p2p'] = random.choices([True, False], k=len(data))
data['server id'] = random.choices([1001, 1002, 1003], weights=[0.85, 0.1, 0.05], k=len(data))
data['time'] = pd.date_range(datetime.datetime(2022, 6, 1), freq="10T", periods=len(data))

## Creates coherent server names
server_dic = {1001:"Alice server", 1002:"Bob server", 1003:"Unknown server"}
server_name_vector = []

for server_id in data['server id']:
  server_name_vector.append(server_dic[server_id])

data['server name'] = server_name_vector

# Export
data.to_csv("speedtest_dummy.csv", index=False, quoting=1)
