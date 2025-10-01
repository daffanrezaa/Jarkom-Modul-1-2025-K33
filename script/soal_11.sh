# di Melkor
apt-get install -y openbsd-inetd telnetd
nano /etc/inetd.conf

# jalankan wireshark capture 
telnet stream tcp nowait root /usr/sbin/tcpd /usr/sbin/telnetd

service openbsd-inetd restart

# tambahkan user dan ganti passwd
useradd -m -s /bin/bash melkor
echo "melkor:melkor" | chpasswd

# di Eru
telnet 10.80.1.2

# login sesuai user yang dibuat pada melkor
# stop wireshark cek usn dan passwd