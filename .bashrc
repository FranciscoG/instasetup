export PATH="$PATH:~/bin"
export PATH="$PATH:~/bash_scripts"
#export PATH=/Applications/MAMP/bin/php/php5.5.10/bin:$PATH

#####################################################################
# Android Section
# 

# export ANDROID_HOME="/usr/local/opt/android-sdk"
# export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Now run the 'android' tool to install the actual SDK stuff.

# The Android-SDK location for IDEs such as Eclipse, IntelliJ etc is:
#   /usr/local/Cellar/android-sdk/23.0.2

# You will have to install the platform-tools and docs EVERY time this formula
# updates. If you want to try and fix this then see the comment in this formula.

# You may need to add the following to your .bashrc:
#   export ANDROID_HOME=/usr/local/opt/android-sdk

# Bash completion has been installed to:
#   /usr/local/etc/bash_completion.d
# ==> Summary
# 🍺  /usr/local/Cellar/android-sdk/23.0.2: 1578 files, 113M, built in 23 seconds
######################################################################

# COLORS
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

export CLICOLOR=1
 
# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# set default text editor for SVN
export SVN_EDITOR=vim

# SVN add all unversioned files recursively 
alias svn_add="svn add --force * --auto-props --parents --depth infinity -q"

# personal functions

function reload () {
  source ~/.bash_profile
}

function editBash () {
  vim ~/.bash_profile
}

function svn_ignores () {
    svn propset svn:ignore ".DS_Store" .
    svn propset svn:ignore "Thumbs.db" .
    svn propset svn:ignore "node_modules" .
}

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
 
function la () {
  ls -lah
}

function localhost () {
  if [ -z "$1" ]
    then
      echo "${RED}Must supply a port number"
      echo "${NORMAL}requires OS X 10.9+ (Mavericks or newer)"
      echo "${YELLOW}usage: localhost 8000"
  else
    php -S localhost:$1 && open http://localhost:$1
  fi
}

#####################################################################
# Git and SVN prompt customization
# 

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}
 
# Detect whether the current directory is a subversion repository.
function is_svn_repository {
  test -d .svn
}

function set_git_branch {
 
  # the following below is all about customizing my prompt
  # slightly modified form this source: http://digitalformula.net/articles/pimp-my-prompt-like-paul-irish/page_4/

  # enable the git bash completion commands
  #https://github.com/git/git/tree/master/contrib/completion
  #get git-completion.sh and git-prompt.sh
  #put them in your ~ folder and rename them to:
  #.git-completion.sh
  #.git-prompt.sh
  source ~/.git-completion.sh
  source ~/.git-prompt.sh
   
  # enable git unstaged indicators - set to a non-empty value
  GIT_PS1_SHOWDIRTYSTATE="."
   
  # enable showing of untracked files - set to a non-empty value
  GIT_PS1_SHOWUNTRACKEDFILES="."
   
  # enable stash checking - set to a non-empty value
  GIT_PS1_SHOWSTASHSTATE="."
   
  # enable showing of HEAD vs its upstream
  GIT_PS1_SHOWUPSTREAM="auto"
   
  # set the prompt to show current working directory and git branch name, if it exists
   
  # this prompt is a green username, black @ symbol, cyan host, magenta current working directory and white git branch (only shows if you're in a git branch)
  # unstaged and untracked symbols are shown, too (see above)
  # this prompt uses the short colour codes defined above
  # PS1='${GREEN}\u${BLACK}@${CYAN}\h:${MAGENTA}\w${WHITE}`__git_ps1 " (%s)"`\$ '
   
  # this is a cyan username, @ symbol and host, magenta current working directory and white git branch
  # it uses the shorter , but visibly more complex, codes for text colours (shorter because the colour code definitions aren't needed)
  # PS1='\[\033[0;36m\]\u@\h\[\033[01m\]:\[\033[0;35m\]\w\[\033[00m\]\[\033[1;30m\]\[\033[0;37m\]`__git_ps1 " (%s)"`\[\033[00m\]\[\033[0;37m\]\$ '
   
  # return the prompt prefix for the second line
  function set_prefix {
      BRANCH=`__git_ps1`
      if [[ -z $BRANCH ]]; then
    echo "${NORMAL}>"
      else
    echo "${NORMAL}+>"
      fi
  }
   
  # and here's one similar to Paul Irish's famous prompt ... not sure if this is the way he does it, but it works  :)
  # \033[s = save cursor position
  # \033[u = restore cursor position
   
  PS1='${MAGENTA}\u${WHITE} in ${GREEN}\w${WHITE}${MAGENTA}`__git_ps1 " on %s"`${WHITE}\r\n`set_prefix`${NORMAL}${CYAN}\033[s\033[u${WHITE} '
}


# Determine the branch information for this subversion repository. No support
# for svn status, since that needs to hit the remote repository.
function set_svn_branch {
  # Capture the output of the "git status" command.
  svn_info="$(svn info | egrep '^URL: ' 2> /dev/null)"
 
  # Get the name of the branch.
  branch_pattern="^URL: .*/(branches|tags)/([^/]+)"
  trunk_pattern="^URL: .*/trunk(/.*)?$"
  if [[ ${svn_info} =~ $branch_pattern ]]; then
    branch=${BASH_REMATCH[2]}
  elif [[ ${svn_info} =~ $trunk_pattern ]]; then
    branch='trunk'
  fi
 
  # Set the final branch string.
  BRANCH="(${branch}) "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the 
  # return value of the last command.
  set_prompt_symbol $?
 
  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  elif is_svn_repository ; then
    set_svn_branch
    PS1="${MAGENTA}\u${WHITE} in ${GREEN}\w ${BRANCH}${PROMPT_SYMBOL} ${WHITE}"
  else
    BRANCH=''
    PS1="${MAGENTA}\u${WHITE} in ${GREEN}\w ${BRANCH}${PROMPT_SYMBOL} ${WHITE}"
  fi

  #set_svn_branch
  #PS1="${MAGENTA}\u${WHITE} in ${GREEN}\w ${BRANCH}${PROMPT_SYMBOL} ${WHITE}"
  
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
# PS1="${MAGENTA}\u${WHITE} in ${GREEN}\w ${BRANCH}${PROMPT_SYMBOL} ${WHITE}"