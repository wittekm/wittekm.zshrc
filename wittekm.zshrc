export EDITOR="vim"
export VISUAL="vim"
export WITTEKM_ZSHRC_DIR="/Users/$USER/etc/wittekm.zshrc/"
export WITTEKM_ZSHRC_PATH="$WITTEKM_ZSHRC_DIR/wittekm.zshrc"

antigenSettings()
{
    source "$HOME/.antigen/antigen.zsh"
    antigen bundle zsh-users/zsh-syntax-highlighting
    # slow
    # antigen bundle git
    antigen bundle history
    antigen bundle zsh-users/zsh-completions src
    antigen theme robbyrussell/oh-my-zsh themes/apple
    
    if [[ $CURRENT_OS == 'OS X' ]]; then
        antigen bundle brew
        antigen bundle brew-cask
        antigen bundle osx
    fi
    antigen apply
}
#antigenSettings


historySettings()
{
    HISTFILE=~/.zhistory
    HISTSIZE=SAVEHIST=10000
    setopt SHARE_HISTORY        # shared history between session
    setopt APPEND_HISTORY       # adds history
    setopt INC_APPEND_HISTORY   # adds history incrementally and share it across sessions
    setopt HIST_IGNORE_ALL_DUPS # don't record dupes in history
    setopt HIST_REDUCE_BLANKS
}
historySettings


gitSettings()
{
    autoload -Uz compinit && compinit
}
gitSettings


shellSettings()
{
    alias ezshrc='gvim -f $WITTEKM_ZSHRC_PATH; source $WITTEKM_ZSHRC_PATH'
    alias ls='ls -G'
    bindkey '^A' beginning-of-line
    bindkey '^E' end-of-line
}
shellSettings


generalAliases()
{
    alias gvim='open -a MacVim $@'
    alias osx_notify='python $WITTEKM_ZSHRC_DIR/osx_notify.py $@'

    #cd into directory containing
    alias cdc='cd `dirname "$@"`'
}
generalAliases


case "$HOST" in
    *GW9LYYY*)
        source "${WITTEKM_ZSHRC_DIR}/datadog.zshrc"
    ;;
    *) 
        # default
    ;;
esac

export PATH="${PATH}:${WITTEKM_ZSHRC_DIR}/bin"