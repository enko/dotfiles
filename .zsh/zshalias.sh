#! /bin/zsh -f

zshrc_load_status 'Aliases'
alias ls='ls -b -CF --color=auto' # do we have GNU ls with color-support?
alias l="ls -lh"
alias scp="rsync --partial --progress --rsh=ssh"
alias _jabber="screen -c ~/.startmcabber -S jabber"
alias startemacs="screen -c ~/.screenrcemacs -dmS emacs"
alias e="emacsclient -t -c"
alias x="xmms2"
alias -g G=' | grep'
alias -g L=' | less'
alias -g H=' | head'
alias -g T=' | tail'
alias -s ogg='mplayer'
alias -s mp3='mplayer'
alias -s mp4='mplayer'
alias -s avi='mplayer'
alias -s mkv='mplayer'
alias -s py='python'

function startx() {
    screen -c ~/.screenrcx -dmS x
    clear
    logout
}
