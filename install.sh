#!/bin/bash

if grep -P --quiet '(?<=ID=)debian$' /etc/os-release; then
  # So, debian/raspberry pi os's default vim target has X11 support but is _missing_
  # python3 support. Which a bunch of my mods require. OTOH, vim-nox has this.
  # Why? I don't know, this seems silly.
  sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-common vim-gui-common -y
  sudo apt-get install vim-nox -y
fi

vim +PluginInstall +qall
