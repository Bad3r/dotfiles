
# ---------------------------------------- #
# ---------------- Docker ---------------- #
# ---------------------------------------- #

alias lzd="lazydocker"

# Containers
alias dstart="sudo systemctl restart docker.service && systemctl status docker.service"
alias dps="docker ps"
alias dpsl='docker ps -l $*'
alias drm='docker rm'
alias dexec='docker exec'
alias dlog='docker logs'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" $*'
alias dstop_all='docker stop $* $(docker ps -q -f "status=running")'
alias drm_stopped='docker rm $* $(docker ps -q -f "status=exited")'
alias drmv_stopped='docker rm -v $* $(docker ps -q -f "status=exited")'
alias drm_all='docker rm $* $(docker ps -a -q)'
alias drmv_all='docker rm -v $* $(docker ps -a -q)'
alias dprune="docker system prune -a --volumes"


# Docker-compose
alias dcup="docker-compose up"
alias dcupb="docker-compose up --build"

# Volumes
alias dvls='docker volume ls $*'
alias dvrm_all='docker volume rm $(docker volume ls -q)'
alias dvrm_dang='docker volume rm $(docker volume ls -q -f "dangling=true")'
