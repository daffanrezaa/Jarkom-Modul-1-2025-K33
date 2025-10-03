```
TEMPLATE /root/.bashrc
ERU:
apt update && apt install iptables -y
apt install unzip -y
apt-get install vsftpd -y
apt install netcat-traditional
apt install ftp -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

```
CLIENT:
apt update && apt install iptables -y
apt install unzip -y
apt-get install vsftpd -y
apt install netcat-traditional -y
apt install ftp -y
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

```
CONNECT TELNET:
telnet 10.15.43.32 {port router / client}
```

# Laporan Resmi Praktikum Jarkom 
## Walkthrough Pengerjaan Praktikum Jarkom Modul 1

## Anggota Kelompok
| No | Nama                       | NRP         |
|----|----------------------------|-------------|
| 1  | Aditya Reza Daffansyah     | 5027241034  |
| 2  | I Gede Bagus Saka Sinatrya |	5027241088  |


### Soal 1
#### Untuk mempersiapkan pembuatan entitas selain mereka, Eru yang berperan sebagai Router membuat dua Switch/Gateway. Dimana Switch 1 akan menuju ke dua Ainur yaitu Melkor dan Manwe. Sedangkan Switch 2 akan menuju ke dua Ainur lainnya yaitu Varda dan Ulmo. Keempat Ainur tersebut diberi perintah oleh Eru untuk menjadi Client.
##### Jawaban:
- Buat `NAT1`, `Eru (router)`, `1 switch` ke `client Melkor` dan `Manwe`, `1 switch` ke `Varda` dan `Ulmo`. 
- Hubungkan 'Eru' ke 'NAT1', 'Eru' ke 'Switch 1' dan 2. Hubungkan 'Switch 1' ke 'Melkor' dan 'Manwe', dan hubungkan 'Switch 2' ke 'Varda' dan 'Ulmo'

![topologi jarkom](assets/Topologi_Jarkom1.png)


### Soal 2
- Sambungkan Eru (Router) ke NAT1 dengan network configure dibawah.
```
auto eth0
iface eth0 inet dhcp
```
![config eru](/assets/ConfigEru_Jarkom1.png)

- Gunakan `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.80.0.0/16` untuk menghubungkan router ke internet.

### Soal 3
hubungkan client satu sama lain (congfig satu persatu)
Eru:
auto eth1
iface eth1 inet static
    address 10.80.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.80.2.1
    netmask 255.255.255.0

Melkor:
auto eth0
iface eth0 inet static
    address 10.80.1.2
    netmask 255.255.255.0
    gateway [Prefix IP].1.1

Manwe:
auto eth0
iface eth0 inet static
    address 10.80.1.3
    netmask 255.255.255.0
    gateway 10.80.1.1

Varda:
auto eth0
iface eth0 inet static
    address 10.80.2.2
    netmask 255.255.255.0
    gateway 10.80.2.1

Ulmo:
auto eth0
iface eth0 inet static
    address 10.80.2.3
    netmask 255.255.255.0
    gateway 10.80.2.1

### Soal 4
echo nameserver 192.168.122.1 > /etc/resolv.conf (KE SEMUA CLIENT)


### Soal 5
masukkan config ke /root/.bashrc
ERU:
apt update && apt install -y iptables
apt-get install vsftpd -y
apt install netcat-traditional
apt install ftp -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.216.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf

CLIENT:
apt-get install vsftpd -y
apt install netcat-traditional
apt install ftp -y
echo nameserver 192.168.122.1 > /etc/resolv.conf


### Soal 6
 download file zip dari MANWE : wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5" -O traffic.zip
unzip: unzip traffic.zip

masuk ke dns3 app, capture manwe -> switch1 (make sure wireshark nya jalan). 

run traffic.sh di manwe, tunggu sampai proses selesai, stop wireshark, save capture, stop capture di GNS3

### Soal 7
Jalan di Eru:
apt install ftp -y
apt-get install vsftpd -y

Buat folder ftp, buat user ainur dan melkor:
mkdir -p /srv/ftp/shared
adduser ainur   
adduser melkor

