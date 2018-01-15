#docker login

docker build -t stiller/haproxy:selfsigned selfsigned
docker push stiller/haproxy:selfsigned