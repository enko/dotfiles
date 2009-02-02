#! /bin/zsh

function initgpgagent() {
    zshrc_load_status 'Loading gpg-agent'
    if gpg-agent --use-standard-socket --enable-ssh-support 2>/dev/null ; then
        local gpg_sockpath=~/.gnupg/S.gpg-agent
        local gpg_agent_pid="`ps h -o pid -C gpg-agent | xargs`"
        export GPG_AGENT_INFO="${gpg_sockpath}:${gpg_agent_pid}:1"
	export SSH_AUTH_SOCK="~/.gnupg/S.gpg-agent.ssh"
	export SSH_AGENT_PID="`ps h -o pid -C gpg-agent | xargs`"
    else
        eval `gpg-agent --use-standard-socket --daemon --enable-ssh-support --sh 2>/dev/null 1>/dev/null`
	zshrc_load_status 'Launching gpg-agent'
    fi
}

function getrandwp() {
    zmodload zsh/mathfunc
    WP=(${(f)"$(/bin/ls ~/.bgs)"})
    COUNT=(${(f)"$(/bin/ls ~/.bgs|wc -w)"})
    INDEX=$(( (rand48()*$COUNT)+1 ))
    return $WP[$INDEX];
}

initgpgagent

if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    # if not found, launch a new one
    eval `DISPLAY=:0.0 dbus-launch --sh-syntax --exit-with-session`
fi
echo $DBUS_SESSION_BUS_ADDRESS > $HOME/.dbus.addr



PATH="/usr/local/bin:/usr/bin:/bin:/usr/games/bin:/sbin:/usr/sbin:/usr/kde/4.0/bin"
export PATH="/home/enko/.local/bin:$PATH"
export LANG="de_DE.UTF-8"
export BROWSER="/usr/bin/firefox"
FONT="-*-terminus-medium-*-*-*-22-*-*-*-*-*-iso8859-1"
xset +dpms
xset dpms 0 0 60
xhost +
xcompmgr -n &
setxkbmap de neo
zmodload zsh/mathfunc
WP=(${(f)"$(/bin/ls ~/.bgs)"})
COUNT=(${(f)"$(/bin/ls ~/.bgs|wc -w)"})
INDEX=$(( (rand48()*$COUNT)+1 ))
BG=$WP[$INDEX];
feh --bg-scale ~/.bgs/$BG
unclutter -idle 2 &
stalonetray -i 19 --max-width 120 --icon-gravity E --geometry 120x19-10+0 -bg '#000000' --sticky --skip-taskbar &
#emacsclient -c &
exec /usr/bin/xmonad