Set folder yang akan di akses oleh ainur dan melkor
usermod -d /srv/ftp/shared ainur 
usermod -d /srv/ftp/shared melkor

Memberi akses owner ke ainur pada direktori /srv/ftp/shared
chown ainur:ainur /srv/ftp/shared

Memberi batasan akses ke tiga jenis user pada direktori /srv/ftp/shared
Owner: read write execute. Group: 0. Others: 0
chmod 700 /srv/ftp/shared

Edit vsftpd.conf sesuai kriteria dibawah:
nano /etc/vsftpd.conf

listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES

Buat file untuk testing di local Eru
echo "akulelahjarkom" > testlocal.txt

Jalankan service vsftpd dan ftp ke localhost (10.80.1.1). whenever make changes -> do service vsftpd restart
service vsftpd start
ftp 10.80.1.1
login sebagai ainur

Buat file testing di ftp server
echo "akulelahjarkom" > testftp.txt

Tes put and get eru (read write)
put testftp.txt
get testlocal.txt

Tes user melkor
bye
service vsftpd start
ftp 10.80.1.1
login sebagai ainur

seharusnya tidak bisa akses ke direktori /srv/ftp/shared karena melkor tidak memiliki hak akses ke direktori tersebut

bye
service vsftpd stop

### Soal 8
di ulmo:
apt install ftp -y
apt install vsftpd -y

capture wireshark di ulmo -> switch 2

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=11ra_yTV_adsPIXeIPMSt0vrxCBZu0r33" -O ramalan_cuaca
unzip ramalan_cuaca
ramalan cuaca contains: mendung.jpg dan cuaca.txt

di eru: 
service vsftpd start
+
di ulmo:
ftp 10.80.2.1
login as ainur
binary
put cuaca.txt
put mendung.jpg

di eru: cek ls apakah cuaca dan mendung ada


### Soal 9
di Eru:
wget -P /srv/ftp/shared "https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY"
unzip 

 
Edit vsftpd.conf sesuai kriteria dibawah:
nano /etc/vsftpd.conf

listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=NO
chroot_local_user=YES
allow_writeable_chroot=YES

capture wireshark di manwe -> switch 
service vsftpd start

di Manwe:
ftp 10.80.1.1
login as ainur
get kitab_penciptaan.zip (atau setelah di ekstrak)
delete kitab_penciptaan.zip (HARUSYA GABISA)

stop wireshark capture, cek dengan filter ftp || ftp-data


### Soal 10
di Melkor:
ping -c 100 10.80.1.1 (IP ERU)
Identifikasi hasilnya

### Soal 11
di Melkor:
apt install openbsd-inetd telnetd -y
adduser jarkomasix:jarkomasix

di GNS3: start capture wire eru dan melkor (switch1)

di Eru: telnet <ip>

stop wireshark, pake filter telnet, klik kanan pada salah satu target, klik follow > tcp stream (akan menampilkan convo eru dan 
melkor tanpa enkripsim, akan ditermukan usn dan huruf tanpa enkripsi)


### Soal 12
di Melkor:
apt install netcat-openbsd -y

service vsftpd start

3 port yang perlu di cek 21,80,dan 666
nc -vz 10.80.1.2 21

apt install apache2 -y
service apache2 start

nc -vz 10.80.1.2 80
nc -vz 10.80.1.2 666

jelaskan service port tersebut apaa dan terbuka atau tertutup


### Soal 13
di Eru:
apt update && apt install openssh-server -y
systemctl start ssh

varda -> switch, start capturing wireshark

di Varda: 
ssh <usn>@<IP_server>
ssh ainur@IP_ERU

di Wireshark:
hentikan capture, pakai filter ssh, klik kanan pada salah satu paket, follow, tcp stream


### 14. Setelah gagal mengakses FTP, Melkor melancarkan serangan brute force terhadap  Manwe. Analisis file capture yang disediakan dan identifikasi upaya brute force Melkor. (link file) nc 10.15.43.32 3401

