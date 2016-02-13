export EDITOR="vim"
export VISUAL="vim"

antigenSettings()
{
    source "$HOME/.antigen/antigen.zsh"
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle git
    antigen bundle history
    antigen bundle zsh-users/zsh-completions src
    antigen theme robbyrussell/oh-my-zsh themes/apple
    
    if [[ $CURRENT_OS == 'OS X' ]]; then
        antigen bundle brew
        antigen bundle brew-cask
        antigen bundle osx
    fi
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


gitSettings()
{
    autoload -Uz compinit && compinit
}
gitSettings


shellSettings()
{
    alias ls='ls -G'
    bindkey '^A' beginning-of-line
    bindkey '^E' end-of-line
}
shellSettings


generalAliases()
{
    alias gvim='mvim' # macvim
}
generalAliases


dropboxSpecificSettings()
{
    echo "Dropbox MBP"

    alias ss='cd ~/src/server'
    alias vssh='ssh dbdev'
    alias v='ss && vagrant'
    alias vs='ss && vssh'

    alias ba='ssh -A bastion.dropboxer.net'

    #preisntalled w puppet
    #alias cs="~/src/server/codesearch/codesearch_cli.py"
    
    # Dropbox API REPL - https://sites.google.com/a/dropbox.com/api-team/api-v2
    alias dbrepl="~/src/dropbox-api-v2-repl/repl.sh"

    function typy() {
      # typecheck your python through dark magic [mypy]
      cd ~/src/server
      ./ci/mypy-run
    }

    function lint() {
      cd ~/src/server
      typy()
      arc lint
    }
    
    # https://paper.dropbox.com/doc/Paper-VM-VagrantChef-FAQ-3ZnBbjYMwjk
    function cd() {
      builtin cd "$@"
      if [[ $PWD =~ $HOME/src/composer ]]; then
        export VAGRANT_HOME=$HOME/src/composer/.vagrant
      else
        unset VAGRANT_HOME
      fi
    }
}
case "$HOST" in
    *dropbox.com*) 
        dropboxSpecificSettings
    ;;
    *) 
        # default
    ;;
esac
