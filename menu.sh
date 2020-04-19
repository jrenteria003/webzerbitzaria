#!/bin/bash

############################################################
#   0) DESINSTALATU 
############################################################
function desinstalatuDena()
{
echo "#################### desinstalatuDena funtzioa"
komandoa1=`sudo dpkg -l | grep -w "apache2"`
komandoa2=`sudo dpkg -l | grep -w "php"`
mezua=`echo $komandoa1$komandoa2`

if [ -z  "$mezua" ];
then
	dialog --msgbox "Apache edo php ez daude instalatuta \n" 5 50
else
	sudo systemctl stop apache2.service
	sudo apt-get remove apache2 -y
	sudo apt-get remove php -y
	sudo apt-get remove libapache2-mod-php -y
	sudo dpkg --purge apache2 
	sudo dpkg --purge php-common 
	sudo apt-get remove php-common -y
	sudo apt autoremove -y
	sudo apt-get remove --purge $(dpkg -l | grep "^rc" | awk '{print $2}') -y
	sudo rm -r /var/www
	sudo rm -r /var/lib/php
	sudo rm -r /etc/apache2
fi

}
###########################################################
#   1) APACHE INSTALATU                     
###########################################################
function apacheInstalatu()
{
echo "#################### apacheInstalatu funtzioa"
komandoa=`sudo dpkg -l | grep -w "apache2"`
mezua=`echo $komandoa`

if [ -n  "$mezua" ];
then    
	dialog --msgbox "apache jada instalatuta dago \n" 5 50
else    
	sudo apt-get install apache2 -y
fi
}

###########################################################
#   2) WEB APACHE ZERBITZUA PROBATU/TESTEATU         
###########################################################
function apacheTestatu()
{
echo "#################### apacheTestatu funtzioa"
komandoa=`sudo dpkg -l | grep -w "net-tools"`
mezua=`echo $komandoa`
if [ -z "$mezua" ];
then	
	sudo apt-get install net-tools -y
fi
komandoa3=`sudo systemctl status apache2.service | grep "Active"`
mezua3=`echo $komandoa3`
if [ -n  "$mezua3" ];
then
	dialog --msgbox "Apache web zerbitzaria martxan dago \n" 5 50
else
	dialog --msgbox "Apache berbiarazten... \n" 5 30
	sudo systemctl restart apache2.service
fi

komandoa4=`sudo netstat -anp | grep ":80.*apache2"`
mezua4=`echo $komandoa4`
if [ -n  "$mezua4" ];
then
	dialog --msgbox "Apache web zerbitzaria 80 portutik entzuten ari da \n" 5 50
else
	dialog --msgbox "Apache web zerbitzaria EZ DAGO 80 portutik entzuten \n" 5 50
fi

firefox http://127.0.0.1:80

}

###########################################################
#   3) APACHEn HOST BIRTUAL BAT SORTU
###########################################################
function virtualHostSortu()
{
echo "#################### virtualHostaSortu funtzioa"
cd /var/www/html
sudo mkdir -p erraztest
cd /etc/apache2/sites-available
sudo cp /etc/apache2/sites-available/000-default.conf erraztest.conf
sudo sed -i 's|/var/www/html|/var/www/html/erraztest|' erraztest.conf
sudo sed -i 's|</VirtualHost>|<Directory /var/www/html/erraztest>\nOptions Indexes FollowSymLinks MultiViews\nAllowOverride All\nOrder allow,deny\nallow from all\n</Directory>\n\n</VirtualHost>|' erraztest.conf
cd /etc/apache2
komandoa4=`sudo netstat -anp | grep ":8080.*apache2"`
mezua4=`echo $komandoa4`
if [ -n  "$mezua4" ];
then
	dialog --msgbox "Apache web zerbitzaria 8080 portutik entzuten ari da \n" 5 50
else
	sudo sed -i 's|Listen 80|Listen 80\nListen 8080|' ports.conf
	dialog --msgbox "Apache web zerbitzaria 8080 portutik entzuten ari da \n" 5 50
fi
cd /etc/apache2/sites-available
sudo a2ensite erraztest.conf &> /dev/null
sudo systemctl restart apache2.service
sudo a2ensite erraztest.conf
}

