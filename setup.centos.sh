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

# Assumed the following are taken care: 
# 1. As ROOT: Add User
# > useradd asarcar
# > passwd asarcar
# 2. As ROOT: Allow User to execute Sudo: edit /etc/sudoers file 
#    Add the following line at end "asarcar ALL=(ALL)       ALL"
# > visudo 
# 3. Disable security and privilege levels of command execution "SELINUX=disabled"
# > sudo vi /etc/selinux/config
# 4. Turn off firewalls for IPTables IP6Tables
# > sudo chkconfig iptables off
# > sudo chkconfig ip6tables off
# 5. Ensure that ethernet ports are enabled by default on boot with DHCP enabled if appropriate
# > sudo vi /etc/sysconfig/network-scripts/ifcfg-eth<n>
#   ONBOOT=yes 
#   BOOTPROTO=dhcp or BOOTPROTO=none
# > service network restart
#   Validate the ethernet ports are correctly set and configured
# > ethtool eth<n> 
# Install screen
sudo yum install -y screen 

# Install Git - installed by default
# Install gdb - installed by default
# Install emacs24 - emacs23 available as binary package - emacs24 not yet available as binary
# Install cscope - installed by default

# Install memcached
# 1. Install Remi dependency on Centos
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
sudo yum --enablerepo=remi install -y memcached
# 2. Ensure that configuration options are correctly set
# > nano -w /etc/sysconfig/memcached
#   CACHESIZE='8192'; OPTIONS="-l 192.168.0.1"
# 3. Start the memcached service on bootup and 
#    start it now as well (for idempotency stop the service before starting)
sudo chkconfig memcached on
sudo service memcached stop
sudo service memcached start
#    Validate the service is up
# > echo "stats settings" | nc 192.168.0.1 11211

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
# ln messes up the permission of .ssh/config file - cp instead
# ln -sb ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
cp ~/dotfiles/.env_custom/.sshconfig_custom .ssh/config
popd
# -----------------------------------------------------

# Common C++ Development Libraries 

# gcc - already installed 
# Install common C++ packages: libboost-all-dev: NOT available in yum 
# Install latest compile accelerators: distcc: NOT available in yum
yum install -y cmake ccache

# Install common google packages: NONE of the below mentioned are available in yum 
# libgoogle-perftools-dev libprotobuf-dev libgtest-dev libgoogle-perftools-dev 
# libsnappy-dev libleveldb-dev libgoogle-glog-dev libgflags-dev

# -----------------------------------------------------

