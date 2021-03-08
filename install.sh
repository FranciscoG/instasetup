#!/usr/bin/env bash

if test "$BASH" = "" || "$BASH" -uc "a=();true \"\${a[@]}\"" 2>/dev/null; then
    # Bash 4.4, Zsh
    set -euo pipefail
else
    # Bash 4.3 and older chokes on empty arrays with set -u.
    set -eo pipefail
fi

# require(){ hash "$@" || exit 127; }

#########################################################
# Change the TARGETDIR for testing
#

TARGETDIR="${HOME}"
REPO="https://raw.githubusercontent.com/FranciscoG/instasetup/master"
GIT_REPO="https://raw.githubusercontent.com/git/git/master/contrib/completion"

#########################################################
# Check which OS you are on
# http://stackoverflow.com/a/18434831/395414

# Detect the platform (similar to ${OS}TYPE)
OS="$(uname)"
case "${OS}" in
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


# check if a command line program exists
exists () {
  hash "$@" 2>/dev/null
}

getBrew () {
  if [ "${OS}" == "Mac" ]; then
    if ! exists brew ; then
      echo "installing homebrew"
      # from: http://brew.sh/
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
      echo "Brew already installed"
    fi
  fi
}

platformInstaller () {
  if [ "${OS}" == "Mac" ]; then
    brew install "$1"
  elif [ "${OS}" == "Linux" ]; then
    if exists yum ; then
      yum install "$1"
    else
      sudo apt-get "$1"
    fi
  fi
}

getWget() {
  if ! exists wget ; then
    echo "installing wget using homebrew"
    # from: http://www.merenbach.com/software/wget/
    platformInstaller wget
  else
    echo "wget already installed"
  fi
}


####################################################################
# that grabs an file at a URL and downloads it to targetDIR
#

# $1 - local folder to place file
# $2 - url source
dlFile () {
  wget -O "$1" "$2"
}

#########################################################
# Download files from a URL and save them to target dir
#

copyFiles () {
  dlFile "${TARGETDIR}/.bashrc" "${REPO}/.bashrc"

  dlFile "${TARGETDIR}/.bash_profile" "${REPO}/.bash_profile"

  dlFile "${TARGETDIR}/.git-completion.sh" "${GIT_REPO}/git-completion.bash"

  dlFile "${TARGETDIR}/.git-prompt.sh" "${GIT_REPO}/git-prompt.sh" 

  dlFile "${TARGETDIR}/.vimrc" "${REPO}/.vimrc"

  dlFile "${TARGETDIR}/.gitconfig" "${REPO}/.gitconfig"

  # changing global dir for npm to avoid permissions errors
  # https://docs.npmjs.com/getting-started/fixing-npm-permissions
  mkdir -p "${TARGETDIR}/.npm-global"

  # make .vim colors directory
  mkdir -p "${TARGETDIR}/.vim/colors"

  # solarized.vim
  dlFile "${TARGETDIR}/.vim/colors/solarized.vim" https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim

}

#########################################################
# Vim stuff
#

installPathogen () {
  # https://github.com/tpope/vim-pathogen
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

installVimSensible () {
  # https://github.com/tpope/vim-sensible
  git clone https://tpope.io/vim/sensible.git ~/.vim/pack/tpope/start
}

#########################################################
# Setting System preferences
#

doPrefs () {
  if [ "${OS}" == "Mac" ]; then
    #Add a context menu item for showing the Web Inspector in web views
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    #Show the ${TARGETDIR}/Library folder
    chflags nohidden "${TARGETDIR}/Library"

    #Store screenshots in subfolder on desktop
    mkdir "${TARGETDIR}/Desktop/Screenshots"
    defaults write com.apple.screencapture location "${TARGETDIR}/Desktop/Screenshots"
  fi
}

apps () {
  if [ "${OS}" == "Mac" ]; then
    # using brew to install apps
    brew install node && brew install --cask iterm2 visual-studio-code google-chrome firefox keepassxc vlc
  fi

  # add linux and windows CLI install here
}


#########################################################
# And finally here we GO!
#

getBrew && getWget && copyFiles && doPrefs && installPathogen && installVimSensible && apps