###########################################################
#   4) TESTATU BIRTUAL HOSTa
###########################################################
function virtualHostaTestatu(){
echo "#################### virtualHostaTestatu funtzioa"

komandoa3=`sudo systemctl status apache2.service | grep "Active"`
mezua3=`echo $komandoa3`
if [ -n  "$mezua3" ];
then
	dialog --msgbox "Apache web zerbitzaria martxan dago \n" 5 50
else
	dialog --msgbox "Apache berbiarazten... \n" 5 30
	sudo systemctl restart apache2.service
fi

komandoa3=`sudo netstat -anp | grep ":8080.*apache"`
mezua3=`echo $komandoa3`
if [ -n  "$mezua3" ];
then
	dialog --msgbox "Apache web zerbitzaria 8080 portutik entzuten ari da \n" 5 50
	cd /var/www/html
	sudo cp /var/www/html/index.html erraztest
	firefox http://127.0.0.1:8080
else
	dialog --msgbox "Apache web zerbitzaria EZ DAGO 8080 portutik entzuten \n" 5 50
fi

}

###########################################################
#   5) PHP INSTALATU                       
###########################################################
function phpInstalatu()
{
echo "#################### phpInstalatu funtzioa"

komandoa=`sudo dpkg -l | grep -w "php"`
mezua=`echo $komandoa`

if [ -n  "$mezua" ];
then    
	dialog --msgbox "php jada instalatuta dago \n" 5 40
else    
	sudo apt-get install php -y
	sudo apt-get install libapache2-mod-php -y
	dialog --msgbox "Apache berbiarazten... \n" 5 30
	sudo systemctl restart apache2.service
fi
}

###########################################################
#   6) PHP TESTEATU
###########################################################
function phpTestatu()
{
echo "#################### phpTestatu funtzioa"
cd /etc/apache2/sites-available
sudo sed -i 's|*:80>|*:8080>|' erraztest.conf
sudo systemctl restart apache2.service

cd /var/www/html/erraztest
if [ -f "test.php" ];
then
	echo "test.php jada existitzen da"
else
	sudo touch test.php
fi
sudo sh -c 'echo "<?php phpinfo(); ?>" > test.php'
firefox http://127.0.0.1:8080/test.php
}	

############################################################
#    7) PYTHON3 INGURUNE BIRTUALA SORTU
#############################################################
function py3venvSortu()
{
echo "#################### py3venvSortu funtzioa"
cd /var/www/html/erraztest
komandoa=`sudo dpkg -l | grep -w "virtualenv"`
mezua=`echo $komandoa`

if [ -n  "$mezua" ];
then    
	dialog --msgbox "virtualenv jada instalatuta dago \n" 5 40
else    
	sudo apt-get install python-virtualenv virtualenv -y
fi

if [ -d "/var/www/html/erraztest/python3envmetrix" ];
then    
	echo "python3envmetrix jada existitzen da"
else    
	sudo virtualenv python3envmetrix --python=python3
fi
}

