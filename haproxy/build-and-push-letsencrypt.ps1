#docker login

docker build -t stiller/haproxy:letsencrypt letsencrypt
docker push stiller/haproxy:letsencrypt