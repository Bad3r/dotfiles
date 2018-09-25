# Antigen plugin manager :

# antigen bundle github-user/repo --branch=develop
source /usr/share/zsh/share/antigen.zsh
#source /usr/share/zsh/scripts/antigen/antigen.zsh
antigen update
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle https://github.com/zsh-users/zsh-autosuggestions --branch=master
antigen bundle djui/alias-tips
#antigen bundle joel-porquet/zsh-dircolors-solarized.git
antigen apply

