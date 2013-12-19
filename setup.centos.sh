#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

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

# Upgrade to the latest packages: remove obsoleted packages
sudo yum upgrade

####################
# Common Utilities #
####################
# screen: multiple work sessions on a terminal
sudo yum install -y screen 
# rlwrap: command completion and histor
sudo yum install -y rlwrap
# iftop: Command line tool that displays bandwidth usage on an interface
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum install -y iftop
# sysstat: sar (system activity report) and iostat monitoring commands
sudo yum install -y sysstat
# telnet client
sudo yum install -y telnet

# Install Git - installed by default
# Install gdb - installed by default
# Install emacs24 - emacs23 available as binary package - emacs24 not yet available as binary
# Install cscope - installed by default

# Install memcached
# 1. Install Remi dependency on Centos
# 2. Ensure that configuration options are correctly set
# > nano -w /etc/sysconfig/memcached
#   CACHESIZE='8192'; OPTIONS="-l 192.168.0.1"
# 3. Start the memcached service on bootup and 
#    start it now as well (for idempotency stop the service before starting)
sudo yum install -y memcached-devel
sudo chkconfig memcached on
sudo service memcached stop
sudo service memcached start
#    Validate the service is up
# > echo "stats settings" | nc 192.168.0.1 11211
# > memcached-tool 192.168.0.1:11211 
# 4. Install the client side library to exercise memcached: libmemcached
sudo yum install -y libmemcached-devel

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
# Centos seems to create a .emacs file by default
if [ -f .emacs ]; then
    mv .emacs .emacs.old
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
# ln messes up the permission of .ssh/config file - cp instead
# ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
cp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# Common C++ Development Libraries 

# gcc - already installed 
# Install common C++ packages: libboost-all-dev: NOT available in yum 
# Install latest compile accelerators: distcc: NOT available in yum
sudo yum install -y cmake ccache

# Install common google packages: NONE of the below mentioned are available in yum 
# libgoogle-perftools-dev libgtest-dev libgoogle-perftools-dev 
# libsnappy-dev libleveldb-dev libgoogle-glog-dev libgflags-dev
sudo yum install -y protobuf

# Google Flags: Not available via binary yum: install gflags-2.0 (dependency on gflags-devel) 
# and gflags-devel-2.0 via RPM
sudo rpm -Uvh https://gflags.googlecode.com/files/gflags-2.0-1.amd64.rpm https://gflags.googlecode.com/files/gflags-devel-2.0-1.amd64.rpm
# Google Log: Not available via binary yum: install glog-2.0 (dependency on glog-devel) 
# and glog-devel via RPM
pushd /tmp
wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.g
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

