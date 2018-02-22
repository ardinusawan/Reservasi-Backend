#!/bin/bash
cd /home/administrator/web/Reservasi-Backend
/root/.rbenv/shims/gem update
/root/.rbenv/shims/bundle install
nohup /root/.rbenv/shims/rails s -b 0.0.0.0 -p 10003 -d -e production
