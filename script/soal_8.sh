# di ulmo:
apt install ftp -y
apt install vsftpd -y

# capture wireshark di ulmo -> switch 2

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=11ra_yTV_adsPIXeIPMSt0vrxCBZu0r33" -O ramalan_cuaca
unzip ramalan_cuaca
# ramalan cuaca contains: mendung.jpg dan cuaca.txt

# di eru: 
service vsftpd start

# di ulmo:
ftp 10.80.2.1

# login as ainur
put cuaca.txt
put mendung.jpg

# di eru: cek ls apakah cuaca dan mendung ada