#!/bin/bash

# create the renewed cert file
cat /etc/letsencrypt/live/stiller.blog/fullchain.pem /etc/letsencrypt/live/stiller.blog/privkey.pem > /etc/ssl/private/stiller.blog.pem

# reload haproxy
service haproxy reload