#! /bin/zsh -f

zshrc_load_status 'Keybindings'
bindkey -e

bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey ' '   magic-space    # also do history expansion on space
bindkey '\ei' menu-complete  # menu completion via esc-i

# run command line as user root via sudo:
_sudo-command-line() {
    [[ $BUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
}
zle -N sudo-command-line _sudo-command-line
bindkey "^Os" sudo-command-line
