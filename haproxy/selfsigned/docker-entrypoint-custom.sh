#!/bin/bash

# Generate a self signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/stiller.blog.key -out /tmp/stiller.blog.crt -subj "/C=IL/O=Stiller Software Ltd./CN=stiller.blog"
cat /tmp/stiller.blog.crt /tmp/stiller.blog.key > /tmp/stiller.blog.pem
cp /tmp/stiller.blog.pem /etc/ssl/private/
rm -f /tmp/stiller.blog.*

# Call the original base entry point
./docker-entrypoint.sh $@