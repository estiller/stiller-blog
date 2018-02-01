#!/bin/bash

# Obtain a certificate
certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d stiller.blog -d www.stiller.blog -n --agree-tos --email git@stiller.co.il
cat /etc/letsencrypt/live/stiller.blog/fullchain.pem /etc/letsencrypt/live/stiller.blog/privkey.pem > /etc/ssl/private/stiller.blog.pem
chmod -R go-rwx /etc/ssl/private

# Call the original base entry point
./docker-entrypoint.sh $@