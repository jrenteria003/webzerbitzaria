#!/bin/bash
sudo touch 8.txt
sudo chmod 777 8.txt
./webprocess.sh english.doc.txt > 8.txt
sed -i '1,2d' 8.txt
