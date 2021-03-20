export DOCKER_VOLUMES=$HOME/.docker/volumes

alias dcup="docker-compose up --build --remove-orphans -d"

alias dcdown="docker-compose down --rmi all --remove-orphans -v"

alias docker-clean="docker system prune --all --force --volumes"

# Destroy all the docker things and create that which u've destroyed!
docker-rebuild() {
  informer "🗑 Destroying all the Docker things...."
  docker-compose down --rmi all --remove-orphans -v

  informer "🏗 Rebuidling all the Docker things...."
  docker-compose up --build
}
