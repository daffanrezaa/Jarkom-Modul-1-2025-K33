#masukkan config ke /root/.bashrc
# di ERU:
apt update && apt install -y iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf

# di CLIENT:
echo nameserver 192.168.122.1 > /etc/resolv.conf