############################################################
#   8) APPa INSTALATU
#############################################################
function appaInstalatu()
{
#1
echo "#################### appaInstalatu funtzioa"
komandoa1=`sudo dpkg -l | grep -w "python3-pip"`
komandoa2=`sudo dpkg -l | grep -w "dos2unix"`
mezua1=`echo $komandoa1$komandoa2`

if [ -n  "$mezua1" ];
then
	dialog --msgbox "python3-pip eta dos2unix paketeak jada instalatuta daude \n" 5 60
else
	sudo apt-get install python3-pip -y
	sudo apt-get install dos2unix -y
fi

#2
komandoa=`sudo find -name rootcmd.sh`
mezua=`echo $komandoa`
sudo chmod +x /home/fitxategiak/rootcmd.sh
sudo ./rootcmd.sh


#3
cd /home/fitxategiak
sudo cp index.php /var/www/html/erraztest/
sudo cp webprocess.sh /var/www/html/erraztest/
sudo cp complejidadtextual.py /var/www/html/erraztest/
sudo cp english.doc.txt /var/www/html/erraztest


#4
cd /var/www/html/erraztest
sudo chmod +x webprocess.sh
sudo ./webprocess.sh english.doc.txt
}

#############################################################
#   9) APPa BISTARATU
#############################################################
function appaBistaratu()
{
cd /var/www/html/erraztest
echo "#################### appaBistaratu funtzioa"
firefox http://127.0.0.1:8080/index.php
}

##########################################################
#   10) APACHE ERROREAK BISTARATU
##########################################################
function apacheLogak()
{
echo "#################### apacheLogak funtzioa"
cd /var/log/apache2
dialog --textbox error.log 0 0
}

#################################################################
#    11) SSH LOGak KUDEATU 
#################################################################
function sshLogak()
{
echo "#################### sshLogak funtzioa"

komandoa=`sudo aptitude show ssh | grep -w "ssh"`
mezua=`echo $komandoa`

if [ -n  "$mezua" ];
then    
	dialog --msgbox "ssh jada instalatuta dago \n" 5 40
else    
	sudo aptitude install ssh
fi

cd /home/fitxategiak
less /var/log/auth.log | grep 'lsi' > loginak.txt
nf=`less /var/log/auth.log | grep 'lsi' | wc -l`
i=1
touch hamaika.txt
while read line; do
	
	
	data=`echo "$line" loginak.txt | awk '{print $1,$2,$3}'`
	name=`echo "$line" loginak.txt| awk '{print $4}'`
	statu=`echo "$line" loginak.txt | awk '{print $6}'`
	baldintza=`echo $status | grep "Accepted"`
	if [ -z $baldintza];
	then
		echo "Status: [failed]  Account name: $name Date: $data" >> hamaika.txt
	else
		echo "Status: [failed]  Account name: $name Date: $data" >> hamaika.txt
	fi

	i=$((i+1))
done < loginak.txt
dialog --textbox hamaika.txt 0 0
}

###########################################################
#    12) IRTEN                          
###########################################################

function irten()
{
	dialog --msgbox "Agur\n:)" 6 12
}


############
### Main ###
############

# hasieraketa balioa
function main()
{
	exec 3>&1

	aukera=13
	
	while [ $aukera -ne 12 ]
	do
		aukera="$(dialog --title "Web-zerbitzaria" \
			--menu "\n Aukeratu ekintza" 20 70 20 \
			0 "Desinstalatu dena" \
			1 "Instalatu apache" \
			2 "Apache testeatu" \
			3 "VirtualHost-a sortu" \
			4 "VirtualHost-a testeatu" \
			5 "PHP instalatu" \
			6 "PHP testeatu" \
			7 "Py3VENV sortu" \
			8 "APP-a instalatu" \
			9 "APP-a bistaratu" \
			10 "Apache log-ak" \
			11 "SSH log-ak" \
			12 "Irten" \
			2>&1 1>&3)"
	
		case $aukera in
			0) desinstalatuDena;;
			1) apacheInstalatu;;
			2) apacheTestatu;;
			3) virtualHostSortu;;
			4) virtualHostaTestatu;;
			5) phpInstalatu;;
			6) phpTestatu;;
			7) py3venvSortu;;
			8) appaInstalatu;;
			9) appaBistaratu;;
			10) apacheLogak;;
			11) sshLogak;;
			12) irten;;
			*) ;;
		esac 
	
	done
}

main

exit 0
