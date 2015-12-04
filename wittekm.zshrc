export EDITOR="vim"
export VISUAL="vim"

antigenSettings()
{
    source "$HOME/.antigen/antigen.zsh"
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle git
    antigen bundle history
    antigen theme robbyrussell/oh-my-zsh themes/apple
}
antigenSettings

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

shellSettings()
{
    alias ls='ls -G'
}
shellSettings

dropboxSpecificSettings()
{
    echo "Dropbox MBP"

    alias ss='cd ~/src/server'
    alias vssh='ssh dbdev'
    alias v='ss && vagrant'
    alias vs='ss && vssh'

    alias ba='ssh -A bastion.dropboxer.net'

    alias cs="~/src/server/codesearch/codesearch_cli.py"
}

generalAliases()
{
    alias gvim='mvim' # macvim
}
generalAliases

case "$HOST" in
    *dropbox.com*) 
        dropboxSpecificSettings
    ;;
    *) 
        # default
    ;;
esac
