#!/bin/bash -xe

#####
#
# This is a Ubuntu setup script to setup a users dev environment. 
#  Note this script should be idempotent and works from a clean Ubuntu install.
#

#TODO [wsmidt]
# - loops (mkdirs, apt-gets, etc...)
# - skip installs if file already exists. (example curl installs)

#setup vars
BIN_DIR=~/bin
LIB_DIR=~/lib
WORKSPACE_DIR=~/workspace
DOWNLOAD_DIR=~/Downloads

#setup dirs
mkdir -p $BIN_DIR
mkdir -p $LIB_DIR
mkdir -p $WORKSPACE_DIR

#setup keys
setxkbmap -layout us -option ctrl:nocaps # remap caps lock to ctrl

#install packages
sudo apt-get install vim -y
sudo apt-get install curl -y
sudo apt-get install git -y
sudo apt-get install openjdk-8-jre-headless -y

#install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt -y

#install intellij
IDEA_VERSION="ideaIC-2020.2.3"
IDEA_TGZ="$IDEA_VERSION.tar.gz"
IDEA_DOWNLOAD_URL=https://download.jetbrains.com/idea/$IDEA_TGZ
IDEA_DOWNLOAD_FILE=$DOWNLOAD_DIR/$IDEA_TGZ
IDEA_LIB_DIR=$LIB_DIR/$IDEA_VERSION
if [ ! -d "$IDEA_LIB_DIR" ]; then
  curl -L $IDEA_DOWNLOAD_URL -o $IDEA_DOWNLOAD_FILE
  mkdir -p $IDEA_LIB_DIR
  tar -xvzf $IDEA_DOWNLOAD_FILE -C $IDEA_LIB_DIR
  ln -fs $IDEA_LIB_DIR/idea-IC-202.7660.26/bin/idea.sh ~/bin/idea.sh
fi

#install tmux
sudo apt-get install tmux -y
NORD_TMUX_PLUGIN_DIR=~/.tmux/themes/nord-tmux
if [ ! -f "$NORD_TMUX_PLUGIN_DIR/nord.tmux" ]; then
  mkdir -p $NORD_TMUX_PLUGIN_DIR
  git clone git@github.com:arcticicestudio/nord-tmux.git $NORD_TMUX_PLUGIN_DIR
fi
cp `dirname $0`/tmux.conf ~/.tmux.conf

#setup bashrc
OH_MY_BASH_DIR=~/.oh-my-bash
OH_MY_BASH_INITIALIZED_FILE=$OH_MY_BASH_DIR/initialized
if [ ! -f "$OH_MY_BASH_INITIALIZED_FILE" ]; then
  git clone git://github.com/ohmybash/oh-my-bash.git $OH_MY_BASH_DIR
  cp $OH_MY_BASH_DIR/templates/bashrc.osh-template ~/.bashrc
  echo "bashrc initialized" > $OH_MY_BASH_INITIALIZED_FILE
  source ~/.bashrc # TODO why does this not work?
fi
