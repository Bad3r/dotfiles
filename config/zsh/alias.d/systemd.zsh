
# systemctl aliases
user_commands=(
  cat
  get-default
  help
  is-active
  is-enabled
  is-failed
  is-system-running
  list-dependencies
  list-jobs
  list-sockets
  list-timers
  list-unit-files
  list-units
  show
  show-environment
  status
)

sudo_commands=(
  add-requires
  add-wants
  cancel
  daemon-reexec
  daemon-reload
  default
  disable
  edit
  emergency
  enable
  halt
  import-environment
  isolate
  kexec
  kill
  link
  list-machines
  load
  mask
  preset
  preset-all
  reenable
  reload
  reload-or-restart
  reset-failed
  rescue
  restart
  revert
  set-default
  set-environment
  set-property
  start
  stop
  switch-root
  try-reload-or-restart
  try-restart
  unmask
  unset-environment
)

power_commands=(
  hibernate
  hybrid-sleep
  poweroff
  reboot
  suspend
)

for c in $user_commands; do
  alias "sc-$c"="systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $sudo_commands; do
  alias "sc-$c"="sudo systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $power_commands; do
  alias "sc-$c"="systemctl $c"
done

unset c user_commands sudo_commands power_commands


# --now commands
alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

alias scu-enable-now="scu-enable --now"
alias scu-disable-now="scu-disable --now"
alias scu-mask-now="scu-mask --now"


ZSH_THEME_SYSTEMD_PROMPT_PREFIX='{'
ZSH_THEME_SYSTEMD_PROMPT_SUFFIX="\n"
ZSH_THEME_SYSTEMD_PROMPT_ACTIVE="✔"
ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE="✖"

function systemd-status {
  # given one or more services; return if they are active in json format
  # example:
  # ❯ systemd_status bluetooth.service docker.service [...]
  # [{
  #     "service": "bluetooth.service",
  #     "is-active": "✖"
  #   }, {
  #     "service": "docker.service",
  #     "is-active": "✔"
  #   }, {
  #     "service": "canberra-system-shutdown-reboot.service",
  #     "is-active": "✖"
  # }]
  # 
  printf "%c" "["
  local unit
  local count=0
  for unit in "$@"; do
    (( count++ ))
    printf "%c\n    " "{"
    printf "\"service\": \"%s\",\n" "$unit"

    if systemctl is-active "$unit" &>/dev/null; then
      printf "    \"is-active\": \"%s\"\n" "$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE"
    else
      printf "    \"is-active\": \"%s\"\n" "$ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE"
    fi

    if [[ "$count" -lt "$#" ]]; then
      printf "  %s" "}, "
    else
      printf "%c" "}"
    fi
  done
    printf "%c" "]"
}