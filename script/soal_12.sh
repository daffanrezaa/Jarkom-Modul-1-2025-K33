# di Eru:
apt install netcat-openbsd -y
apt install apache2 -y

#di Melkor 
service vsftpd start
service apache2 start


# 3 port yang perlu di cek 21,80,dan 666 di Eru
nc -vz 10.80.1.2 21
nc -vz 10.80.1.2 80
nc -vz 10.80.1.2 666

# jelaskan service port tersebut apaa dan terbuka atau tertutup