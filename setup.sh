#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# You may set up system to accept without password for subsequent commands:
# > echo password | sudo -S ls -al
# close the terminal afterwards since we now have unrestricted sudo access"

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

############################################################################################
# Start with a clean slate: update, upgrade, cleanup, etc.
# apt-utils: package management related utility programs
# update: list of available packages and their versions
# upgrade: install the newest versions
# autoclean: remove partial packages
# clean: remove .deb packages that apt caches when we install/update programs
# autoremove: remove packages installed as dependencies after original package is removed
sudo apt-get install -y apt-utils
sudo apt-get -y update
# Upgrade to the latest packages: remove obsoleted packages
sudo apt-get -y upgrade --fix-missing
sudo apt-get -y autoclean
sudo apt-get -y clean
sudo apt-get -y autoremove
############################################################################################

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
# git: distributed version control system - installed at machine set up phase
# > sudo apt-get install -y git
# mercurial: easy-to-use, scalable distributed version control system
# Many package from Google are available in Mercurial
# Example: go protobuf/tools
sudo apt-get install -y mercurial
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
# bridge utilities allows one to run brctl functions
sudo apt-get install -y bridge-utils
# clip for copy and paste: cat xyz | xclip -sel clip
sudo apt-get install -y xclip
#################################################################################
# Docker Installation: https://docs.docker.com/engine/installation/linux/centos/
# dockers: allows dev and sysadmins to dev, ship, and run applications.
# docker Engine is container virtualization technology
# docker Hub is SAAS service for sharing and managing app stacks
# https://docs.docker.com/engine/installation/linux/ubuntulinux/
# Ensure APT works with https method. CA certificates are installed
sudo apt-get install -y apt-transport-https 
sudo apt-get install -y ca-certificates
# Add GPG key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# WARNING: We only support Trust (14.04), Wily (15.10), and Xenial (16.04) installation
dockerinstall="yes"
modernrelease="yes"
if [ $(lsb_release -rs) == "14.04" ]; then
    relname="trusty"
    modernrelease="no"
elif [ $(lsb_release -rs) == "15.10" ]; then
    relname="wily"
elif [ $(lsb_release -rs) == "16.04" ]; then
    relname="xenial"
else
    dockerinstall="no"
    echo "Docker installation only supported for 14.04 (trusty), 15.10 (wily), or 16.04 (xenial)"
fi

if [ $dockerinstall == "yes" ]; then
    echo "deb https://apt.dockerproject.org/repo ubuntu-$relname main" | \
    sudo tee /etc/apt/sources.list.d/docker.list 
    # Purge old repo
    sudo apt-get purge lxc-docker -y
    # Update the APT package index
    sudo apt-get -y update
    # verify that APT is pulling the right repository: 
    # APT pulls from the new repo when you run apt-get upgrade 
    # > apt-cache policy docker-engine
    # linux-image-extra: allows use of aufs storage driver
    sudo apt-get install -y linux-image-extra-$(uname -r)
    # install docker & run the service
    sudo apt-get install -y docker-engine
    sudo service docker start
    # * Allow communicating with docker daemon as user
    # docker daemon listens to Unix socket owned by root 
    # create Unix group docker and add user to groups docker 
    # to allow RD/WR to the socket i.e. communication with docker group
    sudo usermod -aG docker `whoami`
    # log out and log back as that triggers user running with correct permissions
    # verify that docker may be run with sudo
    # > docker run hello-world
    # configure docker to start on boot
    # Ubuntu uses systemd as its boot and service manager 15.04 onwards and 
    # upstart for versions <14.10 - installation configures upstart for 14.04 
    if [ $modernrelease == "yes" ]; then
	sudo systemctl enable docker
    fi
fi
#################################################################################

############################
# sw Development Utilities #
############################
# -----------------------------------------------------
# Common python3 utilities
# packaged with Ubuntu versions 14.04 
sudo apt-get install -y python3-numpy python3-scipy python3-matplotlib 
sudo apt-get install -y ipython3 ipython3-notebook python3-pandas python3-nose
sudo apt-get install -y build-essential python3-dev python3-setuptools python3-pip
# atlas3gf not yet available on Xenia (16.04) release
sudo apt-get install -y libatlas-dev libatlas3-base
# ensure atlas is used to provide the implementation of the blas and lapack linear algebra routines
sudo update-alternatives --set libblas.so.3 /usr/lib/atlas-base/atlas/libblas.so.3
sudo update-alternatives --set liblapack.so.3 /usr/lib/atlas-base/atlas/liblapack.so.3
# --user: avoids root permission by installin in $home/.local to ignore old scikit-learn installation 
# while for numpy and scipy. 
# --install-option="--prefix=" required if python has a distutils.cfg cfg with prefix= entry.
pip3 install --user --install-option="--prefix=" --upgrade scikit-learn
pip3 install --user --install-option="--prefix=" --upgrade Flask
# -----------------------------------------------------

# Install latest compile accelerators
sudo apt-get install -y cmake distcc ccache

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


############################################################################################
# Update, Upgrade, Clean: now that all packages have been listed and installed:
# apt-utils: package management related utility programs
# update: list of available packages and their versions
# upgrade: install the newest versions
# autoclean: remove partial packages
# clean: remove .deb packages that apt caches when we install/update programs
# autoremove: remove packages installed as dependencies after original package is removed
sudo apt-get install -y apt-utils
sudo apt-get -y update
# Upgrade to the latest packages: remove obsoleted packages
sudo apt-get -y upgrade --fix-missing
sudo apt-get -y autoclean
sudo apt-get -y clean
sudo apt-get -y autoremove
############################################################################################

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

