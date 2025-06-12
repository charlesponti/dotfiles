#!/usr/bin/env bash
# Docker utilities and aliases

#=======================================================================
# DOCKER ENVIRONMENT
#=======================================================================

export DOCKER_VOLUMES=$HOME/.docker/volumes

#=======================================================================
# DOCKER INSPECTION FUNCTIONS
#=======================================================================

# Get names of all running containers
dnames-fn() {
  echo "📦 Names of all running containers:"
  for ID in $(docker ps | awk '{print $1}' | grep -v 'CONTAINER'); do
    docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
  done
}

# Get IP addresses of all named running containers
dip-fn() {
  echo "🌐 IP addresses of all named running containers:"
  for DOC in $(dnames-fn | tail -n +2); do
    IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC")
    OUT+=$DOC'\t'$IP'\n'
  done
  echo -e $OUT | column -t
  unset OUT
}

#=======================================================================
# DOCKER MANAGEMENT FUNCTIONS
#=======================================================================

# Stop and remove container in one command
dsr() {
  if [ -z "$1" ]; then
    echo "Usage: dsr <container_name_or_id>"
    return 1
  fi
  docker stop "$1" && docker rm "$1"
  echo "✅ Container $1 stopped and removed"
}

# Remove all dangling images
drm-dangling() {
  echo "🧹 Removing dangling images..."
  local imgs=$(docker images -q -f dangling=true)
  if [ ! -z "$imgs" ]; then
    docker rmi $imgs
    echo "✅ Dangling images removed"
  else
    echo "ℹ️  No dangling images found"
  fi
}

# Get container ID by label
dlab() {
  if [ -z "$1" ]; then
    echo "Usage: dlab <label>"
    return 1
  fi
  docker ps --filter="label=$1" --format="{{.ID}}"
}

#=======================================================================
# DOCKER ALIASES
#=======================================================================

# Core Docker commands
alias d="docker"
alias dim="docker images"
alias dinspect='docker inspect'
alias dlogs='docker logs'
alias dexec='docker exec -it'
alias dexecroot='docker exec -u root -it'

# Docker Compose aliases
alias dc="docker compose"
alias dc-u="docker compose up"
alias dc-ub="docker compose up --build"
alias dc-ubr="docker compose up --build --force-recreate --remove-orphans -V"
alias dc-d="docker compose down"
alias dc-dr="docker compose down --rmi all --remove-orphans -v"
alias dc-stop="docker compose stop"
alias dc-reboot="docker compose stop && docker compose up -d"

#=======================================================================
# DOCKER UTILITY FUNCTIONS
#=======================================================================

# Show all containers with useful information
dps() {
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Show disk usage by Docker
ddiskusage() {
  echo "💾 Docker disk usage:"
  docker system df
}

# Clean up Docker system
dcleanup() {
  echo "🧹 Cleaning up Docker system..."
  docker system prune -f
  echo "✅ Docker cleanup complete"
}

# Remove all stopped containers
drm-stopped() {
  echo "🗑️  Removing all stopped containers..."
  docker container prune -f
  echo "✅ Stopped containers removed"
}

# Remove all unused images
drm-unused() {
  echo "🗑️  Removing unused images..."
  docker image prune -f
  echo "✅ Unused images removed"
}

# Complete Docker cleanup (destructive!)
dcleanall() {
  echo "⚠️  WARNING: This will remove ALL unused Docker data!"
  read -p "Are you sure? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker system prune -a -f --volumes
    echo "✅ Complete Docker cleanup finished"
  else
    echo "❌ Cleanup cancelled"
  fi
}

# Quick container stats
dstats() {
  docker stats --no-stream
}
alias dps='docker ps'
alias dps="docker ps"
alias dpsa='docker ps -a'
alias dpsa="docker ps -a"
alias drmc="docker rm $(docker ps --all -q -f status=exited)"
alias drun="docker run "
alias ds-p="docker system prune --all"
alias ds-rf="docker system prune --all --force --volumes"
alias dstop="docker stop"