# setup.git
# =========
# Clone and run this on a new EC2 instance running Ubuntu to
# configure both the machine and your individual development 
# environment as follows:

#
# 1. Go to junk and record all actions in case one has to undo
cd
mkdir -p junk
cd junk

# Start script to record what all exactly has been run/installed/etc.
#$$$$$$$$$$$$$$$
script
cd # pop out of junk folder

#!!!!!!!!!!!!!!!
# 2. ensure that the .ssh config and id_rsa/dsa keys are set
# to at least allow access to user's Github repository 
cd # move to home directory   	     
mkdir -p .ssh
cd .ssh

# Copy id_dsa for github from another m/c to this machine
# scp user@mc:.ssh/id_dsa.github* .

mv config config.bck # copy previous config file if it exists

# All access to GitHub - set ssh config
echo "Host github.com" > config
echo "Hostname github.com" >> config
echo "Port 22" >> config
echo "IdentityFile ~/.ssh/id_dsa.github" >> config

cd # Move out of .ssh directory to home directory
#!!!!!!!!!!!!!!!

#---------------
# 3. Install git 
# 4. Check out the environment scripts and custom files
sudo apt-get install -y git-core
cd # move to home directory
mkdir -p git
cd git
git config --global user.name "Arijit Sarcar"
git config --global user.email "sarcar_a@yahoo.com"
git clone git@github.com:asarcar/myrepo.git

#***************
# 5. Execute the installation script inside a screen session so that you 
#    monitor the progress from any place
screen -S dev-ops

cd # move to home directory
cd git/myrepo/
./setup.sh   

### Update names and identity if working with alternate 
### repository identity (e.g. sarcar2).
### Edit ~/.ssh/config file to ensure github ssh points to the correct DSA key
#> git config --global user.name "Arijit Sarcar"
#> git config --global user.email "asarcar@yahoo.com"
#> cd # move to home directory
#> cd .ssh
#> Replace "IdentityFile ~/.ssh/id_dsa.github" with
# "IdentityFile ~/.ssh/id_dsa.sarcar2.github"

# exit the screen session if you so desire now that the job is complete
#***************

exit # exit out of script recording
#$$$$$$$$$$$$$$$


# Instructions in case running NODE.JS javascript:
# See also http://github.com/startup-class/setup to install prerequisite
# programs. If all goes well, in addition to a more useful prompt, now you can
# do `emacs -nw hello.js` and hitting `C-c!` to launch an interactive SSJS
# REPL, among many other features. See the
# See also http://github.com/startup-class/dotfiles and
# [Startup Engineering Video Lectures 4a/4b]
# (https://class.coursera.org/startup-001/lecture/index)
# for more details.
