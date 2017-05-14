#!/bin/sh

# Standalone installer for Unixs

if [ $# -ne 1 ]; then
  echo "You must specify the installation directory!"
  exit 1
fi

# Convert the installation directory to absolute path
case $1 in
  /*) INSTALL_DIR=$1;;
  *) INSTALL_DIR=$PWD/$1;;
esac

echo "Install to \"$INSTALL_DIR\"..."
if [ -e "$INSTALL_DIR" ]; then
  echo "\"$INSTALL_DIR\" already exists!"
fi

echo ""

# check git command
type git || {
  echo 'Installing git'
  sudo apt-get install -y git
}
echo ""

# make plugin dir and fetch ansible_config
if ! [ -e "$INSTALL_DIR" ]; then
  echo "Begin fetching ansible_config..."
  mkdir -p "$INSTALL_DIR"
  git clone -b tim git@github.com:timeyyy/ansible-ubuntu-desktop.git "$INSTALL_DIR"
  echo "Finished fetching."
  echo ""
  echo "Running start.sh"
  sh $INSTALL_DIR/start.sh
fi

