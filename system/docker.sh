export DOCKER_VOLUMES=$HOME/.docker/volumes

alias dcup="docker-compose up --build --remove-orphans"

alias dcdown="docker-compose down --rmi all --remove-orphans -v"

alias docker-clean="docker system prune --all --force --volumes"