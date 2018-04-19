#!/bin/bash

#########################################################
# Change the TARGETDIR for testing
#

TARGETDIR='${HOME}'


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
  
  # .bashrc
  # https://raw.githubusercontent.com/FranciscoG/instasetup/master/.bashrc
  dlFile ${TARGETDIR}/.bashrc https://raw.githubusercontent.com/FranciscoG/instasetup/master/.bashrc
  
  # .bash_profile
  # https://raw.githubusercontent.com/FranciscoG/instasetup/master/.bash_profile
  dlFile ${TARGETDIR}/.bash_profile https://raw.githubusercontent.com/FranciscoG/instasetup/master/.bash_profile

  # .git-completion.sh
  # https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  dlFile ${TARGETDIR}/.git-completion.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

  # git-prompt.sh 
  # https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 
  dlFile ${TARGETDIR}/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh 

  # .vimrc
  # https://raw.githubusercontent.com/FranciscoG/instasetup/master/.vimrc
  dlFile ${TARGETDIR}/.vimrc https://raw.githubusercontent.com/FranciscoG/instasetup/master/.vimrc

  # jshintrc
  # https://raw.githubusercontent.com/FranciscoG/instasetup/master/.jshintrc
  dlFile ${TARGETDIR}/.jshintrc https://raw.githubusercontent.com/FranciscoG/instasetup/master/.jshintrc

  # changing global dir for npm to avoid permissions errors
  # https://docs.npmjs.com/getting-started/fixing-npm-permissions
  mkdir -p ${TARGETDIR}/.npm-global

  # make .vim colors directory
  mkdir -p ${TARGETDIR}/.vim/colors

  # solarized.vim
  # https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
  dlFile ${TARGETDIR}/.vim/colors/solarized.vim https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim

}

#########################################################
# Vim stuff
#

function installPathogen () {
  # https://github.com/tpope/vim-pathogen
  mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function installVimSensible () {
  # https://github.com/tpope/vim-sensible
  cd ~/.vim/bundle && git clone git://github.com/tpope/vim-sensible.git && cd ~
}

#########################################################
# Setting System preferences
#

function doPrefs () {
  #Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  #Show the ${TARGETDIR}/Library folder
  chflags nohidden ${TARGETDIR}/Library

  #Store screenshots in subfolder on desktop
  #not sure if I want this yet so leaving it commented
  #mkdir ${TARGETDIR}/Desktop/Screenshots
  #defaults write com.apple.screencapture location ${TARGETDIR}/Desktop/Screenshots
}

#########################################################
# Setting app preferences
#

function setupSubl () {
  # Check if Sublime was installed Manually
  if [[ -d /Applications/Sublime\ Text.app/ ]]; then
    if [[ ! -d ${TARGETDIR}/bin ]]; then
      mkdir -p ${TARGETDIR}/bin && ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ${TARGETDIR}/bin/subl
    elif ! exists subl ; then
      ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ${TARGETDIR}/bin/subl
    fi
    
    # to finish syncing packages
    open https://packagecontrol.io/docs/syncing
  fi
}

#########################################################
# And finally we GO!
#

getBrew && getWget && copyFiles && doPrefs && setupSubl && installPathogen && installVimSensible


