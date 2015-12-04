#!/bin/zsh
osascript -e 'activate application "iTerm"' -e 'tell application "System Events" to keystroke "t" using command down' -e "tell application \"iTerm\" to tell session -1 of current terminal to write text \"$@\""
