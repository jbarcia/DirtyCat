# /bin/bash

if [ ! -f /home/user/slit.sh ]
then
        echo "Place slit here: /home/user/slit.sh"
        exit
fi

chmod +x /home/user/slit.sh
sudo apt-get -y -q install uml-utilities screen
# Slit Setup
sudo sh -c "echo 1 tunnel >> /etc/iproute2/rt_table"
#sudo -u root ssh-keygen
ssh-keygen
sudo mkdir -p /root/.ssh/
sudo cp -r ~/.ssh/* 
sudo chown root:root /root/.ssh/
sudo chmod 755 /root/.ssh/
sudo chmod 600 /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/id_rsa

echo -e "\n Enter IP address of VPS:"
read SERVER
echo -e "\n Enter the username for the box:"
read SERVUSR

#sudo -u root cat /root/.ssh/id_rsa.pub | ssh $SERVUSR@$SERVER 'cat - >> ~/.ssh/authorized_keys'
sudo -u root ssh-copy-id -i -f $SERVUSR@$SERVER

sudo sh -c "echo PermitRootLogin without-password | ssh $SERVUSR@$SERVER 'cat - >> /etc/ssh/sshd_config'"
sudo sh -c "echo PermitTunnel yes | ssh $SERVUSR@$SERVER 'cat - >> /etc/ssh/sshd_config'"
sudo -u root ssh -t $SERVUSR@$SERVER sudo service ssh restart


echo -e "\n Enter the ports to reverse ex. 80,443 (no spaces):"
read PORTS
sudo -u root screen -dmS slit /home/user/slit.sh $SERVER $PORTS
# mail -> sudo -u root screen -dmS slit /home/user/slit.sh 172.106.194.179 80,443,25,587,465,110,995,143,993
