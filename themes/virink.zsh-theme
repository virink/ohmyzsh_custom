# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}On%{$reset_color%} %{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

local exit_code="%(?,,%{$fg[red]%}LEC:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# ➜ PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE LEC:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x LEC:0
# $

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) \
%(#,%{$bg[red]%}%{$fg[white]%} %n %{$reset_color%},%{$fg[magenta]%}%n) \
%{$fg[white]%}@ \
%{$fg[magenta]%}%m \
%{$fg[yellow]%}In \
%{$terminfo[bold]$fg[cyan]%}%~%{$reset_color%} \
${git_info} \
$exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
