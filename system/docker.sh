export DOCKER_VOLUMES=$HOME/.docker/volumes

function dnames-fn {
  echo "Names of all running containers"
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dsr {
	docker stop $1;docker rm $1
}

# This will remove all dangling images:
function drm-dangling {
  imgs=$(docker images -q -f dangling=true)
  [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
  docker ps --filter="label=$1" --format="{{.ID}}"
}

alias d="docker"
alias dc-d="docker compose down"
alias dc-dr="docker compose down --rmi all --remove-orphans -v"
alias dc-reboot="docker compose stop && docker compose up --build -d"
alias dc-stop="docker compose stop"
alias dc-u="docker compose up"
alias dc-ub="docker compose up --build --force-recreate --remove-orphans -V"
alias dc="docker compose"
alias dexec='docker exec -it'
alias dexecroot='docker exec -u root -it'
alias dim="docker images"
alias dinspect='docker inspect'
alias dlogs='docker logs'
alias dps='docker ps'
alias dps="docker ps"
alias dpsa='docker ps -a'
alias dpsa="docker ps -a"
alias drmc="docker rm $(docker ps --all -q -f status=exited)"
alias drun="docker run "
alias ds-p="docker system prune --all"
alias ds-rf="docker system prune --all --force --volumes"
alias dstop="docker stop"