Berikut adalah flag yang didapat setelah semua soal terjawab.
<img width="1852" height="883" alt="Image" src="https://github.com/user-attachments/assets/3b594dbe-9aba-4e1c-8e8a-ba8ef913b458" />

Untuk menjawab pertanyaan nomor satu, kita bisa melihat jumlah total seluruh packet yang ada di layar kanan bawah pada tampilan wireshark kita.
<img width="1436" height="760" alt="Image" src="https://github.com/user-attachments/assets/346a0dc1-a189-4f17-8d5b-88945b755ceb" />

Kemudian lanjut ke pertanyaan nomor 2, saya melakukan `follow tcp stream` pada salah satu packet dengan protokol TCP karena biasanya protokol TCP ini bertanggung jawab dalam mengelola informasi informasi tersebut. Pada gambar terbukti bahwa terdapat percobaan login yang gagal pada salah satu packet dengan protokol TCP tersebut.
<img width="1926" height="673" alt="Image" src="https://github.com/user-attachments/assets/5363d7b9-383b-4c8d-a527-a133a1384f54" />

Nah karena protokol yang digunakan adalah TCP maka kita dapat menggunakan display filter `tcp contains "successful"`, artinya filter ini akan mencari data yang berisi kata successful. Karena pada gambar di atas terdapat pesan yang menandakan gagal masuk berarti akan ada pesan yang menandakan bahwa kita berhasil masuk, maka dari itu saya mencoba menggunakan kata successful sebagai kunci untuk mencari username dan password tersebut. Setelah menjalankan terbukti bahwa hanya ada satu packet yang terdapat pesan tersebut.
<img width="2879" height="1480" alt="Image" src="https://github.com/user-attachments/assets/71d35be6-116f-439a-9ed2-7b8124240bc8" />

Kemudian kita dapat melakukan `follow tcp stream` pada packet tersebut dan mendapatkan hasil seperti gambar di bawah ini. Di sini juga langsung menjawab pertanyaan nomor 3, yaitu tools yang digunakan untuk brute force.
<img width="1927" height="649" alt="Image" src="https://github.com/user-attachments/assets/4d14ce49-9476-4be9-bf4d-ee429eef1303" />

### 15. Melkor menyusup ke ruang server dan memasang keyboard USB berbahaya pada node Manwe. Buka file capture dan identifikasi pesan atau ketikan (keystrokes) yang berhasil dicuri oleh Melkor untuk menemukan password rahasia. (link file) nc 10.15.43.32 3402

Berikut adalah flag untuk soal 15
<img width="1853" height="723" alt="Image" src="https://github.com/user-attachments/assets/7988787b-f9c3-4963-b674-ec1ab053256d" />

Untuk jawaban pertanyaan pertama adalah Keyboard, karena keyboard sendiri merupakan salah satu Human Interface Device (HID) dan HID sendiri adalah protokol USB standar untuk input device. Jadi setiap penekanan tombol keyboard akan dikirimkan sebagai paket HID di USB. Selain itu saya juga menelusuri beberapa packet awal dan menemukan Interface protokol yang digunakan pada packet nomor enam adalah Keyboard.
<img width="2879" height="1443" alt="Image" src="https://github.com/user-attachments/assets/110ba7fa-9ca8-49f0-a2ac-10ecb51bed56" />

Kemudian untuk menjawab pertanyaan kedua, terlebih dahulu kita harus memfilter mana packet yang berisi data. Jadi kita bisa menggunakan `usbhid.data` untuk mengetahui packet mana yang kemungkinan berisi data yang diketik oleh Melkor.
<img width="2878" height="1554" alt="Image" src="https://github.com/user-attachments/assets/dae2d9c9-311b-4c9e-b2ba-579eb0112d34" />

Setelah mengetahui semua packet yang kemungkinan berisi data yang diketik kita dapat menggunakan kode di bawah ini untuk mengexport ke linux agar nantinya bisa menerjemahkan ke format base64.
```bash
tshark -r hiddenmsg.pcapng -Y "usbhid.data" -T fields -e usbhid.data > hid_data.txt
```
- `tshark -r hiddenmsg.pcapng`: Memerintahkan tshark untuk membaca (-r) file hiddenmsg.pcapng.

