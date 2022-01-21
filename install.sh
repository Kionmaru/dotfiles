#!/bin/bash

if grep -P --quiet '(?<=ID=)debian$' /etc/os-release; then
  sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common -y
  sudo apt-get install vim-nox -y
fi

vim +PluginInstall +qall
