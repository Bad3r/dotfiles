# ---------------------------------------------------------------
# Function: sshpt
# Description:
#   Connects to a remote SSH server with optimized settings.
#   Automatically selects bash if available.
#
# Usage:
#   sshpt <username>@<hostname>
#
# Parameters:
#   <username>@hostname - SSH username and Domain name or IP address of the remote host
#
# SSH Options:
#   -t
#     Forces pseudo-terminal allocation, enabling interactive sessions.
#
#   ControlMaster=auto
#     Enables SSH connection multiplexing, allowing multiple SSH sessions
#     to reuse a single TCP connection for efficiency.
#
#   ControlPath=~/.ssh/ctrl-%C
#     Specifies the path for the control socket used in connection multiplexing.
#     %C is a token that ensures a unique socket per host.
#
#   ControlPersist=yes
#     Keeps the master connection open in the background even after the initial
#     session has closed, facilitating faster reconnections.
#
#   UserKnownHostsFile=/dev/null
#     Disables updating the ~/.ssh/known_hosts file, preventing SSH from
#     storing host key information.
#
#   StrictHostKeyChecking=no
#     Disables strict host key checking, allowing SSH to automatically add
#     new hosts to the known_hosts file without prompting.
#
# Remote Command Execution:
#   - Sets TERM to xterm-256color for backspace & 256-color support.
# ---------------------------------------------------------------
function sshpt() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: sshpt <username>@<hostname>"
    return 1
  fi

  ssh "$1" -t \
    -o ControlMaster=auto \
    -o ControlPath=~/.ssh/ctrl-%C \
    -o ControlPersist=yes \
    -o "UserKnownHostsFile=/dev/null" \
    -o "StrictHostKeyChecking=no" \
    "export TERM=xterm-256color; \
     exec bash;"
}
