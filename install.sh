#!/bin/bash

#########################################################
# Change the TARGETDIR for testing
#

TARGETDIR='${HOME}'

#########################################################
# Change the TARGETDIR for testing
#

wget="$(which wget)"

# check if a command line program exists
function exists () {
  $1 -v > /dev/null 2>&1
}

function getBrew () {
  if ! exists brew ; then
    echo "installing homebrew"
    # from: http://brew.sh/
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "Brew already installed"
  fi
}

function getWget() {
  if [ ! -f $wget ]; then
    echo "installing wget using homebrew"
    # from: http://www.merenbach.com/software/wget/
    brew update && brew install wget
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

  # create my simple .npmrc file
  echo "prefix=${HOME}/.npm-packages" > ${TARGETDIR}/.npmrc

  # make .vim colors directory
  if [[ ! -d ${TARGETDIR}/.vim ]]; then
    mkdir ${TARGETDIR}/.vim && mkdir ${TARGETDIR}/.vim/colors
  elif [[ ! -d ${TARGETDIR}/.vim/colors ]]; then
    mkdir ${TARGETDIR}/.vim/colors
  fi

  # solarized.vim
  # https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
  dlFile ${TARGETDIR}/.vim/colors/solarized.vim https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim

  # src: https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
  if [[ ! -d ${TARGETDIR}/.npm-packages ]]; then
    mkdir ${TARGETDIR}/.npm-packages
  fi

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

getBrew && getWget && copyFiles && doPrefs && setupSubl


