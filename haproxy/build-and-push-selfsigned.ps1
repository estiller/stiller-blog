#docker login

docker build -t stiller/haproxy:selfsigned $PSScriptRoot/selfsigned
docker push stiller/haproxy:selfsigned