# Created by newuser for 4.3.2

PATH="/opt/java/bin:/usr/local/bin:/usr/bin:/bin:/usr/games/bin:/sbin:/usr/sbin:/usr/kde/svn/bin:/usr/kde/3.5/bin"
export PATH="$HOME/.local/bin:$PATH"

ZSHDIR="$HOME"

function zshrc_load_status () {
  # \e[0K is clear to right
  echo -n "\r.zshrc load: $* ... \e[0K"
}



source $ZSHDIR/.zsh/zshopts.sh

source $ZSHDIR/.zsh/zshfuncs.sh

source $ZSHDIR/.zsh/zshalias.sh

source $ZSHDIR/.zsh/zshkey.sh

source $ZSHDIR/.zsh/zshscreen.sh

source $ZSHDIR/.zsh/delete-to.sh

if [[ $UID -gt 0 ]]; then
     initxmms2
fi;

initgpgagent

echo -n "\r"

fortune

