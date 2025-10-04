#download file zip dari MANWE : 
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5" -O traffic.zip
unzip traffic.zip

# masuk ke dns3 app, capture manwe -> switch1 (make sure wireshark nya jalan). 

chmod +x traffic.sh
./traffic.sh 
#run traffic.sh di manwe, tunggu sampai proses selesai, stop wireshark, save capture, stop capture di GNS3