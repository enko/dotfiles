#! /bin/zsh -f

zshrc_load_status 'Options'
setopt \
    APPENDHISTORY \
    AUTOCD \
    BEEP \
    EXTENDED_GLOB \
    COMPLETE_ALIASES \
    HIST_IGNORE_ALL_DUPS \
    HIST_IGNORE_DUPS \
    HIST_SAVE_NO_DUPS \
    HIST_REDUCE_BLANKS \
    HIST_EXPIRE_DUPS_FIRST \
    SHARE_HISTORY \
    AUTO_CD \
    EXTENDED_HISTORY

export XSESSION="gnome"
export LANG="de_DE.UTF-8"
export EDITOR="emacsclient -c -t --alternate-editor=nano"
export BROWSER="conkeror"
export PAGER="less"
export PALUDIS_OPTIONS="--log-level warning"
export XMMS_PATH="unix:///tmp/xmms-ipc-enko"
fpath=(~/.zsh/completion $fpath)

# completion system
if autoload -U compinit && compinit 2>/dev/null ; then
    compinit 2>/dev/null || print 'Notice: no compinit available :('
else
    print 'Notice: no compinit available :('
    function zstyle { }
    function compdef { }
fi

zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
zstyle ':completion:*:correct:*'       insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'       original true                       #
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select              # complete 'cd -<tab>' with menu
zstyle ':completion:*:expand:*'        tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:history-words'   list false                          #
zstyle ':completion:*:history-words'   menu yes                            # activate menu
zstyle ':completion:*:history-words'   remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'   stop yes                            #
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'         group 'yes'                         # separate matches into groups
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*'               menu select=5                       # if there are more than 5 options allow selecting from a menu
zstyle ':completion:*:messages'        format '%d'                         #
zstyle ':completion:*:options'         auto-description '%d'               #
zstyle ':completion:*:options'         description 'yes'                   # describe options in full
zstyle ':completion:*:processes'       command 'ps -au$USER'               # on processes completion complete all user processes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                 verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
zstyle ':completion:correct:'          prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'    # Ignore completion functions for commands you don't have:

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# caching
  [ -d $ZSHDIR/cache ] && zstyle ':completion:*' use-cache yes && \
                          zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# host completion /* add brackets as vim can't parse zsh's complex cmdlines 8-) {{{ */
  [ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
  [ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
    `hostname`
    "$_ssh_hosts[@]"
    "$_etc_hosts[@]"
    grml.org
    localhost
    )
zstyle ':completion:*:hosts' hosts $hosts

compdef _gnu_generic tail head feh cp mv df stow uname ipacsum fetchipac

setopt correct  # try to correct the spelling if possible
zstyle -e ':completion:*' completer '
        if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
          _last_try="$HISTNO$BUFFER$CURSOR"
          reply=(_complete _match _prefix _files)
        else
          if [[ $words[1] = (rm|mv) ]]; then
            reply=(_complete _files)
          else
            reply=(_oldlist _expand _complete _correct _approximate _files)
          fi
        fi'


autoload -U zed                  # use ZLE editor to edit a file or function

autoload -U colors
colors

for mod in complist deltochar mathfunc pcre ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done

# autoload zsh modules when they are referennced
for opt mod in a  stat    \
    a  zpty    \
    ap zprof   \
    ap math    \
    ap mapfile ; do
    zmodload -${opt} zsh/${mod} ${mod}
done ; unset opt mod

autoload -U insert-files && \
    zle -N insert-files && \
    bindkey "^Xf" insert-files # C-x-f




autoload -U compinit
compinit

zshrc_load_status 'History'

HISTFILE=~/.histfile
HISTSIZE=9000
SAVEHIST=9000


autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '%s:%b '
zstyle ':vcs_info:*' enable git cvs svn hg bzr
vcs_info
