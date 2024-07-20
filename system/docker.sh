export DOCKER_VOLUMES=$HOME/.docker/volumes

#######################################################################################
#                                                                                     #
#               ------- Useful Docker Aliases --------                                #
#                                                                                     #
#     # Installation :                                                                #
#     copy/paste these lines into your .bashrc or .zshrc file or just                 #
#     type the following in your current shell to try it out:                         #
#     wget -O - https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/d84ef1741c59e7ab07fb055a70df1830584c6c18/docker-aliases.sh | bash
#                                                                                     #
#     # Usage:                                                                        #
#     daws <svc> <cmd> <opts> : aws cli in docker with <svc> <cmd> <opts>             #
#     dc             : docker compose                                                 #
#     dcu            : docker compose up                                              #
#     dcub           : docker compose up --build --force-recreate --remove-orphans -V #
#     dcd            : docker compose down                                            #
#     dcdr           : docker compose down --rmi all --remove-orphans -v              #
#     dcr            : docker compose run                                             #
#     dc-reboot      : docker compose stop && docker compose up --build -d            #
#     dex <container>: execute a bash shell inside the RUNNING <container>            #
#     di <container> : docker inspect <container>                                     #
#     dim            : docker images                                                  #
#     dip            : IP addresses of all running containers                         #
#     dl <container> : docker logs -f <container>                                     #
#     dnames         : names of all running containers                                #
#     dps            : docker ps                                                      #
#     dpsa           : docker ps -a                                                   #
#     drmc           : remove all exited containers                                   #
#     drmid          : remove all dangling images                                     #
#     drun <image>   : execute a bash shell in NEW container from <image>             #
#     dsp            : docker system prune --all                                      #
#     dsr <container>: stop then remove <container>                                   #
#     dsrf           : docker system prune --all --force --volumes                    #
#                                                                                     #
#######################################################################################

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

alias dexec='docker exec -it'
alias dexecroot='docker exec -u root -it'
alias dinspect='docker inspect'
alias dlogs='docker logs'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drun="docker run "
alias dstop="docker stop"
alias drmc="docker rm $(docker ps --all -q -f status=exited)"
alias dim="docker images"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dsp="docker system prune --all"
alias dsrf="docker system prune --all --force --volumes"
alias daws=d-aws-cli-fn
alias dc="docker compose"
alias dcu="docker compose up"
alias dcub="docker compose up --build --force-recreate --remove-orphans -V"
alias dcd="docker compose down"
alias dcdr="docker compose down --rmi all --remove-orphans -v"
alias dc-reboot="docker compose stop && docker compose up --build -d"
alias dc-stop="docker compose stop"