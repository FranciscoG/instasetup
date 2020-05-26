#!/bin/bash

# uninstall apps that might contain sensitive personal information
function apps () {
  if [ "$OS" -eq "Mac" ]; then
    # using brew to install my favoriite apps
    brew cask zap visual-studio-code google-chrome firefox keepassxc
  fi
}

# add any more items to remove here
# uninstall dropbox and the dropbox local folder
# uninstall google drive and the goodl drive local folder?
# remove ssh keys
# etc etc


apps