- `Y "usbhid.data"`: Menerapkan display filter untuk hanya memproses paket yang berisi data HID.

- `T fields -e usbhid.data`: Mengatur format output (-T fields) dan memerintahkan untuk mengekstrak (-e) hanya isi dari field usbhid.data.

- `> hid_data.txt`: Menyimpan semua hasil ekstraksi ke dalam sebuah file baru bernama hid_data.txt.

Nah selanjutnya setelah seluruh data berhasil di export, kemudian kita haru merubah format seluruh data bilangan tersebut ke format base64 agar kita mengetahui pesan apa yang ditulis nantinya. Di sini saya menggunakan script untuk melakukan formating ini.
```bash
NAMA_FILE_INPUT = 'hid_dataa.txt'

# Kode Heksadesimal USB HID ke Karakter Keyboard Layout
scancodes = {
    0x04: "a", 0x05: "b", 0x06: "c", 0x07: "d", 0x08: "e", 0x09: "f",
    0x0a: "g", 0x0b: "h", 0x0c: "i", 0x0d: "j", 0x0e: "k", 0x0f: "l",
    0x10: "m", 0x11: "n", 0x12: "o", 0x13: "p", 0x14: "q", 0x15: "r",
    0x16: "s", 0x17: "t", 0x18: "u", 0x19: "v", 0x1a: "w", 0x1b: "x",
    0x1c: "y", 0x1d: "z", 0x1e: "1", 0x1f: "2", 0x20: "3", 0x21: "4",
    0x22: "5", 0x23: "6", 0x24: "7", 0x25: "8", 0x26: "9", 0x27: "0",
    0x28: "<ENTER>", 0x2a: "<BS>", 0x2c: " ", 0x2d: "-", 0x2e: "=",
    0x2f: "[", 0x30: "]", 0x31: "\\", 0x33: ";", 0x34: "'", 0x36: ",",
    0x37: ".", 0x38: "/"
}

# tombol yang ditekan bersama SHIFT
shifted_scancodes = {
    0x1e: "!", 0x1f: "@", 0x20: "#", 0x21: "$", 0x22: "%", 0x23: "^",
    0x24: "&", 0x25: "*", 0x26: "(", 0x27: ")", 0x2d: "_", 0x2e: "+",
    0x2f: "{", 0x30: "}", 0x31: "|", 0x33: ":", 0x34: "\"", 0x36: "<",
    0x37: ">", 0x38: "?"
}

# membuka dan membaca file secara aman dan menyimpannya sebagai daftar(list)
try:

    with open(NAMA_FILE_INPUT, 'r') as f:
        lines = f.readlines()

except FileNotFoundError:
    print(f"Error: File '{NAMA_FILE_INPUT}' tidak ditemukan. Pastikan nama filenya benar.")
    exit()

# Loop penerjemah setiap baris
result = ""
last_keycode = 0

for line in lines:
    data = line.strip().replace(':', '')
    if len(data) != 16:
        continue

    modifier = int(data[0:2], 16)
    keycode = int(data[4:6], 16)

    if keycode != 0 and keycode != last_keycode:
        is_shift_pressed = (modifier == 0x02 or modifier == 0x20)

        if is_shift_pressed:
            if keycode in shifted_scancodes:
                result += shifted_scancodes[keycode]
            elif keycode in scancodes:
                result += scancodes[keycode].upper()
        else:
            if keycode in scancodes:
                result += scancodes[keycode]

    last_keycode = keycode

print("String Base64 yang berhasil diekstrak:")
print(result)
```
- `modifier`: Mengambil dua karakter pertama (02), menganggapnya sebagai angka heksadesimal (16), dan menyimpannya. Ini adalah kode untuk tombol modifier (Shift, Ctrl, Alt).

- `keycode`: Mengambil karakter ke-5 dan ke-6 (18), menganggapnya sebagai angka heksadesimal, dan menyimpannya. Ini adalah kode untuk tombol utama yang ditekan.

Kemudian kita dapat menjalankan langsung script di atas dan mendapatkan hasil base64 seperti di bawah ini. Dan untuk pertanyaan nomor tiga kita dapat menerjemahkan dari base64 ke pesan biasa menggunakan tools online di google.
<img width="1336" height="182" alt="Image" src="https://github.com/user-attachments/assets/3f86ec50-710b-4931-af9a-91edec715e1a" />


### 16. Melkor semakin murka ia meletakkan file berbahaya di server milik Manwe. Dari file capture yang ada, identifikasi file apa yang diletakkan oleh Melkor. (link file) nc 10.15.43.32 3403

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

### 17. Manwe membuat halaman web di node-nya yang menampilkan gambar cincin agung. Melkor yang melihat web tersebut merasa iri sehingga ia meletakkan file berbahaya agar web tersebut dapat dianggap menyebarkan malware oleh Eru. Analisis file capture untuk menggagalkan rencana Melkor dan menyelamatkan web Manwe. (link file) nc 10.15.43.32 3404

Berikut adalah hasil flag dari soal nomor 17
<img width="1884" height="617" alt="Image" src="https://github.com/user-attachments/assets/01d051f5-71e0-4f61-9eca-dffe65a95114" />

Untuk menjawab pertanyaan pertama tentang file yang mencurigakan saya di sini langsung menggunakan filter http untuk melihat data data dari seluruh protokol http yang ada karena pada soal diberitahu bahwa file tersebut diletakkan di web yang digunakan Manwe jadi kemungkinan besar file tersebut ada di protokol http seperti gambar di bawah ini.
<img width="2877" height="290" alt="Image" src="https://github.com/user-attachments/assets/3bd6b7c1-31ac-46d2-bf48-5a7d0ce4eb5d" />

Untuk memperjelas hasil di atas kita dapat menggunakan fungsi wireshark yaitu `export object` jadi nantinya ini akan memfilter objek objek yang bisa di export seperti gambar di bawah ini. Nah setelah kita mengetahui object object tersebut kita dapat mencoba memasukkan setiap file di atas ke dalam soal. Jadi gambar di bawah ini langsung menunjukkan jawaban dari pertanyaan satu dan dua.
<img width="2840" height="737" alt="Image" src="https://github.com/user-attachments/assets/fd5ba70f-9ace-477d-8756-655215be1170" />

