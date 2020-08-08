# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}♆ (%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[white]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"

ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}﹡"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[yellow]%}✚"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[yellow]%}✖"


local privileges="%{$fg_bold[green]%}➜"

local user_name="%(#,%{$bg[red]%}%{$fg[white]%}%n,%{$fg[magenta]%}%n)"

local machine_name="%{$fg[magenta]%}%m"

local user_at_machine="${user_name} %{$fg[white]%}@ ${machine_name}"

local relative_directory="$fg_bold[cyan]%}%~%{$reset_color%}"

local date_time="%{$fg_bold[blue]%}[%{$fg[yellow]%}%D{%Y-%m-%d %I:%M:%S}%{$fg_bold[blue]%}]"

local exit_code="%(?,,%{$fg[red]%}LEC:%?)"

local command="%{$fg_bold[red]%}$"

# Prompt format:
#
# ➜ PRIVILEGES USER@MACHINE DIRECTORY ♆ (BRANCH STATE) DATETIME LEC:LAST_EXIT_CODE
# $ COMMAND
#

PROMPT="${privileges} ${user_at_machine} ${relative_directory} ${git_info} ${date_time} ${exit_code}
${command} %{$reset_color%}"
