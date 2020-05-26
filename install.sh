#!/bin/bash

#########################################################
# Change the TARGETDIR for testing
#

TARGETDIR='${HOME}'
REPO='https://raw.githubusercontent.com/FranciscoG/instasetup/master'
GIT_REPO='https://raw.githubusercontent.com/git/git/master/contrib/completion'

#########################################################
# Check which OS you are on
# http://stackoverflow.com/a/18434831/395414

# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    ;;
  'FreeBSD')
    OS='FreeBSD'
    ;;
  'WindowsNT')
    OS='Windows'
    ;;
  'Darwin') 
    OS='Mac'
    ;;
  'SunOS')
    OS='Solaris'
    ;;
  'AIX') ;;
  *) ;;
esac


#########################################################
# Change the TARGETDIR for testing
#

wget="$(which wget)"

# check if a command line program exists
function exists () {
  $1 -v > /dev/null 2>&1
}

function getBrew () {
  if [ "$OS" -eq "Mac" ]; then
    if ! exists brew ; then
      echo "installing homebrew"
      # from: http://brew.sh/
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      echo "Brew already installed"
    fi
  fi
}

function platformInstaller () {
  if [ "$OS" -eq "Mac" ]; then
    brew install $1
    return
  fi

  if [ "$OS" -eq "Linux" ]; then
    if exists yum ; then
      yum install $1
    else
      sudo apt-get $1
    fi
  fi
}


function getWget() {
  if [ ! -f $wget ]; then
    echo "installing wget using homebrew"
    # from: http://www.merenbach.com/software/wget/
    platformInstaller wget
    wget="$(which wget)"
  else
    echo "wget already installed"
  fi
}


####################################################################
# function that grabs an file at a URL and downloads it to targetDIR
#

function dlFile () {
  # wget -O renamedFile.sh URL
  wget -O $1 $2 
}

#########################################################
# Download files from a URL and save them to target dir
#

function copyFiles () {
  
  dlFile ${TARGETDIR}/.bashrc ${REPO}/.bashrc
  
  dlFile ${TARGETDIR}/.bash_profile ${REPO}/.bash_profile

  dlFile ${TARGETDIR}/.git-completion.sh ${GIT_REPO}/git-completion.bash

  dlFile ${TARGETDIR}/.git-prompt.sh ${GIT_REPO}/git-prompt.sh 

  dlFile ${TARGETDIR}/.vimrc ${REPO}/.vimrc

  dlFile ${TARGETDIR}/.gitconfig ${REPO}/.gitconfig

  # changing global dir for npm to avoid permissions errors
  # https://docs.npmjs.com/getting-started/fixing-npm-permissions
  mkdir -p ${TARGETDIR}/.npm-global

  # make .vim colors directory
  mkdir -p ${TARGETDIR}/.vim/colors

  # solarized.vim
  dlFile ${TARGETDIR}/.vim/colors/solarized.vim https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim

}

#########################################################
# Vim stuff
#

function installPathogen () {
  # https://github.com/tpope/vim-pathogen
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function installVimSensible () {
  # https://github.com/tpope/vim-sensible
  git clone https://tpope.io/vim/sensible.git ~/.vim/pack/tpope/start
}

#########################################################
# Setting System preferences
#

function doPrefs () {
  if [ "$OS" -eq "Mac" ]; then
    #Add a context menu item for showing the Web Inspector in web views
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    #Show the ${TARGETDIR}/Library folder
    chflags nohidden ${TARGETDIR}/Library

    #Store screenshots in subfolder on desktop
    mkdir ${TARGETDIR}/Desktop/Screenshots
    defaults write com.apple.screencapture location ${TARGETDIR}/Desktop/Screenshots
  fi
}

function apps () {
  if [ "$OS" -eq "Mac" ]; then
    # using brew to install my favoriite apps
    brew cask install iterm2 node visual-studio-code google-chrome firefox keepassxc vlc
  fi

  # add linux and windows CLI install here
}


#########################################################
# And finally we GO!
#

getBrew && getWget && copyFiles && doPrefs && installPathogen && installVimSensible && apps


