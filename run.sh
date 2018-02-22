#!/bin/bash
# cd /home/administrator/web/Reservasi-Backend
gem update
bundle install
nohup rails s -b 0.0.0.0 -p 10003 -d -e production
