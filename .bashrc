######################################################################
# PATH
export PATH="$PATH:~/bin"
export PATH="$PATH:~/bash_scripts"
export PATH=~/.npm-global/bin:$PATH

# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

##################################################################
# Setting defaults

export CLICOLOR=1
 
# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# Set the default editor to vim.
export EDITOR=vim

# set default text editor for SVN
export SVN_EDITOR=vim

# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups

# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend

# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
PROMPT_COMMAND='history -a'

##################################################################
# Alias Section

##### generic aslias #####

alias reload='source ~/.bash_profile'
alias editBash='code ~/.bashrc'

# Make some possibly destructive commands more interactive.
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ll='ls -lFG'
alias la='ls -lahFG'
alias ls='ls -FG'

# start a simple browser Sync session on current folder
alias staticSync='browser-sync start --files "css/*.css, js/*.js, *.html, **/*.html" --server --directory'
alias superStaticSync='browser-sync start --files "**/*" --server --directory'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .git folders.
alias grep='grep --color=auto --exclude-dir=\.git'

# sample function so you can SSH with password copied into clipboard already
function gotoX () {
  echo "*********************************"
  echo " Password saved in Clipborard  "
  echo "*********************************"
  echo 'YOURPASSWROD' | tr -d '\n' | pbcopy
  ssh username@server
}

# add something to clipboard and remove linebreak at the end
function clip () {
  $1 | tr -d '\n' | pbcopy
}

# ACK set to use .ackrc for most commonly used
# $@ spits out any/all arguments: example use: grack -option -option 'string'
# output: ack --ackrc=/Users/me/.ackrc -option -option 'string'
function grack (){
  echo "ack --ackrc=/Users/me/.ackrc" $@
  ack --ackrc=~/.ackrc $@
}

function androidcast () {
  adb shell "while true; do screenrecord --output-format=h264 -; done" | ffplay -framerate 60 -probesize 32 -sync video -
}

function movToMp4 () {
  name=$(basename $1 .mov)
  ffmpeg -i $1 -vcodec h264 -acodec mp2 $name.mp4
}

######################################################################
# COLORS (used in some functions below)

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

##################################################################
# personal functions

function myzip () {
    if [ -z "$1" ]
      then
        echo "${RED}No arguments supplied"
        echo "${YELLOW}usage: myzip [destination] [files to be zipped] "
    else
      # $1 is the destination zip file name
      # $2 is the files to be zipped
      zip -vr $1 $2 -x "*.DS_Store"
    fi
}

# start a local server using PHP cli
function localhost () {
  if [ -z "$1" ]
    then
      echo "${RED}Must supply a port number"
      echo "${NORMAL}requires OS X 10.9+ (Mavericks and newer)"
      echo "${YELLOW}usage: localhost 8000"
  else
    open http://localhost:$1 & php -S localhost:$1 
  fi
}

# source ~/.git-completion.sh

#####################################################################
# Git prompt customization
# https://github.com/magicmonty/bash-git-prompt
# 

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  # GIT_PROMPT_ONLY_IN_REPO=1
  # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
  GIT_PROMPT_IGNORE_SUBMODULES=1 # uncomment to avoid searching for changed files in submodules
  GIT_PROMPT_WITH_VIRTUAL_ENV=0 # uncomment to avoid setting virtual environment infos for node/python/conda environments

  GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
  # GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files

  # GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

  # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

  # GIT_PROMPT_START="\u in \w"    # uncomment for custom prompt start sequence
  # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

  # as last entry source the gitprompt script
  # GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
  # GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
  # GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi
