## Anggota Kelompok
| No | Nama                       | NRP         |
|----|----------------------------|-------------|
| 1  | Aditya Reza Daffansyah     | 5027241034  |
| 2  | I Gede Bagus Saka Sinatrya |	5027241088  |

# Laporan Resmi Praktikum Jarkom 
## Walkthrough Pengerjaan Praktikum Jarkom Modul 1

### Soal 1
- Buat `NAT1`, `Eru (router)`, `1 switch` ke `client Melkor` dan `Manwe`, `1 switch` ke `Varda` dan `Ulmo`. 
- Hubungkan `Eru` ke `NAT1`, `Eru` ke `Switch1` dan `Switch2`. Hubungkan `Switch1` ke `Melkor` dan `Manwe`, dan hubungkan `Switch2` ke `Varda` dan `Ulmo`.

![topologi jarkom](assets/Topologi_Jarkom1.png)


### Soal 2
- Sambungkan `Eru (Router)` ke `NAT1` dengan network configure dibawah.
```
auto eth0
iface eth0 inet dhcp
```
![config eru](/assets/ConfigEru_Jarkom1.png)

- Gunakan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16` untuk menghubungkan router ke internet.

### Soal 3
- Hubungkan client satu sama lain (config satu persatu).
```
Eru:
auto eth1
iface eth1 inet static
    address 10.80.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.80.2.1
    netmask 255.255.255.0
```

```
Melkor:
auto eth0
iface eth0 inet static
    address 10.80.1.2
    netmask 255.255.255.0
    gateway [Prefix IP].1.1
```

```
Manwe:
auto eth0
iface eth0 inet static
    address 10.80.1.3
    netmask 255.255.255.0
    gateway 10.80.1.1
```
```
Varda:
auto eth0
iface eth0 inet static
    address 10.80.2.2
    netmask 255.255.255.0
    gateway 10.80.2.1
```
```
Ulmo:
auto eth0
iface eth0 inet static
    address 10.80.2.3
    netmask 255.255.255.0
    gateway 10.80.2.1
```

- Cek koneksi dari Melkor ke Eru:

![cek koneksi](/assets/client_connected_jarkom1.png)


### Soal 4
- Untuk menghubungkan client dengan internet, gunakan nameserver ke semua client.

`echo nameserver 192.168.122.1 > /etc/resolv.conf` 

- Perintah tersebut mengatur server DNS sistem ke alamat IP `192.168.122.1` dengan menimpa isi file konfigurasi `/etc/resolv.conf`.

- Cek konektivitas salah satu client dengan internet:

![melkor ping google](/assets/melkorpinggoogle_jarkom1.png)

### Soal 5
- Masukkan code dibawah ke `/root/.bashrc` untuk melakukan otomisasi konfigurasi

```
ERU:
apt update && apt install -y iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

```
CLIENT:
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Contoh isi dalam `/root/.bashrc` di terminal `Eru`:
![bashrc eru](/assets/bashrc_eru_jarkom1.png)

### Soal 6
- Download dan unzip file zip di console `Manwe`:
 ```
 wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5" -O traffic.zip
 unzip traffic.zip
 ```

- Masuk ke `GNS3 App`, capture traffic `Manwe` dengan `Switch1`.
![capture no 6](/assets/capture_no6_jarkom1.png)

- Jalankan `.traffic.sh` di `Manwe`, tunggu sampai proses selesai. jangan lupa tambahkan izin eksekusi dengan `chmod`

- Stop `wireshark`, save capture, stop capture di GNS3, 
![run traffic](/assets/run_traffic_jarkom1.png)

Hasil wireshark:
![wiresahrk 6](/assets/6_wireshark_jarkom1.png)

### Soal 7
- Download package server `ftp` dan `vsftpd`
```
Eru
apt install ftp -y
apt-get install vsftpd -y
```

- Buat folder `ftp` dan buat user `ainur` dan `melkor` di console `Eru`:
```
mkdir -p /srv/ftp/shared
adduser ainur   
adduser melkor
```

- Set folder yang akan di akses oleh `ainur` dan `melkor`
```
usermod -d /srv/ftp/shared ainur 
usermod -d /srv/ftp/shared melkor
```

- Beri akses owner ke `ainur` pada direktori `/srv/ftp/shared` dengan:
`chown ainur:ainur /srv/ftp/shared`

- Beri batasan akses ke tiga jenis user pada direktori `/srv/ftp/shared.` Owner: read write execute. Group: 0. Others: 0:
`chmod 700 /srv/ftp/shared`

- Edit `vsftpd.conf` sesuai kriteria dibawah:
```
nano /etc/vsftpd.conf

listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
```

- Buat file untuk testing di local `Melkor`

`echo "akulelahjarkom" > testlocal.txt`

- Jalankan `service vsftpd start` di console `Eru` 
- Download `apt install inetutils-ftp -y` di console Melkor
- Jalankan `ftp 10.80.1.1` (IP Eru). Login sebagai `ainur` pada console `Melkor`

- Tes `put` pada user `ainur`.
```
put testlocal.txt
```
- Hasil tes pada user Ainur:
![ainur can](/assets/ainur_can_jarkom1.png)

- Lakukan test yang sama pada user `Melkor`. Seharusnya `Melkor` tidak dapat mengakses ke `/srv/ftp/shared`, karena tidak memiliki akses ke direktori tersebut

- Hasil tes pada user Melkor:
![melkor cant](/assets/melkor_cant_jarkom1.png)

### Soal 8
```
Ulmo:
apt install ftp
apt intsall inetutils-ftp -y
```

- Mulai capture wireshark dari `GNS3 app` antara `Ulmo` dan `Switch2`

- Download dan unzip zip yang ada (berisi cuaca.txt dan mendung.jpg)
```
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=11ra_yTV_adsPIXeIPMSt0vrxCBZu0r33" -O ramalan_cuaca
unzip ramalan_cuaca.zip
```

- Jalankan `vsftpd` di console `Eru`
```
Eru: 
service vsftpd start
```
- Jalankan ftp, login sebagai ainur, `put` cuaca dan mendung
```
Ulmo:
ftp 10.80.2.1
login as ainur
binary
put cuaca.txt
put mendung.jpg
```
![succes put](/assets/cuaca_mendung_sent_jarkom1.png)

- Cek dengan `ls` apakah cuaca dan mendung ada
```
Eru: 
ls -l /srv/ftp/shared
```

![succes sent](/assets/cuaca_mendung_success.png)

- Terapkan filter `ftp || ftp-data` pada `Wireshark` untuk melakukan analisis

![ws no 8](/assets/wiresharkno8_jarkom1.png)


### Soal 9
```
Manwe:
apt install ftp
apt intsall inetutils-ftp -y
```
- Download dan unzip kitab dari gdrive:
```
Eru:
wget "https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY" -O /srv/ftp/shared/kitab_penciptaan.zip
```

- Edit `vsftpd.conf` agar membatasi user untuk read only:
```
nano /etc/vsftpd.conf

listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=NO
chroot_local_user=YES
allow_writeable_chroot=YES
```

- Buka `GNS3 app`, capture `Wireshark` di `Manwe` -> `Switch1`

```
Eru:
service vsftpd start
```
- Lakukan pengecekan untuk download dan delete file sebagai `ainur` 
```
Manwe:
ftp 10.80.1.1
login as ainur
get kitab_penciptaan.zip
delete kitab_penciptaan.zip
```
![getdel kitab](/assets/getdel_kitab_jarkom1.png)

- Stop wireshark capture, cek dengan filter `ftp || ftp-data`

![ws no 9](/assets/wiresharkno9_jarkom1.png)


### Soal 10
- Lakukan ping sebanyak sebanyak 100 kali pada `Eru`
```
Melkor:
ping -c 100 10.80.1.1
```
- Hasil:
![pingbrut](/assets/pingbrutal_jarkom1.png)

### Soal 11
- Download telnet, tambahkan 1 user baru, dan jalankan 
```
Melkor:
apt install openbsd-inetd telnetd -y
adduser jarkomasix
```
- Lakukan setup pada telnetd dan inetd
```
Melkor:
nano /etc/inetd.conf
// Hilangkan comment pada baris yang mengandung telnet

