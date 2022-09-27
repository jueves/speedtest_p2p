import sys
import datetime
import requests

transmission_url = "https://server:port/transmission/web/index.html"

def isTransmissionUp():
  try:
    page = requests.get(transmission_url)
    if (page.status_code == 200):
      transmission_running = "True"
    else:
      transmission_running = "False"

  except:
    transmission_running = "False"
  
  return(transmission_running)

def addAtributes(speedtest_line):
  current_time_str = str(datetime.datetime.today())
  lineacompleta = speedtest_line + ", \"" + current_time_str + "\", \"" + isTransmissionUp() + "\""
  return(lineacompleta)

# Use "try" to avoid irrelevant socket error from going into the output text.
try:
  original_row = sys.stdin.readline()
except:
  pass

print(addAtributes(original_row.strip("\n")))
