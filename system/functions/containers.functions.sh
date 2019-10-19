DOCKER_VOLUMES=$HOME/.docker/volumes

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