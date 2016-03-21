export EDITOR="vim"
export VISUAL="vim"
export WITTEKM_ZSHRC_PATH="/Users/$USER/etc/wittekm.zshrc/wittekm.zshrc"

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
    alias ezshrc='gvim -f $WITTEKM_ZSHRC_PATH; source $WITTEKM_ZSHRC_PATH'
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
    
    #alias vssh='ssh dbdev'
    #alias v='ss && vagrant'
    #alias vs='ss && vssh'
    alias vs='ssh ec-server'
    alias fw='ec stop fw_rsyncer && ec start fw_rsyncer'
    alias vup='ec start server'
    alias vdown='ec stop server'

    alias ba='ssh -A bastion.dropboxer.net'

    # Dropbox API REPL - https://sites.google.com/a/dropbox.com/api-team/api-v2
    alias dbrepl="~/src/dropbox-api-v2-repl/repl.sh"

    alias babelgen="vs -- 'cd /srv/nfs-server && api/generator/run-babel-codegen'"

    function typy() {
      # typecheck your python through dark magic [mypy]
      cd ~/src/server;
      ./ci/mypy-run;
    }

    function lint() {
      cd ~/src/server;
      typy;
      arc lint;
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
    *wimax-loaner*) 
        dropboxSpecificSettings
    ;;
    *) 
        # default
    ;;
esac