Nah nuntuk pertanyaan ketiga terkait dengan hash dari file kedua, karena kita sudah diberitahu formatnya kita dapat langsung mengexport file kedua tersebut ke dalam linux yang kita gunakan. Kemudian dengan fitur yang sudah tersedia di linux kita dapat langsung menggunakan `sha256sum` untuk melakukan hash ke format tersebut.
![Image](https://github.com/user-attachments/assets/10ab3949-6383-4542-a66c-68b0f19a507f)

### 18. Karena rencana Melkor yang terus gagal, ia akhirnya berhenti sejenak untuk berpikir. Pada saat berpikir ia akhirnya memutuskan untuk membuat rencana jahat lainnya dengan meletakkan file berbahaya lagi tetapi dengan metode yang berbeda. Gagalkan lagi rencana Melkor dengan mengidentifikasi file capture yang disediakan agar dunia tetap aman. (link file) nc 10.15.43.32 3405

Berikut adalah flag dari soal nomor 18
<img width="2059" height="1043" alt="Image" src="https://github.com/user-attachments/assets/ffb2a43a-c07e-4619-bac9-1628f8eefce2" />

Untun menjawab pertanyaan pertama di sini saya langsung melakukan `frame contains ".exe", karena seperti soal soal sebelumnya kebanyakan file yang sering digunakan untuk menyusupkan malware adalah file dengan format tersebut, karena file tersebut cenderung mudah untuk dieksekusi dan mudah untuk di distribusikan. Dan terbukti dari hasil filter tersebut langsung menghasilkan dua file yang terlihat mencurigakan, jadi saya langsung memasukkan dua file tersebut sebagai jawaban pertanyaan nomor satu dua dan tiga.
<img width="2879" height="1435" alt="Image" src="https://github.com/user-attachments/assets/ee952b0d-c4cb-4f3f-98e9-b47b4e41eb5b" />

Nah untuk dua pertanyaan terakhir  di sini kita dapat melakukan cara yang sama seperti soal yang sebelumnya, yaitu mengexport objek terlebih dahulu ke linux kemudian barulah melakukan hash dengan format sha256 pada linux.
![Image](https://github.com/user-attachments/assets/c6cc6b64-5f8e-492a-9efe-12d7b2923612)

### 19. Manwe mengirimkan email berisi surat cinta kepada Varda melalui koneksi yang tidak terenkripsi. Melihat hal itu Melkor sipaling jahat langsung melancarkan 
aksinya yaitu meneror Varda dengan email yang disamarkan. Analisis file capture jaringan dan gagalkan lagi rencana busuk Melkor.  (link file) nc 10.15.43.32 3406

Berikut adalah hasil flag dari soal nomor 19
<img width="1892" height="662" alt="Image" src="https://github.com/user-attachments/assets/5871d3cd-55cd-4f44-a5a3-544d8746a0f3" />

Untuk menjawab pertanyaan pertama, karena berdasarkan soal yang dibahas adalah email dan sama seperti soal nomor 14 sebelumnnya, saya disini langsung mencoba menggunakan `tcp contains "email"` untuk mencari data data dari pertanyaan nomor satu. Kemudian di sini langsung terlihat packet packet TCP yang berisi data data dengan kata kunci email. 
<img width="2822" height="1491" alt="Image" src="https://github.com/user-attachments/assets/c9683ead-3243-4181-b5d7-626ffe226a33" />

Setelah itu saya langsung menggunakan `follow tcp stream` untuk melihat isi dari packet tersebut dan benar saja di sana langsung terdapat seluruh informasi yang terkait dengan sem,ua pertanyaan di atas. dibawah ini adalah nama pengirim dari penyerang.
<img width="1900" height="1474" alt="Image" src="https://github.com/user-attachments/assets/92d73514-29c4-4b84-97a1-9698382e458a" />

Dan masih dari packet yang sama juga terlihat data data untuk menjawab pertanyaan nomor dua dan tiga.
<img width="1868" height="1349" alt="Image" src="https://github.com/user-attachments/assets/4e908f24-67d9-437f-8109-24be8884202e" />

### 20. Untuk yang terakhir kalinya, rencana besar Melkor yaitu menanamkan sebuah file berbahaya kemudian menyembunyikannya agar tidak terlihat oleh Eru. Tetapi Manwe yang sudah merasakan adanya niat jahat dari Melkor, ia menyisipkan bantuan untuk mengungkapkan rencana Melkor. Analisis file capture dan identifikasi kegunaan bantuan yang diberikan oleh Manwe untuk menggagalkan rencana jahat Melkor selamanya. (link file) nc 10.15.43.32 3407

<img width="1861" height="746" alt="Image" src="https://github.com/user-attachments/assets/6263e7d2-d3df-421d-a59d-491b656bcd37" />

<img width="2284" height="629" alt="Image" src="https://github.com/user-attachments/assets/1e74ee44-1d4a-475b-a824-8bd4b230c648" />

<img width="1600" height="484" alt="Image" src="https://github.com/user-attachments/assets/be93835f-f087-4a3c-88ad-c9521fee51f3" />

<img width="1569" height="1255" alt="Image" src="https://github.com/user-attachments/assets/4ab47cca-364b-4e16-b070-1a20ac398041" />

<img width="1634" height="674" alt="Image" src="https://github.com/user-attachments/assets/cfc17483-12a0-4dcd-ac8b-ebc042e3fcfe" />

![Image](https://github.com/user-attachments/assets/45372944-f16d-42b7-9c58-1b55377dbf61)








