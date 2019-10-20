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
function docker-container () {
  if [ "$1" == "airflow" ]; then
    docker run \
      -d \
      -p 8081:8080 \
      puckel/docker-airflow webserver
  elif [ "$1" == "postgres" ]; then
    docker run --rm \
      --name pg-docker \
      -e POSTGRES_PASSWORD=docker -d \
      -p 5432:5432 \
      -v $DOCKER_VOLUMES/postgres:/var/lib/postgresql/data \
      postgres
  elif [ "$1" == "rabbitmq" ]; then
    docker run --rm \
      --name rabbitmq-docker \
      -p 5672:5672 \
      rabbitmq
  fi
}

# Destroy all the docker things and create that which u've destroyed!
function docker-rebuild () {
  informer "🗑 Destroying all the Docker things...."
  docker-compose down --rmi all --remove-orphans -v

  informer "🏗 Rebuidling all the Docker things...."
  docker-compose up --build
}