###############################
# HEROKU related installation #
###############################
# NOT INSTALLED
# > wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sudo -S sh

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
#> mkdir -p ~/sw_installs/scala
#> pushd ~/sw_installs/scala
# sbt: Build tool for Scala/Java: 
# Beware!: This specifically installs sbt-0.12.4 version
# TODO: figure out a way to avoid "hardcoding" the version
#> wget http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.4/sbt.tgz
#> tar xzvf sbt.tgz
#> pushd ~/bin
#> ln -s ~/scala/sbt/bin/* .
#> popd
#> popd
# -----------------------------------------------------
# Common C++ Development Libraries 
# Install common C++ packages: boost
sudo apt-get install -y libboost-all-dev

# Install common google packages
# libgoogle-perftools-dev includes tcmalloc
sudo apt-get install -y libgtest-dev 
sudo apt-get install -y libgoogle-perftools-dev libsnappy-dev libleveldb-dev 
# Warning: Precise(12.04) has stopped supporting installation of glog and gflags: This may fail
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
# google-perftools: analyze profiled data beyond pprof: 'gprof' or 'google-pprof': 
# need both libgoogle-perftools-dev and google-perftools
sudo apt-get install -y google-perftools

# Install Zero Message Queue
sudo apt-get install -y libzmq3-dev

###########
# Local installs for packages. Use when
# - Need features of versions not up to date in distributions
# - When binaries are not installed appropriately
#
sudo mkdir -p /tmp
pushd /tmp
#####
# Google libgtest-dev static libraries not installed as binary: Build it
# Still required with Ubuntu 13.10/14.04
sudo mkdir -p .build
pushd .build
sudo cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest/
sudo make
sudo mv libg* /usr/lib
popd
#####

#####
# Google libprotobuf-dev: grpc needs proto 3. Packaged version comes with proto 2 
# Still required with Ubuntu 13.10/14.04
git clone git@github.com:google/protobuf.git
pushd protobuf
# source from github, generate the configure script first:
# autogen script needs autoreconf available in dh-autoreconf package
sudo apt-get install -y dh-autoreconf
./autogen.sh
# Most packages install in /usr (include, lib, and bin)
# Protobuf installs in /usr/local/ (include, lib, and bin)
# Instead of changing LD_LIBRARY_PATH & running ldconfig
# we choose to install protobuf in /usr as any other package
./configure --prefix=/usr
make check
sudo make install
popd

#####
# Google gRPC: Debian 'jessie-backports' distribution i.e.
# deb http://http.debian.net/debian jessie-backports main
# even when appended to /etc/apt/sources.list
# does not work until 14.04 to add gRPC.
git clone https://github.com/grpc/grpc.git 
pushd grpc 
git submodule update --init 
make
sudo make install prefix=/usr
popd
#####

#####
# Go: Gustavo Niemeyer from Q2'15 is not pushing Go to Ubuntu
# The recommended way is to use godeb to get the latest installs
# Ubuntu 14.04LTS installs only 1.2.1 version of Go
# > sudo apt-get install -y golang golang-mode golang-go.tools
#
mkdir -p go_tmp
pushd go_tmp
# We need godeb to bootstrap the go installation process
# Install golang in Ubuntu packages if not already installed
# Needed to boot the install process of godeb
command -v go > /dev/null 2>&1 || sudo apt-get install -y golang

# Remove previous version of go package that may (or not) 
# have been installed from Ubuntu repos
GOPATH=`pwd` go get gopkg.in/niemeyer/godeb.v1/cmd/godeb
sudo apt-get remove --purge -y golang golang-go golang-doc golang-go.tools
sudo apt-get autoremove -y
./bin/godeb install
popd
#####

popd
###########

########################
# Personal Environment #
########################
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
if [ -f .emacs ]; then
    mv .emacs .emacs.old
fi
# pop out of $HOME directory
popd

# -----------------------------------------------------
# Personal Third Party SW Installed Binary & Scripts Directory
mkdir -p $HOME/bin
pushd $HOME/bin
# wget file if timestamp of remote is newer than the previous timestamp
# Note: wget by default retains the timestamp of the remote server
wget -N https://github.com/google/styleguide/tree/gh-pages/cpplint/cpplint.py
chmod +x cpplint.py
popd
# -----------------------------------------------------
# Copy all scripts to bin directory: cp: use non interactive version
# u: timestamp; b: backup; f: force; p: respect permissions
cp -ubfp scripts/* $HOME/bin
# -----------------------------------------------------
# Copy the new scripts and dotfiles to $HOME
cp -r dotfiles $HOME
pushd $HOME
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bash_prompt .
ln -sb dotfiles/.exports .
ln -sf dotfiles/.emacs.d .
ln -sb dotfiles/.gdbinit .
ln -sb dotfiles/.gitignore .
ln -sb dotfiles/.inputrc .
ln -sb dotfiles/.octaverc .
ln -sb dotfiles/.profile .
ln -sb dotfiles/.Rprofile .
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.env_custom .
ln -sb dotfiles/.env_custom/.gitconfig_custom .gitconfig
# ln messes up the permission of .ssh/config file - cp instead
# ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
cp -ubfp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# create a database for all the files in the filesystem
sudo updatedb
