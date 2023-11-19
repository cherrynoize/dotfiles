#
# ~/.bashrc
#

# List of files to source
declare -a sources=(
  "/etc/bash.bashrc"
  ".bash_aliases"
)

# Source each file if found
for f in "${sources[@]}"; do
  [ -f "$f" ] && . "$f"
done

# Colors for ls
LS_COLORS=$LS_COLORS:'ow=1;30;47:di=1;33:fi=1;36:ln=1;5:'; export LS_COLORS

# Looks for binary in packages (when command not found)
. /usr/share/doc/pkgfile/command-not-found.bash

# Autochange directory when entering a path
shopt -s autocd

# Do not overwrite files with stdout.
# Manually override noclobber option with
# $ echo "output" >| file.txt
#set -o noclobber

# Vi editing mode
set -o vi

# Bash git prompt
git_prompt="$HOME/.config/bash-git-prompt/gitprompt.sh"
if [ -f "$git_prompt" ]; then
  GIT_PROMPT_ONLY_IN_REPO=1
  . "$git_prompt"
fi

# Run fish if not child of fish already and if not run with bash -c for instance.
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]; then
  exec fish
fi
