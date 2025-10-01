# di Eru
apt install openssh-server -y
service ssh restart
netstat -tuln | grep :22

# di Varda
ssh ainur@10.80.1.1