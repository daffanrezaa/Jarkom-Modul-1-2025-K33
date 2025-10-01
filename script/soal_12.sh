# di Melkor:
apt install netcat-openbsd -y

service vsftpd start

# 3 port yang perlu di cek 21,80,dan 666
nc -vz 10.80.1.2 21

apt install apache2 -y
service apache2 start

nc -vz 10.80.1.2 80
nc -vz 10.80.1.2 666

# jelaskan service port tersebut apaa dan terbuka atau tertutup