#!/bin/bash


#########################################################
# the easy stuff,  moving files already in this repo
#

function copyFiles () {
  cp .* ~ 

  if [[ ! -d ~/.vim ]]; then
    mkdir ~/.vim && mkdir ~/.vim/colors
  elif [[ ! -d ~/.vim/colors ]]; then
    mkdir ~/.vim/colors
  fi

  cp solarized.vim ~/.vim/colors
}


#########################################################
# Function that check if a command line app exists
#

function exists () {
  if [ -z "$1" ]
   then
     echo "exists: Missing argument"
   else
    $1 -v > /dev/null 2>&1
  fi
}


##########################################################
# Downloading and installing apps
#

function getBrew () {
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
}

function getCask () {
  if exists brew ; then
    echo "installing Cask"
    brew install caskroom/cask/brew-cask
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
  if [[ ! -d /Applications/iTerm.app/ ]]; then
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
  if [[ ! -d /Applications/Alfred\ 2.app/ ]]; then
    echo "installing Alfred"
    brew cask install alfred
  else
    echo "Alfred is already installed"
  fi
}

function getST3 () {
  if [[ ! -d /Applications/Sublime\ Text.app/ ]]; then
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
  #mkdir ~/Desktop/Screenshots
  #defaults write com.apple.screencapture location ~/Desktop/Screenshots
}

#########################################################
# Setting app preferences
#

function setupSubl () {
  if [[ -d /Applications/Sublime\ Text.app/ ]]; then
    if [[ ! -d ~/bin ]]; then
      mkdir -p ~/bin && ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    elif ! exists subl ; then
      ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
    fi
  fi
}

#########################################################
# And finally we GO!
#

copyFiles && getApps && doPrefs && setupSubl


