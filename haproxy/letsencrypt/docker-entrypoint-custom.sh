#!/bin/bash

# Obtain a certificate
certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d stiller.blog -d www.stiller.blog -d stiller.co.il -d www.stiller.co.il -n --agree-tos --email git@stiller.co.il
cat /etc/letsencrypt/live/stiller.blog/fullchain.pem /etc/letsencrypt/live/stiller.blog/privkey.pem > /etc/ssl/private/stiller.blog.pem
chmod -R go-rwx /etc/ssl/private

# change certbot to use another port when running behind HAProxy
sed -i 's/http01_port = 80/http01_port = 54321/g' /etc/letsencrypt/renewal/stiller.blog.conf

# Add cron job for renewing certificate
crontab -l > /tmp/currentcron
echo '30 2 * * * /usr/bin/certbot renew --renew-hook "/usr/local/bin/renew.sh" >> /var/log/le-renewal.log' >> /tmp/currentcron
crontab /tmp/currentcron
rm /tmp/currentcron

# Call the original base entry point
./docker-entrypoint.sh $@