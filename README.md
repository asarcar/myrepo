# setup.git
# =========
# Clone and run this on a new EC2 instance running Ubuntu to
# configure both the machine and your individual development 
# environment as follows:

#
# 1. Go to junk and record all actions in case one has to undo
mkdir -p $HOME/junk
pushd $HOME/junk

# Start script to record what all exactly has been run/installed/etc.
#$$$$$$$$$$$$$$$
script
popd # pop out of junk folder

#!!!!!!!!!!!!!!!
# 2. ensure that the .ssh config and id_rsa/dsa keys are set
# to at least allow access to user's Github repository 
mkdir -p $HOME/.ssh
pushd $HOME/.ssh

# Copy id_dsa for github from another m/c to this machine
# scp user@mc:.ssh/id_dsa.github* .

mv config config.bck # copy previous config file if it exists

# All access to GitHub - set ssh config
echo "Host github.com" > config
echo "Hostname github.com" >> config
echo "Port 22" >> config
echo "IdentityFile ~/.ssh/id_dsa.github" >> config

popd # Move out of .ssh directory
#!!!!!!!!!!!!!!!

#---------------
# 3. Install git 
# 4. Check out the envirorment scripts and custom files
sudo apt-get install -y git-core
mkdir -p $HOME/git
pushd $HOME/git
git clone git@github.com:asarcar/myrepo.git

#***************
# 5.
pushd $HOME/git/myrepo/
./setup.sh   
popd # pop out of myrepo folder
#***************

popd # pop out of git folder
#---------------

exit # exit out of script recording
#$$$$$$$$$$$$$$$

# See also http://github.com/startup-class/dotfiles and
# [Startup Engineering Video Lectures 4a/4b]
# (https://class.coursera.org/startup-001/lecture/index)
# for more details.





