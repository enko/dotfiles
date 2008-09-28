#! /bin/zsh -f

zshrc_load_status 'screen stuff'

export PROMPT_CHAR=":"
# ~/.zshrc
# if using GNU screen, let the zsh tell screen what the title and hardstatus
# of the tab window should be.
if [[ $TERM == "screen" ]]; then
  PS1="%{$fg[red]%}%n@%M \$ %{$reset_color%}"
  # use the current user as the prefix of the current tab title (since that's
  # fairly important, and I change it fairly often)
  TAB_TITLE_PREFIX='"${USER}$PROMPT_CHAR"'
  # when at the shell prompt, show a truncated version of the current path (with
  # standard ~ replacement) as the rest of the title.
  TAB_TITLE_PROMPT='`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/;s/\/..*\//\/...\//"`'
  # when running a command, show the title of the command as the rest of the
  # title (truncate to drop the path to the command)
  TAB_TITLE_EXEC='$cmd[1]:t'
 
  # use the current path (with standard ~ replacement) in square brackets as the
  # prefix of the tab window hardstatus.
  TAB_HARDSTATUS_PREFIX='"[`echo $PWD | sed "s/^\/Users\//~/;s/^~$USER/~/"`] "'
  # when at the shell prompt, use the shell name (truncated to remove the path to
  # the shell) as the rest of the title
  TAB_HARDSTATUS_PROMPT='$SHELL:t'
  # when running a command, show the command name and arguments as the rest of
  # the title
  TAB_HARDSTATUS_EXEC='$cmd'
 
  # tell GNU screen what the tab window title ($1) and the hardstatus($2) should be
  function screen_set()
  {  
    #  set the tab window title (%t) for screen
    print -nR $'\033k'$1$'\033'\\\

    # set hardstatus of tab window (%h) for screen
    print -nR $'\033]0;'$2$'\a'
  }
  # called by zsh before executing a command
  # called by zsh before showing the prompt
fi

