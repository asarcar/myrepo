#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Set up system to accept without password for subsequent commands
echo ">> execute 'echo password | sudo -S ls -al' so that subsequent sudo commands do not require password"
echo ">> close the terminal afterwards since we now have unrestricted sudo access"

if [ $# -ne 0 ]; then
  echo "Usage: setup.sh"
  exit 2 
fi

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

#
# Machine Setup: Assumed that basic Machine Setup instructions have been 
# executed: IPMI set, partitions created, user/group accounts created, sudo
# permissions granted, mgmt interface configured, etc: 
# refer to tips/system_commands.txt
#

# Upgrade to the latest packages: remove obsoleted packages
sudo apt-get -y upgrade --fix-missing

# LOCAL INSTALLATION ONLY: Better to hand install
# 13.10/14.04 "extra" packages
# "Ubuntu restricted extras: consists of codecs not installed by default.
#> sudo apt-get install -y ubuntu-restricted-extras
# Adobe Flash Player
#> sudo apt-get install -y flashplugin-installer
# VLC: best open source media player
#> sudo apt-get install -y vlc
# Enable encrypted DVD playback
#> sudo apt-get install -y libdvdread4
#> sudo /usr/share/doc/libdvdread4/install-css.sh
# Install RAR
sudo apt-get install -y rar
# Get rid of "Sorry: Ubuntu xx.yy has experienced an internal error"
# edit "enabled=1" to "enabled=0"right after: '# sudo service apport start force_start=1'
# Ensure additional drivers in Ubuntu 13.10/14.04 are installed: 
#   Unity Dash -> Software & Updates -> Additional Drivers -> Enable Third Party Drivers if listed
# 
#############
# Utilities #
#############
# locate: helps find a file anywhere in the already mounted filesystem
sudo apt-get install -y locate
# tree: displays directory tree in color
sudo apt-get install -y tree
# rlwrap: command completion and history 
sudo apt-get install -y rlwrap
# Install screen
sudo apt-get install -y screen 
# rlwrap: command completion and history
sudo apt-get install -y rlwrap
# iftop: Command line tool that displays bandwidth usage on an interface
sudo apt-get install -y iftop
# git: distributed version control system
sudo apt-get install -y git-core
# flip -u "filename": removes CR & LF in dos files to LF for unix
sudo apt-get install -y flip
# lshw: Hardware Lister
sudo apt-get install -y lshw
# hwloc/lstopo: provides a portable abstraction of hierarchical architectures 
sudo apt-get install -y hwloc
# sysstat: sar (system activity report) and iostat monitoring commands
sudo apt-get install -y sysstat
# telnet client: provided by default
# sshpass: allows one to execute ssh without submitting password:
# sshpass -p 'passwd' ssh user@host command...
sudo apt-get install -y sshpass
# quota allows one to view ones disk quota and usage
sudo apt-get install -y quota
# sendmail: powerful, efficient, and scalable Mail Transport Agent
sudo apt-get install -y sendmail
# devscripts: dget and other utilities for package installation
sudo apt-get install -y devscripts
# tkcvs: A graphical front-end to CVS/Subversion/git
# tkdiff: graphical side by side diff utility: GIT_EXTERNAL_DIFF
# git diff 
sudo apt-get install -y tkcvs
# dockers: allows dev and sysadmins to dev, ship, and run applications.
# docker Engine is container virtualization technology
# docker Hub is SAAS service for sharign and managing app stacks
sudo apt-get -y install docker.io
############################
# sw Development Utilities #
############################
# -----------------------------------------------------
# Common C++ Compilers: Moved far ahead of installations that 
# require these tools to ensure completion of all installation activity
# C++ installation moved to as far to the end as possible as it requires 
# the installation of C++ compilers to be completed 
# Install latest gcc 
sudo apt-get install -y gcc

# Install latest compile accelerators
sudo apt-get install -y cmake distcc ccache

# -----------------------------------------------------
# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
# Firewall blocks ports other than 80: getting the keyserver via port 80
sudo gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CEC45805
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update -y
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg
# Install cscope
sudo apt-get install -y cscope cscope-el
# gdb: GNU debugger
sudo apt-get install -y gdb
#
# DOXYGEN: Documentation system for C, C++, Java, Python and other languages
#
sudo apt-get install -y doxygen
# Message Sequence Charts: charts embedded in docs via \msc command
sudo apt-get install -y mscgen
# graphviz: rich set of graph drawing tools e.g. contains dot tool
# used by doxygen to display relationships
sudo apt-get install -y graphviz-dev
#####################
# JAVA installation #
#####################
# JRE
sudo apt-get install -y icedtea-7-plugin openjdk-7-jre
# JDK
sudo apt-get install -y openjdk-7-jdk
###################################
# JAVASCRIPT related installation #
###################################
#############################
# Node related installation #
#############################
# NOT INSTALLED
# Install nvm: node-version manager
#> wget -qO- https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
#> source $HOME/.nvm/nvm.sh
#> nvm install v0.10.12
#> nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
#> npm install -g jshint

#  rlwrap (readline wrapper) utility provides a command 
# history and editing of keyboard input for any other command
# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

###############################
# PYTHON related installation #
###############################
sudo apt-get install -y pychecker

###########################
# GO related installation #
###########################
sudo apt-get install -y golang
sudo apt-get install -y golang-mode

###############################
# HEROKU related installation #
###############################
# NOT INSTALLED
#> wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sudo -S sh

##########################
# R related installation #
##########################
# NOT INSTALLED
# -----------------------------------------------------
# R Package Installation is very unstable: commenting out all R related installation
# sudo apt-get install -y r-base
# Install ESS: R code within emacs
# sudo apt-get install -y ess
# Common R Packages ----------------------------------

# Installation of rgl package gave error:
# > "configure: error: missing required header GL/gl.h...
# >  * removing ‘/home/asarcar/R/x86_64-pc-linux-gnu-library/2.15/rgl’"
# Hence used the ubuntu binary distribution:
# sudo apt-get install -y r-cran-rgl

## Install latest packages not available in binary distribution by executing install within R
#> mkdir -p ~/R
#> pushd ~/R
## TODO: current all libraries for all R versions and 
## for all architectures will go in same directory
# R -e "install.packages(c('gclus', 'ggplot2', 'sm'), lib='~/R')"
# R -e "install.packages('pysch', lib='~/R')"
#> popd
# -----------------------------------------------------

###############################
# Octave related installation #
###############################
# NOT INSTALLED
# -----------------------------------------------------
sudo apt-get install -y octave gnuplot liboctave-dev
## Install latest packages not available in binary distribution
#> mkdir -p ~/octave
#> pushd ~/octave
#
# octave 3.8 is packaged for all Ubuntu versions >= 14.04
# From within Octave (>= 3.8) you need to manually install 
# appropriate versions of the control, general, image, 
# and signal packages.
# octave-prompt> pkg list -forge
# octave-prompt> pkg install -forge -local control general image signal
#

# Install libsvm: libsvm make fails due to warning: comment out
# wget http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/libsvm.cgi?+http://www.csie.ntu.edu.tw/~cjlin/libsvm+tar.gz
# mv libsvm.cgi\?+http\:%2F%2Fwww.csie.ntu.edu.tw%2F~cjlin%2Flibsvm+tar.gz libsvm.tar.gz
# tar xzvf libsvm.tar.gz
# rm -f libsvm.tar.gz
# pushd libsvm*/matlab
# octave --eval make
# mv *.mex ../..
# rm -f *.o
# popd 
#> popd
# -----------------------------------------------------
##############################
# Scala related installation #
##############################
# NOT INSTALLED
# -----------------------------------------------------
# No point in install scala in AWS EC2 micro VMs: not enough memory
# scala/scalac
# sudo apt-get install -y scala
# scala build tool (SBT)
#> mkdir -p ~/scala
#> pushd ~/scala
# sbt: Build tool for Scala/Java: 
# Beware!: This specifically installs sbt-0.12.4 version
# TODO: figure out a way to avoid "hardcoding" the version
# wget http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.4/sbt.tgz
# tar xzvf sbt.tgz
# pushd ~/bin
# ln -s ~/scala/sbt/bin/* .
# popd
#> popd
# -----------------------------------------------------
# Common C++ Development Libraries 
# Install common C++ packages: boost
sudo apt-get install -y libboost-all-dev

# Install common google packages
# libgoogle-perftools-dev includes tcmalloc
sudo apt-get install -y libprotobuf-dev libgtest-dev 
sudo apt-get install -y libgoogle-perftools-dev libsnappy-dev libleveldb-dev 
# Warning: Precise(12.04) has stopped supporting installation of glog and gflags: This may fail
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
# google-perftools: analyze profiled data beyond pprof: 'gprof' or 'google-pprof': 
# need both libgoogle-perftools-dev and google-perftools
sudo apt-get install -y google-perftools

# Google libgtest-dev static libraries not installed as binary: Build it
# Still required with Ubuntu 13.10/14.04
sudo mkdir -p /tmp/.build
pushd /tmp/.build
sudo cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest/
sudo make
sudo mv libg* /usr/lib
popd
# -----------------------------------------------------
# install dotfiles
# move prior incarnation of dotfiles and scripts to an old directory
pushd $HOME
if [ -d ./dotfiles/ ]; then
  mv --force --backup dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
  mv --force --backup .emacs.d .emacs.old
fi
if [ -d .env_custom/ ]; then
  mv --force --backup .env_custom .env_custom.old
fi
if [ -d .ssh/ ]; then
  if [ -f .ssh/config ]; then
    mv --force --backup .ssh/config .ssh/config.old
  fi
fi
# pop out of $HOME directory
popd

########################
# Personal Environment #
########################
# -----------------------------------------------------
# Personal Third Party SW Installed Binary & Scripts Directory
mkdir -p $HOME/bin
pushd $HOME/bin
# wget file if timestamp of remote is newer than the previous timestamp
# Note: wget by default retains the timestamp of the remote server
wget -N http://google-styleguide.googlecode.com/svn/trunk/cpplint/cpplint.py
popd
# Copy all scripts to bin directory: \cp: use non interactive version
# u: timestamp; b: backup; f: force; p: respect permissions
\cp -ubfp scripts/* $HOME/bin
# Copy the new scripts and dotfiles to $HOME
cp -r dotfiles $HOME
pushd $HOME
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.profile .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sf dotfiles/.emacs.d .
ln -sb dotfiles/.gitignore .
ln -sb dotfiles/.Rprofile .
ln -sb dotfiles/.octaverc .
ln -sb dotfiles/.env_custom .
ln -sb dotfiles/.env_custom/.gitconfig_custom .gitconfig
# ln messes up the permission of .ssh/config file - cp instead
# ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
\cp -ubfp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# create a database for all the files in the filesystem
sudo updatedb
