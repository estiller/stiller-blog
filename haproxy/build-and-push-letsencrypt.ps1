#docker login

docker build -t stiller/haproxy:letsencrypt $PSScriptRoot/letsencrypt
docker push stiller/haproxy:letsencrypt