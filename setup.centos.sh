#!/bin/bash
# Simple setup.centos.sh for configuring Centos instances for headless setup. 

# Set up system to accept without password for subsequent commands
echo ">> execute 'echo password | sudo -S ls -al' so that subsequent sudo commands do not require password"
echo ">> close the terminal afterwards since we now have unrestricted sudo access"

if [ $# -ne 0 ]; then
  echo "Usage: setup.centos.sh"
  exit 2 
fi

# Validate that the command is executed where setup.sh and 
# dotfiles are available: else terminate execution of script
# and spew out a WARNING sign and exit
if [ ! -f setup.centos.sh ]; then
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

## 
# Disable security and privilege levels of command execution "SELINUX=disabled"
sed -e s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config | sudo tee /etc/selinux/config > /dev/null
# Turn off firewalls for IPTables IP6Tables
sudo chkconfig iptables off
sudo chkconfig ip6tables off

#############
# UTILITIES #
#############
# tree: displays directory tree in color
sudo yum install -y tree
# rlwrap: command completion and history 
sudo yum install -y rlwrap
# screen: multiple work sessions on a terminal
sudo yum install -y screen 
# iftop: Command line tool that displays bandwidth usage on an interface
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum install -y iftop
# git: distributed version control system
# Install git-core - installed by default
# dos2unix ("flip" not available?): remove CR & LF in dos to LF for unix
sudo yum install -y dos2unix
# lshw: Hardware Lister
sudo yum install -y lshw
# hwloc/lstopo: provides a portable abstraction of hierarchical architectures 
sudo yum install -y hwloc
# sysstat: sar (system activity report) and iostat monitoring commands
sudo yum install -y sysstat
# telnet client
sudo yum install -y telnet
# graphviz: rich set of graph drawing tools e.g. contains dot tool
# used by doxygen to display relationships
sudo yum install -y graphviz-dev
# sshpass: allows one to execute ssh without submitting password:
# sshpass -p 'passwd' ssh user@host command: available in epel-release*rpm release package
sudo yum install -y sshpass
# sendmail: powerful, efficient, and scalable Mail Transport Agent
sudo yum install -y sendmail
# dockers: allows dev and sysadmins to dev, ship, and run applications.
# docker Engine is container virtualization technology
# docker Hub is SAAS service for sharign and managing app stacks
# docker: CentOS-7: included in Extras Repol; CentOS-6 install docker-io
sudo yum install -y docker
############################
# SW Development Utilities #
############################
# -----------------------------------------------------
# Common C++ Compilers: Moved far ahead of installations that 
# require these tools to ensure completion of all installation activity
# C++ installation moved to as far to the end as possible as it requires 
# the installation of C++ compilers to be completed 
# Install latest gcc 
#
# Install latest gcc - already installed 

# Install latest compile accelerators: distcc: NOT available in yum

sudo yum install -y cmake ccache

# -----------------------------------------------------
# Install emacs24 - emacs23 available as binary package - emacs24 not yet available as binary
# Install cscope - installed by default
# Install gdb - installed by default
# https://launchpad.net/~cassou/+archive/emacs
# -----------------------------------------------------
# doxygen: Documentation system for C, C++, Java, Python and other languages
sudo yum install -y doxygen
# graphviz: rich set of graph drawing tools e.g. contains dot tool
# used by doxygen to display relationships
sudo yum install -y graphviz-dev
# -----------------------------------------------------
# Personal Third Party SW Installs & Binary Directory
mkdir -p ~/bin
pushd ~/bin
wget http://google-styleguide.googlecode.com/svn/trunk/cpplint/cpplint.py
popd
# -----------------------------------------------------
# -----------------------------------------------------
# Common C++ Development Libraries 
# Install common C++ packages: libboost-all-dev: NOT available in yum 
# Install common google packages: NONE of the below mentioned are available in yum 
# libgoogle-perftools-dev libgtest-dev libgoogle-perftools-dev 
# libsnappy-dev libleveldb-dev libgoogle-glog-dev libgflags-dev
# google-perftools: analyze profiled data: useful when pprof is not adequate
sudo yum install -y protobuf

# Google Flags: Not available via binary yum: install gflags-2.0 (dependency on gflags-devel) 
# and gflags-devel-2.0 via RPM
sudo rpm -Uvh https://gflags.googlecode.com/files/gflags-2.0-1.amd64.rpm https://gflags.googlecode.com/files/gflags-devel-2.0-1.amd64.rpm
# Google Log: Not available via binary yum: install glog-2.0 (dependency on glog-devel) 
# and glog-devel via RPM
pushd /tmp
wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar xzvf glog-0.3.3.tar.gz
cd glog-0.3.3
export CMAKE_PREFIX_PATH=/usr
cd google-glog
./configure --prefix=$CMAKE_PREFIX_PATH
make
sudo make install
popd
# Libraries are installed in lib instead of lib64: make sure it is added to lib64
# 1. Add /usr/lib to a conf file in ld.so.conf.d directory: we create a new google-libs.conf
echo "/usr/lib" | sudo tee /etc/ld.so.conf.d/google-libs.conf > /dev/null
# 2. Re-Run ldconfig to load this library as well
sudo ldconfig
# -----------------------------------------------------

###################
# SW Applications #
###################
# Install memcached
# 1. Install Remi dependency on Centos
# 2. Ensure that configuration options are correctly set
# > nano -w /etc/sysconfig/memcached
#   CACHESIZE='8192'; OPTIONS="-l 192.168.0.1"
# 3. Start the memcached service on bootup and 
#    start it now as well (for idempotency stop the service before starting)
# sudo yum install -y memcached-devel
# sudo chkconfig memcached on
# sudo service memcached stop
# sudo service memcached start
#    Validate the service is up
# > echo "stats settings" | nc 192.168.0.1 11211
# > memcached-tool 192.168.0.1:11211 
# 4. Install the client side library to exercise memcached: libmemcached
# sudo yum install -y libmemcached-devel


############################################################################################
# Now that all packages have been listed and installed:
# yum-utils: package management related utility programs
# update: list of available packages and their versions
# upgrade: install the newest versions
# package-cleanup --dupes: remove duplicate packages
# clean: remove packages that yum caches when we install/update programs
sudo yum install -y yum-utils
sudo yum -y update
sudo yum -y upgrade
# Find/Review unused packages: package-cleanup --leaves
# Find/Review lost packages: package-cleanup --orphans
sudo package-cleanup --dupes
sudo package-cleanup --cleandupes
sudo yum clean -y all
############################################################################################


###########################
# Miscellaneous Languages #
###########################
# Javascript, Node, Python, Heroku, etc. not installed
# R, Octave, etc. not installed
# -----------------------------------------------------
########################
# Personal Environment #
########################
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
if [ -d .ssh/ ]; then
    if [ -f .ssh/config ]; then
        mv .ssh/config .ssh/config.old
    fi
fi
# Centos seems to create a .emacs file by default
if [ -f .emacs ]; then
    mv .emacs .emacs.old
fi
# pop out of $HOME directory
popd

# Copy the new dotfiles inside this git directory to $HOME
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
cp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------


