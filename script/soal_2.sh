#di Eru
auto eth0
iface eth0 inet dhcp

apt install iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16
