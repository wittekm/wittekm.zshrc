export EDITOR="vim"
export VISUAL="vim"

dropboxSpecificSettings()
{
    echo "Dropbox MBP"

    alias ss='cd ~/src/server'
    alias vssh='vagrant ssh'
    alias v='ss && vssh'
}

case "$HOST" in
    *dropbox.com*) 
        dropboxSpecificSettings
    ;;
    *) 
        # default
    ;;
esac
