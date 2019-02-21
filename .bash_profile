#
# ~/.bash_profile
#

# Auto start dropbox
ps ax | grep -q 'dropbox[d]' || ~/.dropbox-dist/dropboxd

[[ -f ~/.bashrc ]] && . ~/.bashrc