service openbsd-inetd start
```
- Buka `GNS3`, start capture wire `Eru` dan `Melkor (Switch1)`

```
Eru: 
apt install telnetd -y
telnet 10.80.1.2
login as jarkomasix
```

- Stop `Wireshark`, gunakan filter `telnet`, klik kanan pada salah satu target. Klik `follow` > `tcp stream`.

![securent](/assets/telnet_securent_jarkom1.png)

- `Telnet` berhasil dipakai `Eru` untuk login ke `Melkor`, tapi username dan password terkirim tanpa `enkripsi` (`plaintext`) sehingga bisa langsung terbaca di `Wireshark`. Itu membuktikan protokol Telnet tidak aman untuk autentikasi maupun komunikasi.


### Soal 12
- Download `netcat` untuk melakukan scanning port
```
Eru:
apt install netcat-openbsd -y
apt install apache2 -y
```
- Jalankan vsftpd di console `Melkor`
```
Melkor:
service vsftpd start
service apache2 start
```
- Port yang perlu di cek adalah port 32, 80, dan 666
``` 
nc -vz 10.80.1.2 21
nc -vz 10.80.1.2 80
nc -vz 10.80.1.2 666
```

- Hasil:
![nc_modul](/assets/nc_jarkom1.png)

- Port 21 (FTP) dan port 80 (HTTP) pada Melkor terbuka karena servicenya aktif, sedangkan port 666 tertutup karena tidak ada service yang berjalan di sana.

### Soal 13
- Download `media server ssh` dan nyalakan `ssh` nya
```
Eru:
apt install openssh-server -y
service start ssh
```

- Pergi ke `GNS3 app`, capture node `Varda` dan `Switch2`


```
Varda:
ssh ainur@10.80.1.1
```

- Hentikan capture `Wireshark`, pakai filter `ssh`, klik kanan pada salah satu paket, follow, tcp stream

- Hasil: Username dan password tidak dapat dilihat pada sesi `ssh` karena komunikasi sudah terenkripsi, sehingga berbeda dengan `Telnet` yang masih plaintext. Paket yang ditangkap di `Wireshark` menunjukkan data acak sebagai bukti enkripsi.

![wireshark no 13](/assets/wiresharkno13_jarkom1.png)



### Soal 14. Setelah gagal mengakses FTP, Melkor melancarkan serangan brute force terhadap  Manwe. Analisis file capture yang disediakan dan identifikasi upaya brute force Melkor. (link file) nc 10.15.43.32 3401

<img width="1852" height="883" alt="Image" src="https://github.com/user-attachments/assets/3b594dbe-9aba-4e1c-8e8a-ba8ef913b458" />

<img width="1926" height="673" alt="Image" src="https://github.com/user-attachments/assets/5363d7b9-383b-4c8d-a527-a133a1384f54" />

<img width="2879" height="1480" alt="Image" src="https://github.com/user-attachments/assets/71d35be6-116f-439a-9ed2-7b8124240bc8" />

<img width="1927" height="649" alt="Image" src="https://github.com/user-attachments/assets/4d14ce49-9476-4be9-bf4d-ee429eef1303" />

### Soal 15. Melkor menyusup ke ruang server dan memasang keyboard USB berbahaya pada node Manwe. Buka file capture dan identifikasi pesan atau ketikan (keystrokes) yang berhasil dicuri oleh Melkor untuk menemukan password rahasia. (link file) nc 10.15.43.32 3402

<img width="1853" height="723" alt="Image" src="https://github.com/user-attachments/assets/7988787b-f9c3-4963-b674-ec1ab053256d" />

<img width="2879" height="1443" alt="Image" src="https://github.com/user-attachments/assets/110ba7fa-9ca8-49f0-a2ac-10ecb51bed56" />

<img width="1336" height="182" alt="Image" src="https://github.com/user-attachments/assets/3f86ec50-710b-4931-af9a-91edec715e1a" />

### Soal 16. Melkor semakin murka ia meletakkan file berbahaya di server milik Manwe. Dari file capture yang ada, identifikasi file apa yang diletakkan oleh Melkor. (link file) nc 10.15.43.32 3403

<img width="2879" height="1334" alt="Image" src="https://github.com/user-attachments/assets/f8e2568e-b700-4f7f-9504-156c8e065da9" />

<img width="1899" height="546" alt="Image" src="https://github.com/user-attachments/assets/f32f9a8c-8ffd-451e-8438-518a4f6fe6b7" />

<img width="2879" height="1561" alt="Image" src="https://github.com/user-attachments/assets/9c666e82-bb99-459e-a625-79d1b99adaf6" />

<img width="2871" height="1673" alt="Image" src="https://github.com/user-attachments/assets/17f19a1f-3f39-4dec-b316-e2437ea8feb6" />

<img width="2874" height="1138" alt="Image" src="https://github.com/user-attachments/assets/1edfdcff-5d06-4ec7-85e2-bd22f66f709b" />

<img width="2878" height="1169" alt="Image" src="https://github.com/user-attachments/assets/46cdef9b-e6a7-4ef0-8ef8-e71700e81f49" />

<img width="2863" height="1145" alt="Image" src="https://github.com/user-attachments/assets/eafd5946-e5d0-4695-84c1-bbe46dfff025" />

<img width="2870" height="1506" alt="Image" src="https://github.com/user-attachments/assets/643a598c-638f-4e01-a154-b7d1f9a87eed" />

<img width="2879" height="1150" alt="Image" src="https://github.com/user-attachments/assets/a40760fb-cf12-4e15-bdee-54f8e06e1f88" />

<img width="2879" height="1495" alt="Image" src="https://github.com/user-attachments/assets/663f6de3-9984-4877-934f-ad972daca956" />

### Soal 17. Manwe membuat halaman web di node-nya yang menampilkan gambar cincin agung. Melkor yang melihat web tersebut merasa iri sehingga ia meletakkan file berbahaya agar web tersebut dapat dianggap menyebarkan malware oleh Eru. Analisis file capture untuk menggagalkan rencana Melkor dan menyelamatkan web Manwe. (link file) nc 10.15.43.32 3404

<img width="1884" height="617" alt="Image" src="https://github.com/user-attachments/assets/01d051f5-71e0-4f61-9eca-dffe65a95114" />

<img width="2879" height="1435" alt="Image" src="https://github.com/user-attachments/assets/ee952b0d-c4cb-4f3f-98e9-b47b4e41eb5b" />

<img width="2296" height="722" alt="Image" src="https://github.com/user-attachments/assets/52fd2cbc-e77a-420e-8350-5ed3859b3f7f" />

<img width="2877" height="290" alt="Image" src="https://github.com/user-attachments/assets/3bd6b7c1-31ac-46d2-bf48-5a7d0ce4eb5d" />

<img width="2840" height="737" alt="Image" src="https://github.com/user-attachments/assets/fd5ba70f-9ace-477d-8756-655215be1170" />

![Image](https://github.com/user-attachments/assets/10ab3949-6383-4542-a66c-68b0f19a507f)

### Soal 18. Karena rencana Melkor yang terus gagal, ia akhirnya berhenti sejenak untuk berpikir. Pada saat berpikir ia akhirnya memutuskan untuk membuat rencana jahat lainnya dengan meletakkan file berbahaya lagi tetapi dengan metode yang berbeda. Gagalkan lagi rencana Melkor dengan mengidentifikasi file capture yang disediakan agar dunia tetap aman. (link file) nc 10.15.43.32 3405

<img width="2059" height="1043" alt="Image" src="https://github.com/user-attachments/assets/ffb2a43a-c07e-4619-bac9-1628f8eefce2" />

<img width="2879" height="335" alt="Image" src="https://github.com/user-attachments/assets/fd1ddf91-d3ec-482f-8d4c-0360065adefe" />

![Image](https://github.com/user-attachments/assets/c6cc6b64-5f8e-492a-9efe-12d7b2923612)

### Soal 19. Manwe mengirimkan email berisi surat cinta kepada Varda melalui koneksi yang tidak terenkripsi. Melihat hal itu Melkor sipaling jahat langsung melancarkan 
aksinya yaitu meneror Varda dengan email yang disamarkan. Analisis file capture jaringan dan gagalkan lagi rencana busuk Melkor.  (link file) nc 10.15.43.32 3406

<img width="1892" height="662" alt="Image" src="https://github.com/user-attachments/assets/5871d3cd-55cd-4f44-a5a3-544d8746a0f3" />

<img width="2822" height="1491" alt="Image" src="https://github.com/user-attachments/assets/c9683ead-3243-4181-b5d7-626ffe226a33" />

<img width="1900" height="1474" alt="Image" src="https://github.com/user-attachments/assets/92d73514-29c4-4b84-97a1-9698382e458a" />

<img width="1868" height="1349" alt="Image" src="https://github.com/user-attachments/assets/4e908f24-67d9-437f-8109-24be8884202e" />

### Soal 20. Untuk yang terakhir kalinya, rencana besar Melkor yaitu menanamkan sebuah file berbahaya kemudian menyembunyikannya agar tidak terlihat oleh Eru. Tetapi Manwe yang sudah merasakan adanya niat jahat dari Melkor, ia menyisipkan bantuan untuk mengungkapkan rencana Melkor. Analisis file capture dan identifikasi kegunaan bantuan yang diberikan oleh Manwe untuk menggagalkan rencana jahat Melkor selamanya. (link file) nc 10.15.43.32 3407

<img width="1861" height="746" alt="Image" src="https://github.com/user-attachments/assets/6263e7d2-d3df-421d-a59d-491b656bcd37" />

<img width="2284" height="629" alt="Image" src="https://github.com/user-attachments/assets/1e74ee44-1d4a-475b-a824-8bd4b230c648" />

<img width="1600" height="484" alt="Image" src="https://github.com/user-attachments/assets/be93835f-f087-4a3c-88ad-c9521fee51f3" />

<img width="1569" height="1255" alt="Image" src="https://github.com/user-attachments/assets/4ab47cca-364b-4e16-b070-1a20ac398041" />

<img width="1634" height="674" alt="Image" src="https://github.com/user-attachments/assets/cfc17483-12a0-4dcd-ac8b-ebc042e3fcfe" />

![Image](https://github.com/user-attachments/assets/45372944-f16d-42b7-9c58-1b55377dbf61)








