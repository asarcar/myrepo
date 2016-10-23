SSHD Server Installation
-------------------------
# Copy base config as backup
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults

# Install, Start, and Validate Service
sudo apt-get install -y openssh-server
sudo service ssh start
sudo service ssh status
# Validate if needed: tail -f /var/log/syslog | grep sshd 

# Ensure SSHD service is always started on boot: 
sudo update-rc.d ssh defaults
# Validate SSHD service will start on boot
ls /etc/rc*.d | grep ssh

# Undo if needed: sudo update-rc.d -f ssh remove




