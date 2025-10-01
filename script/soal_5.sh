#masukkan config ke /root/.bashrc
# di ERU:
apt update && apt install -y iptables
apt-get install vsftpd -y
apt install netcat
apt install ftp -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf

# di CLIENT:
apt update && apt install unzip -y

apt install netcat-traditional
apt install ftp -y
echo nameserver 192.168.122.1 > /etc/resolv.conf
