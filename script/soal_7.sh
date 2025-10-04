# Jalan di Eru:
apt install ftp -y
apt-get install vsftpd -y

# Buat folder ftp, buat user ainur dan melkor:
mkdir -p /srv/ftp/shared
adduser ainur   
adduser melkor

# Set folder yang akan di akses oleh ainur dan melkor
usermod -d /srv/ftp/shared ainur 
usermod -d /srv/ftp/shared melkor

# Memberi akses owner ke ainur pada direktori /srv/ftp/shared
chown ainur:ainur /srv/ftp/shared

# Memberi batasan akses ke tiga jenis user pada direktori /srv/ftp/shared
# Owner: read write execute. Group: 0. Others: 0
chmod 700 /srv/ftp/shared

#Edit vsftpd.conf sesuai kriteria dibawah:
nano /etc/vsftpd.conf

listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES

# Buat file untuk testing di local melkor
echo "akulelahjarkom" > testlocal.txt

# Jalankan service vsftpd dan ftp ke localhost (10.80.1.1). whenever make changes -> do service vsftpd restart
service vsftpd start

# di Melkor
ftp 10.80.1.1
# login sebagai ainur

# Tes put and get eru (read write)
put testlocal.txt

# Tes user melkor
bye
service vsftpd start

# Melkor
ftp 10.80.1.1
# login sebagai Melkor
# seharusnya tidak bisa akses ke direktori /srv/ftp/shared karena melkor tidak memiliki hak akses ke direktori tersebut
