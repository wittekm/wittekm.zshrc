DD_REPO_ROOT="/Users/${USER}/dd"
DD_SOURCE="${DD_REPO_ROOT}/dd-source"

alias rap="cd ${DD_SOURCE}/domains/compliance/apps/risk-and-priority"
alias dd="cd ${DD_REPO_ROOT}"
alias ciem="cd ${DD_SOURCE}/domains/cloud-security-platform/ciem/"

# https://datadoghq.atlassian.net/wiki/spaces/ENG/pages/2348189629/Maven+Too+many+open+files+during+build
ulimit -n 32768

export PATH="${PATH}:${HOME}/go/bin"

# used for rapid
#eval "$(direnv hook zsh)"

export WS="workspace-max-wittek"
