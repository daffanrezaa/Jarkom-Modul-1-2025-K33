# di Eru
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY" -O kitab_penciptaan.zip
unzip kitab_penciptaan.zip
service vsftpd restart
ftp 10.80.1.1

# capture wireshark

# login as ainur
put kitab_penciptaan.txt

# di Manwe
service vsftpd restart
ftp 10.80.1.1

# login as ainur
get kitab_penciptaan.txt

# di Eru
chmod 555 /srv/ftp/shared
service vsftpd restart

# di Manwe
echo "hai" > test.txt
ftp 10.80.1.1

# login as ainur
put test.txt

#stop capture wireshark