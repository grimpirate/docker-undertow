# Undertow on Alpine Linux Dockerfile
## Build
docker build -t undertow .
## Run
docker run -p 80:80 -it undertow
## Prune
docker system prune -a  
docker container prune  
docker volume prune
