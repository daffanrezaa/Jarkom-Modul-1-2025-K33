# di Manwe
apt install ftp -y
apt install inetutils-ftp -y

# di Eru
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY" -O kitab_penciptaan.zip

# batasi izin
nano /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=NO
chroot_local_user=YES
allow_writeable_chroot=YES

# capture wireshark

#di Eru
service vsftpd start

# di Manwe
ftp 10.80.1.1
#login as ainur
get kitab_penciptaan.zip
delete kitab_penciptaan.zip
