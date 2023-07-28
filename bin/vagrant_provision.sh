#!/bin/bash

dev_user="uruk"
dev_user_home_folder="/home/${dev_user}"

#Keep package updated before making changes
apt-get update -y
apt-get upgrade -y

#Create a development user different than vagrant
useradd ${dev_user}

echo "${dev_user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${dev_user}
chmod 0440 /etc/sudoers.d/${dev_user}
usermod --shell /bin/bash ${dev_user}

mkdir -p ${dev_user_home_folder}/.ssh
touch ${dev_user_home_folder}/.ssh/authorized_keys
chmod 0700 ${dev_user_home_folder}/.ssh
chmod 0644 ${dev_user_home_folder}/.ssh/authorized_keys

cp /etc/skel/.bashrc ${dev_user_home_folder}/.bashrc
chmod 0700 ${dev_user_home_folder}/.bashrc

cp /etc/skel/.bashrc ${dev_user_home_folder}/.profile
chmod 0700 ${dev_user_home_folder}/.profile
# echo "export PATH=\"$PATH:${dev_user_home_folder}/.local/bin\"" >> ${dev_user_home_folder}/.bashrc


chown -R ${dev_user}:${dev_user} ${dev_user_home_folder}




# Key Management
# sudo su vagrant -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'
# sudo su root -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'
sudo su ${dev_user} -c 'cat /tmp/provision/temp_pub_key.pub >> ~/.ssh/authorized_keys'

# SSH Configuration management
if [ -z "$( cat /etc/ssh/sshd_config | grep AllowTcpForwarding)" ]
then
	echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
else
	sed -i '/#AllowTcpForwarding yes/c\AllowTcpForwarding yes' /etc/ssh/sshd_config	
fi

systemctl restart sshd.service

# Preparing a git environment that can connecto to my github repo
mkdir -p ${dev_user_home_folder}/git
chmod 0700 ${dev_user_home_folder}/git
chown -R ${dev_user}:${dev_user} ${dev_user_home_folder}/git

## Specific key for Github.
cp /tmp/provision/temp_private_key_for_github ${dev_user_home_folder}/.ssh/id_ed25519
chmod 0600 ${dev_user_home_folder}/.ssh/id_ed25519
chown -R ${dev_user}:${dev_user} ${dev_user_home_folder}/.ssh/id_ed25519

## Git author properties
su ${dev_user} -c "git config --global user.name \"Michel JACQUES\""
su ${dev_user} -c "git config --global user.email \"michel.jacques@polymtl.ca\""

# Install development environment
apt-get install python3-pip -y


# Clean up
rm -rf /tmp/provision

