# ---------------------------------------- #
# ------------------ Git ----------------- #
# ---------------------------------------- #

if (( $+commands[hub] )); then                             # https://github.com/github/hub
    alias git="hub"                                           
    alias g="hub"
    alias gcm="hub commit -m "
    alias gcl="hub clone "
else
    alias g="git"
    alias gcm="git commit -m "
    alias gcl="git clone"
fi
alias giturl="git remote show origin"
alias repo_add="mr register"
alias repo_update="mr update"                              # https://myrepos.branchable.com/

