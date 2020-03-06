DOCKER_VOLUMES=$HOME/.docker/volumes

#######################################
# Run standard docker containers
# Globals:
#   HOME
# Arguments:
#   $1 - Container to run
# Returns:
#   None
#######################################
docker-container() {
  if [ "$1" == "airflow" ]; then
    docker run \
      -d \
      -p 8081:8080 \
      puckel/docker-airflow webserver
  elif [ "$1" == "postgres" ]; then
    docker run --rm \
      --name postgres \
      -p 5432:5432 \
      -v $DOCKER_VOLUMES/postgres:/var/lib/postgresql/data \
      -e POSTGRES_USER="$2" \
      -e POSTGRES_PASSWORD="$3" \
      -e POSTGRES_DB="$4" \
      -d \
      postgres
  elif [ "$1" == "rabbitmq" ]; then
    docker-compose -f $HOME/.dotfiles/services/docker-compose.yml up rabbitmq
  fi
}

alias dcup="docker-compose up --build --remove-orphans -d"

alias dcdown="docker-compose down --rmi all --remove-orphans -v"

# Destroy all the docker things and create that which u've destroyed!
docker-rebuild() {
  informer "🗑 Destroying all the Docker things...."
  docker-compose down --rmi all --remove-orphans -v

  informer "🏗 Rebuidling all the Docker things...."
  docker-compose up --build
}
