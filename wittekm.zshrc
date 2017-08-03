export EDITOR="vim"
export VISUAL="vim"
export WITTEKM_ZSHRC_DIR="/Users/$USER/etc/wittekm.zshrc/"
export WITTEKM_ZSHRC_PATH="$WITTEKM_ZSHRC_DIR/wittekm.zshrc"
export PYCHARM=/Users/wimax/Library/Application\ Support/JetBrains/Toolbox/apps/PyCharm-P/ch-1/171.3780.115/PyCharm\ 2017.1\ EAP.app 

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
    alias osx_notify='python $WITTEKM_ZSHRC_DIR/osx_notify.py $@'

    #cd into directory containing
    alias cdc='cd `dirname "$@"`'
}
generalAliases

devboxHelpers()
{
    DEVBOX_HOST=$USER-dbx
    SOURCE_ROOT_ON_DEVBOX='~/src/server-mirror'

    function d() {
        ssh $DEVBOX_HOST -t -- "cd $SOURCE_ROOT_ON_DEVBOX && echo \$PWD && $@"
    }
    
    function mbd() {
        TARGET=$1
        KEYWORD=$2
        mbzl develop $TARGET --test_arg="-k $KEYWORD"
    }
}
devboxHelpers

dropboxSpecificSettings()
{
    echo "Dropbox MBP"

    alias ss='cd ~/src/server'
    
    # Disenchanted with EC
    alias vs='ssh ec-server'
    alias fw='ec stop fw_rsyncer && ec start fw_rsyncer'
    alias vup='ec start server'
    alias vdown='ec stop server'

    # Dropbox API REPL - https://sites.google.com/a/dropbox.com/api-team/api-v2
    alias dbrepl="~/src/dropbox-api-v2-repl/repl.sh"

    function mypy-venv() {
        ~/src/server/.mypy/venv/bin/mypy --fast-parser $@
    }


    function typy() {
      # typecheck your python through dark magic [mypy]
      cd ~/src/server;
      ./ci/mypy-run $@;
    }

    function lint() {
      cd ~/src/server;
      typy;
      arc lint;
    }
    
    function selen() {
      ss;
      cd selenium-tests;
      ./selenium/bin/py.test $@
    }

    function mdbset() {
        if [[ $# -eq 0 ]]; then
            echo "Usage: mdbset group [[-+]group2 ...]"
            return 1
        fi

        ssh shelby mdbset $@
    }

    function msh() {
        if [[ $# -ne 1 ]]; then
            echo "Usage: msh group"
            return 1
        fi

        ssh $(mdbset "$1" | head -n 1)
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
