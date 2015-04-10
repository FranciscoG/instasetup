#!/bin/bash

# TODO
# have all the rc and profiles point to the ones in this repo instead of copying them
# 
# switch to zshell and make a zshell version of this installer

#########################################################
# the easy stuff,  moving files already in this repo
#

function copyFiles () {
  cp .bash* ~ 
  cp .git-* ~
  cp .vim* ~
  cp .js* ~

  if [[ ! -d ~/.vim ]]; then
    mkdir ~/.vim && mkdir ~/.vim/colors
  elif [[ ! -d ~/.vim/colors ]]; then
    mkdir ~/.vim/colors
  fi

  cp solarized.vim ~/.vim/colors
}


#########################################################
# Function that checks if a command line app exists
#

# for command line programs
function exists () {
  $1 -v > /dev/null 2>&1
}

# for OSX applications that don't have a command line interface
function appDirExists () {
  if [[ ( -d /Applications/$1 ) || ( -d ~/Applications/$1 ) ]]; then
    return 1
  else
    return 0
  fi
}

##########################################################
# Downloading and installing apps
#

function getBrew () {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function getCask () {
  if exists brew ; then
    echo "installing Cask"
    brew update && brew install caskroom/cask/brew-cask
  else
    echo "installing Brew and Cask"
    getBrew && brew install caskroom/cask/brew-cask
  fi
}

function getNode () {
  if ! exists node ; then
    echo "installing node"
    brew install node
  else
    echo "Node is already installed"
  fi
}

function getiTerm2 () {
  if ! appDirExists iTerm.app ; then
    echo "install iTerm2"
    brew cask install iterm2
  else
    echo "iTerm is already installed"
  fi
}

function getGulp () {
  if ! exists gulp ; then
    echo "installing Gulp globally"
    npm install -g gulp
  else
    echo "Gulp is already installed"
  fi
}

function getAlfred () {
  if ! appDirExists "Alfred\ 2.app" ; then
    echo "installing Alfred"
    brew cask install alfred
  else
    echo "Alfred is already installed"
  fi
}

function getST3 () {
  if ! appDirExists "Sublime\ Text.app" ; then
    echo "installing Sublime Text 3"
    brew cask install sublime-text
  else
    echo "Sublime Text 3 is already installed"
  fi
}

function getApps () {
  getCask && getNode && getiTerm2 && getGulp && getAlfred && getST3
}

#########################################################
# Setting System preferences
#

function doPrefs () {
  #Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  #Show the ~/Library folder
  chflags nohidden ~/Library

  #Store screenshots in subfolder on desktop
  #not sure if I want this yet so leaving it commented
  mkdir ~/Desktop/Screenshots
  defaults write com.apple.screencapture location ~/Desktop/Screenshots
}

#########################################################
# Setting app preferences
#

function setupSubl () {
  # Check if Sublime was installed Manually
  if [[ -d /Applications/Sublime\ Text.app/ ]]; then
    if [[ ! -d ~/bin ]]; then
      mkdir -p ~/bin && ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    elif ! exists subl ; then
      ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    fi
  # homebrew cask installs and symlinks to the ~/App.. folder so we check if it's in there too
  elif [[ -d ~/Applications/Sublime\ Text.app/ ]]; then
    if [[ ! -d ~/bin ]]; then
      mkdir -p ~/bin && ln -s "~/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    elif ! exists subl ; then
      ln -s "~/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    fi
  fi
}

#########################################################
# And finally we GO!
#

copyFiles && getApps && doPrefs && setupSubl


