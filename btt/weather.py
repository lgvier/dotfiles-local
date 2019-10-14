#!/usr/bin/python
# -*- coding: utf-8 -*-

#import os
import requests
#latLon = os.popen("/usr/local/bin/locateme -f '{LAT},{LON}'").readlines()[0].rstrip()
latLon = '40.741895,-73.989308'
apiUrl = 'https://api.darksky.net/forecast/48c81d575c8b77fc6ca762c331fcd160/' + latLon + '?exclude=minutely,hourly,daily,alerts,flags'
try:
    rsp = requests.get(apiUrl).json()
    #temperature = rsp['currently']['temperature']
    temperature = (rsp['currently']['temperature'] - 32) * 5/9
    weatherStatus = rsp['currently']['icon']

    iconDict = {
    'clear-day': "☀️",
    'clear-night': "☀️",
    'partly-cloudy-day': "⛅️",
    'partly-cloudy-night': "⛅️",
    'cloudy': "☁️",
    'rain': "🌧",
    'sleet': "⛈",
    'fog': "🌫️",
    'wind': "🌀",
    'snow': "❄️"
    }

    print iconDict[weatherStatus] + " " + str(round(temperature * 10) / 10) + "°"
except:
    print "💩"


