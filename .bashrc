######################################################################
# PATH
export PATH="$PATH:~/bin"
export PATH="$PATH:~/bash_scripts"
export PATH=~/.npm-global/bin:$PATH

# Android Section
export ANDROID_HOME=~/Development/android-sdk-macosx
export PATH=${PATH}:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools

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
alias editBash='subl ~/.bashrc'

# add everything that needs to be added based on results of svn status
alias svnadd="svn st | grep ^? | sed 's/?    //' | xargs svn add"
alias svnrm="svn st | grep ^! | sed 's/!    //' | xargs svn rm"
alias svnrmForce="svn st | grep ^! | sed 's/!    //' | xargs svn rm --force" 
alias svncopyurl="svn info | grep ^URL | sed 's/URL: //' | tr -d '\n' | pbcopy"

# sometimes I still need Wienre
EXTERNALIP=`ifconfig en4 | awk '$1 == "inet" {print $2}'`
alias startWienre="open http://${EXTERNALIP}:8080 & weinre --httpPort 8080 --boundHost ${EXTERNALIP}"

# Make some possibly destructive commands more interactive.
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ll='ls -lFG'
alias la='ls -lahFG'
alias ls='ls -FG'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto --exclude-dir=\.svn'

# start a simple browser Sync session on current folder
alias staticSync='browser-sync start --files "css/*.css, js/*.js, *.html, **/*.html" --server --directory'
alias superStaticSync='browser-sync start --files "**/*" --server --directory'

# shortcut to merge in from trunk
alias trunkMerge="svn merge ^/trunk"

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto --exclude-dir=\.svn'

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

function svn_ignores () {
    svn propset svn:ignore ".DS_Store" .
    svn propset svn:ignore "Thumbs.db" .
    svn propset svn:ignore "node_modules" .
}

function jiraFile() {
  # curl -D- -u {username}:{password} -X POST -H "X-Atlassian-Token: nocheck" -F "file=@{path/to/file}" http://{base-url}/rest/api/2/issue/{issue-key}/attachments
  echo uploading $1 to http://jira.domain.com:8080/rest/api/2/issue/$2/attachments
  curl -D- -u USERNAME:PASSWORD -X POST -H "X-Atlassian-Token: nocheck" -F "file=@$1" $1 http://JIRA-URL/rest/api/2/issue/$2/attachments
}

function jiraComment() {
  # curl -D- -u fred:fred -X POST --data {see below} -H "Content-Type: application/json" http://kelpie9:8081/rest/api/2/issue/QA-31/comment
  echo adding comment to $1
  curl -D- -u USERNAME:PASSWORD -X POST --data "{\"body\":\"$2\"}" -H "Content-Type: application/json" http://JIRA-URL/rest/api/2/issue/$1/comment
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

#####################################################################
# Git and SVN prompt customization
# 

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
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
  else
    BRANCH=''
    PS1="${MAGENTA}\u${WHITE} in ${GREEN}\w ${BRANCH}${PROMPT_SYMBOL} ${WHITE}"
  fi  
}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
