#! /bin/zsh -f

function set_my_prompt() {
    local usersize=${#${(%):-%n}}
    local hostsize=${#${(%):-%M}}
    local pwdsize=${#${(%):-%~}}

    typeset -A features
    local featuremap=""

    # {{{ Battery Stuff
    local batstate=""
    if [[ $HOST == "kaos" ]]; then 
	batstate=`/home/enko/.local/bin/battery`
	/home/enko/.local/bin/battery > /dev/null
	if [[ $? -eq 1 ]]; then
	    if [[ $batstate -eq 0 ]]; then
		features["bat_raw"]="─[NO BAT]"
		batstate="%{$fg_bold[green]%}NO BAT%{$reset_color%}"
	    else
		features["bat_raw"]="─[AC $batstate%]"
		batstate="%{$fg_bold[green]%}AC $batstate%%%{$reset_color%}"
	    fi
	else
	    if [[ $batstate -lt 16 ]]; then
		features["bat_raw"]="─[$batstate]"
		batstate="%{$fg_bold[red]%}$batstate%%%{$reset_color%}"
	    elif [[ $batstate -gt 70 ]]; then
		features["bat_raw"]="─[$batstate]"
		batstate="%{$fg_bold[green]%}$batstate%%%{$reset_color%}"
	    else
		features["bat_raw"]="─[$batstate]"
		batstate="%{$fg_bold[yellow]%}$batstate%%%{$reset_color%}"
	    fi

	fi
	features["bat"]="─[$batstate]"
	featuremap="$featuremap bat"
    fi
    # }}} Battery Stuff
    # {{{ Load stuff

    load=($(</proc/loadavg))
    load1=$load[1]
    load5=$load[2]
    load15=$load[3]
    features["load_raw"]="─[$load1 $load5 $load15]"
    if [[ $load1 -lt 1 ]]; then
	load1="%{$fg_bold[green]%}$load1%{$reset_color%}"
    elif [[ $load1 -gt 2 ]]; then
	load1="%{$fg_bold[red]%}$load1%{$reset_color%}"
    elif [[ $load1 -ge 1 ]]; then
	load1="%{$fg_bold[yellow]%}$load1%{$reset_color%}"
    fi

    if [[ $load5 -lt 1 ]]; then
	load5="%{$fg_bold[green]%}$load5%{$reset_color%}"
    elif [[ $load5 -gt 2 ]]; then
	load5="%{$fg_bold[red]%}$load5%{$reset_color%}"
    elif [[ $load5 -ge 1 ]]; then
	load5="%{$fg_bold[yellow]%}$load5%{$reset_color%}"
    fi

    if [[ $load15 -lt 1 ]]; then
	load15="%{$fg_bold[green]%}$load15%{$reset_color%}"
    elif [[ $load15 -gt 2 ]]; then
	load15="%{$fg_bold[red]%}$load15%{$reset_color%}"
    elif [[ $load15 -ge 1 ]]; then
	load15="%{$fg_bold[yellow]%}$load15%{$reset_color%}"
    fi
    features["load"]="─[$load1 $load5 $load15]"
    featuremap="$featuremap load"


    # }}} Load stuff

    # {{{ User stuff
    if [[ $UID -gt 0 ]]; then
	user_color="$fg_bold[green]"
    else
	user_color="$fg_bold[red]"
    fi
    # }}} User stuff

    # {{{ Path stuff
    # outside of /home do the path red
    pathcomp=${(ps::)${(%):-%~}}
    if [[ "$pathcomp[0]" != "~" ]]; then
	echo $pathcomp[0]
	pathcolor="$fg_bold[red]"
    else
	pathcolor=""
    fi
    # }}} Path stuff

    # {{{ host stuff
    # different host different color
    if [[ $HOST == "kaos" ]]; then 
	hostcolor="$fg_bold[green]"
    fi

    # }}} host stuff

    # {{{ Temp stuff
    if [[ $HOST == "kaos" ]]; then 
	temp1=${(@)$(</proc/acpi/thermal_zone/THM0/temperature)[2]}
	temp2=${(@)$(</proc/acpi/thermal_zone/THM1/temperature)[2]}
	temperature=$(( ($temp1 + $temp2) / 2 ))
	features["temp_raw"]="─[$temperature°C]"
	if [[ $temperature -gt 80 ]]; then
	    temperature="%{$fg_bold[red]%}$temperature°C%{$reset_color%}"
	elif [[ $temperature -gt 60 ]]; then
	    temperature="%{$fg_bold[yellow]%}$temperature°C%{$reset_color%}"
	else
	    temperature="%{$fg_bold[green]%}$temperature°C%{$reset_color%}"
	fi
	features["temp"]="─[$temperature]"
	featuremap="$featuremap temp"
    fi
    # }}} Temp stuff

    # {{{ Wireless stuff
    if [[ $HOST == "kaos" ]]; then 
	typeset -a wlanoutput
	essid=""
	wlanoutput=(${(f)"$(iwconfig wlan0 2>&1)"})
	if [[ $wlanoutput[1] = (#b)*ESSID:\"([^\"]##)* ]]; then
			essid=$match[1]
	fi
	if [[ $essid == "" && $wlanoutput == "wlan0     No such device" ]]; then
	    essid="KILLSW"
	elif [[ $essid == "" ]]; then
	    essid="NO NET"
	fi
	features["essid_raw"]="─[$essid]"
	if [[ $essid == "KILLSW" || $essid == "NO NET" ]]; then
	    features["essid"]="─[$fg_bold[red]$essid$reset_color]"
	else
	    features["essid"]="─[$fg_bold[green]$essid$reset_color]"
	fi
	featuremap="$featuremap essid"

    fi

    # }}} Wireless stuff

    # lets calculate the fillwidth with the given features in the featuremap
    (( AVIABLEWIDTH = $COLUMNS - ( 12 + $usersize + $hostsize + ${#${mydate}} ) ))
    #replacechars="$reset_color$fg_bold$fg"
    for feat in ${(s: :)featuremap}; do	
	(( AVIABLEWIDTH = $AVIABLEWIDTH - ${#${features["${feat}_raw"]}}))
	# if a feature dont fit in the bar dont display it
	if [[ $AVIABLEWIDTH -le 0 ]]; then
	    (( AVIABLEWIDTH = $AVIABLEWIDTH + ${#${features["${feat}_raw"]}}))
	    featuremap=${featuremap//$feat/}
	    featuremap=${featuremap//  /}
	fi
    done
    PROMPTDATA=""

    for feat in ${(s: :)featuremap}; do
	PROMPTDATA="$PROMPTDATA"$features["$feat"]
    done

    mydate=`date +'%H:%M'`

    if [[ $pwdsize -gt 20 ]]; then
	((PWDLEN=20))
    fi

    FILLCHAR="─"
    MYPROMPT="$FILLCHAR"
    for ((i = 1; i < $AVIABLEWIDTH; i++ )); do 
	MYPROMPT="$MYPROMPT$FILLCHAR"
    done

    export PS1="┌──[%{$user_color%}%n%{$reset_color%}@%{$hostcolor%}%M%{$reset_color%}]${MYPROMPT}─[%{$mydate%}]$PROMPTDATA──┐
└(%{$pathcolor%}%$PWDLEN<...<%~%<<%{$reset_color%})─%(0?..%{$fg_bold[red]%}%?%{$reset_color%})─> "

}

function precmd() {
    set_my_prompt
    if [[ ($TERM == "rxvt") || ($TERM == "screen") ]]; then
	print -Pn "\e]0;%n@%m: %~\a"
    fi;
    if [[ $TERM == "screen" ]]; then
	eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_PROMPT"
	eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_PROMPT"
	screen_set $tab_title $tab_hardstatus
    fi
}


function initxmms2() {
    zshrc_load_status 'Loading XMMS2'
    if [[ -e ~/daten/.cryptome ]]; then
	xmms2 stats &>/dev/null
        # here should be better checking, there could be other failure
        # states and I should check them all and handle properly...
	retval=$?
	if [[ $retval -gt 0 ]]; then
	    if [[ -e ~/.config/xmms2/clients/xmms2-scrobbler/lock ]]; then
		rm ~/.config/xmms2/clients/xmms2-scrobbler/lock
	    fi
	    xmms2-launcher > /dev/null
	fi
    fi
}

function initgpgagent() {
    zshrc_load_status 'Loading gpg-agent'
    local gpg_agent_pid="`ps h -o pid -C gpg-agent | xargs`"
    if [[ $gpg_agent_pid != "" ]]; then
	local gpg_sockpath="$HOME/.gnupg/S.gpg-agent"
	export GPG_AGENT_INFO="${gpg_sockpath}:${gpg_agent_pid}:1"
	export SSH_AGENT_PID="`ps h -o pid -C gpg-agent | xargs`"
	export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
    else
	if [[ -e $HOME/.gnupg/S.gpg-agent ]]; then  
	    rm $HOME/.gnupg/S.gpg-agent
	fi
	if [[ -e $HOME/.gnupg/S.gpg-agent.ssh ]]; then
	    rm $HOME/.gnupg/S.gpg-agent.ssh
	fi
	eval `gpg-agent --use-standard-socket --daemon --enable-ssh-support --sh 2>/dev/null 1>/dev/null`
	zshrc_load_status 'Launching gpg-agent'
    fi
}

function initdbus() {
    if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
        # if not found, launch a new one
	eval `dbus-launch --sh-syntax`
    fi
}

function run() {
    $1 &
    disown
}

function preexec() {
    local -a cmd; cmd=(${(z)1}) # the command string
    if [[ ($TERM == "screen") || ($TERM == "rxvt") ]]; then
	print -Pn "\e]0;$cmd\a"
    fi
    if [[ $TERM == "screen" ]]; then
	eval "tab_title=$TAB_TITLE_PREFIX$TAB_TITLE_EXEC"
	eval "tab_hardstatus=$TAB_HARDSTATUS_PREFIX$TAB_HARDSTATUS_EXEC"
	screen_set $tab_title $tab_hardstatus    
    fi
}
