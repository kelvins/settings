# Set colors
DEFAULT_BACKGROUND="240"
LIGHT_GRAY="250"
LIGHT_BLUE="038"
LIGHT_GREEN="042"
LIGHT_YELLOW="192"
LIGHT_RED="204"

# Set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Set the git_prompt_status text
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="!"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_RENAMED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"

# Config files
KUBE_CONFIG=~/.kube/config
GCLOUD_CONFIG=~/.config/gcloud/configurations/config_default

########## Helper Functions ##########

start_text() {
    echo "$BG[$DEFAULT_BACKGROUND]$FG[$FOREGROUND]"
}

end_text() {
    echo "%{$reset_color%}"
}

separator() {
    echo "$(start_text) | $(end_text)"
}

space() {
    echo "$(start_text) $(end_text)"
}

############### Prompt ###############

username() {
    FOREGROUND=$LIGHT_BLUE
    echo "$(start_text)%n$(end_text)"
}

directory() {
    FOREGROUND=$LIGHT_GREEN
    echo "$(start_text)%0~$(end_text)"
}

git_status() {
    if [[ $(git_prompt_status) ]]; then
        FOREGROUND=$LIGHT_RED
        echo "$(space)$(start_text)($(git_prompt_status))$(end_text)" | tr -s '!'
    fi
}

git_prompt() {
    FOREGROUND=$LIGHT_YELLOW
    branch=$(git rev-parse --abbrev-ref HEAD)
    echo "$(start_text)$branch$(git_status)$(end_text)"
}

colorful_tail() {
    echo "$BG[240] $BG[239] $BG[238] $BG[237] $BG[236] $(end_text)"
}

prompt() {
    content="\n╭─$(space)$(username)$(separator)$(directory)"
    if [[ $(git_prompt_info) ]];then
        content="${content}$(separator)$(git_prompt)"
    fi
    content="${content}$(colorful_tail)\n╰─ "
    echo -e "${content}"
}

############ Right Prompt ############

current_time() {
    FOREGROUND=$LIGHT_GRAY
    echo "$(start_text)%*$(end_text)"
}

kubectl_context() {
    FOREGROUND=$LIGHT_RED
    context=$(awk '/current-context/{print $2}' $KUBE_CONFIG)
    echo "$(start_text)$context$(end_text)"
}

gcloud_project() {
    FOREGROUND=$LIGHT_YELLOW
    project=$(awk '/project/{print $3}' $GCLOUD_CONFIG)
    echo "$(start_text)$project$(end_text)"
}

virtual_env() {
    FOREGROUND=$LIGHT_YELLOW
    echo "$(start_text)`basename \"$VIRTUAL_ENV\"`$(end_text)"
}

return_code() {
    echo "$(start_text)%(?.$FG[$LIGHT_GREEN]ok.$FG[$LIGHT_RED]fuck)$(end_text)"
}

inverse_colorful_tail() {
    echo "$BG[236] $BG[237] $BG[238] $BG[239] $BG[240] $(end_text)"
}

right_prompt() {
    local _lineup=$'\e[1A'
    local _linedown=$'\e[1B'
    content="%{$_lineup%}$(inverse_colorful_tail)$(return_code)"
    if [ $VIRTUAL_ENV ]; then
        content="${content}$(separator)$(virtual_env)"
    fi
    if [[ -a $GCLOUD_CONFIG ]]; then
        content="${content}$(separator)$(gcloud_project)"
    fi
    if [[ -a $KUBE_CONFIG ]]; then
        content="${content}$(separator)$(kubectl_context)"
    fi
    echo "${content}$(separator)$(current_time)$(space)%{$_linedown%}"
}

VIRTUAL_ENV_DISABLE_PROMPT=1
PROMPT='$(prompt)'
RPROMPT='$(right_prompt)'
