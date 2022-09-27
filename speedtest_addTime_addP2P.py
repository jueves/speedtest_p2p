import sys
import datetime
import requests

# Gets a csv line from Ookla's Speedtest through a Bash pipe.
# Returns the same line adding atributes for current time and
# Transmission p2p app status.

transmission_url = "https://server:port/transmission/web/index.html"

def isTransmissionUp():
  # Checks if Transmission web interface is up.
  # Uses try to avoid error prompt when port is closed.
  try:
    page = requests.get(transmission_url)
    if (page.status_code == 200):
      transmission_running = "True"
    else:
      transmission_running = "False"

  except:
    transmission_running = "False"
  
  return(transmission_running)

def addAtributes(csv_line):
  # Takes a csv line and adds new atributes for time and p2p status.
  current_time_str = str(datetime.datetime.today())
  lineacompleta = csv_line + ", \"" + current_time_str + "\", \"" + isTransmissionUp() + "\""
  return(lineacompleta)

# Get Speedtest csv line from standard input.
# Uses "try" to avoid irrelevant socket error from going into the output text.
try:
  original_row = sys.stdin.readline()
except:
  pass

print(addAtributes(original_row.strip("\n")))
