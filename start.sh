#!/bin/bash

# hasierako balio bat errorerik ez izateko
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

	#case $aukera in
	#	0) desinstalatu;;
	#	*) ;;
	#esac

done
exit 0
