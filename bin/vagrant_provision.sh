#!/bin/bash

#Keep package updated before making changes
apt-get update -y
apt-get upgrade -y

#Create a development user different than vagrant
useradd uruk

echo "uruk ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/uruk
chmod 0440 /etc/sudoers.d/uruk
usermod --shell /bin/bash uruk

mkdir -p /home/uruk/.ssh
touch /home/uruk/.ssh/authorized_keys
chmod 0700 /home/uruk/.ssh
chmod 0644 /home/uruk/.ssh/authorized_keys

chown -R uruk:uruk /home/uruk

cp /etc/skel/.bashrc ./.bashrc


# Key Management
# sudo su vagrant -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'
# sudo su root -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'
sudo su uruk -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'

# SSH Configuration management
if [ -z "$( cat /etc/ssh/sshd_config | grep AllowTcpForwarding)" ]
then
	echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
else
	sed -i '/#AllowTcpForwarding yes/c\AllowTcpForwarding yes' /etc/ssh/sshd_config	
fi

systemctl restart sshd.service

# Preparing a git environment that can connecto to my github repo
mkdir -p /home/uruk/git
chmod 0700 /home/uruk/git
chown -R uruk:uruk /home/uruk/git

## Specific key for Github.
cp /tmp/provision/temp_private_key_for_github /home/uruk/.ssh/id_ed25519
chmod 0600 /home/uruk/.ssh/id_ed25519
chown -R uruk:uruk /home/uruk/.ssh/id_ed25519

## Git author properties
su uruk -c "git config --global user.name \"Michel JACQUES\""
su uruk -c "git config --global user.email \"michel.jacques@polymtl.ca\""

# Install development environment
apt-get install python3-pip -y


# Clean up
rm -rf /tmp/provision

