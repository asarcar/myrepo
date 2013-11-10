#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Validate that the command is executed where setup.sh and 
# dotfiles are available: else terminate execution of script
# and spew out a WARNING sign and exit
if [ ! -f setup.sh ]; then
    echo "Execute setup.sh from the directory where setup.sh exists"
    exit 2  
fi
if [ ! -d dotfiles ]; then
    echo "Execute setup.sh from the directory where dotfiles exists"
    exit 2  
fi

sudo apt-get install -y git-core

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

# Install cscope
sudo apt-get install -y cscope cscope-el

###################################
# JAVASCRIPT related installation #
###################################
#############################
# Node related installation #
#############################
# Install nvm: node-version manager
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

###############################
# PYTHON related installation #
###############################
sudo apt-get install -y pychecker

###############################
# HEROKU related installation #
###############################
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

##########################
# R related installation #
##########################
sudo apt-get install -y r-base
# Install ESS: R code within emacs
sudo apt-get install -y ess

# install dotfiles
# move prior incarnation of dotfiles to an old directory
pushd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
if [ -d .env_custom/ ]; then
    mv .env_custom .env_custom~
fi
if [ [-d .ssh/ ] -a [ -f .ssh/config] ]; then
    mv .ssh/config .ssh/config.old
fi
# pop out of $HOME directory
popd

# Copy the new dotfiles inside this git directory to $HOME
cp -r dotfiles $HOME
pushd $HOME
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sf dotfiles/.emacs.d .
ln -sf dotfiles/.Rprofile .
ln -sb dotfiles/.gitignore .
ln -sf dotfiles/.env_custom .
ln -sb dotfiles/.env_custom/.gitconfig_custom .gitconfig
ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# Common C++ Development Libraries 

# Install latest gcc 
sudo apt-get install -y gcc

# Install common C++ packages: boost
sudo apt-get install -y libboost-all-dev

# Install latest compile accelerators
sudo apt-get install -y cmake distcc ccache

# Install common google packages
# libgoogle-perftools-dev includes tcmalloc
sudo apt-get install -y libprotobuf-dev libgtest-dev libgoogle-perftools-dev libsnappy-dev libleveldb-dev libgoogle-glog-dev libgflags-dev

# Google libgtest-dev static libraries not installed as binary: Build it
pushd /tmp
mkdir -p .build
cd .build
sudo cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest/
sudo make
sudo mv libg* /usr/lib
popd

# -----------------------------------------------------

# Common R Packages ----------------------------------

# Installation of rgl package gave error:
# > "configure: error: missing required header GL/gl.h...
# >  * removing ‘/home/asarcar/R/x86_64-pc-linux-gnu-library/2.15/rgl’"
# Hence used the ubuntu binary distribution:
sudo apt-get install -y r-cran-rgl

# R Package Installation is very unstable: for now commenting out the directory
## Install latest packages not available in binary distribution by executing install within R
# mkdir -p R
## TODO: current all libraries for all R versions and 
## for all architectures will go in same directory
# R -e "install.packages(c('gclus', 'ggplot2', 'pysch', 'sm'), lib='~/R')"
# -----------------------------------------------------
