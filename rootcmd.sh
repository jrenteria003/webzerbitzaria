#!/bin/bash
cd /var/www/html/erraztest/python3envmetrix/bin
source activate
komandoa3=`pip3 show numpy | grep -w "numpy"`
komandoa4=`pip3 show nltk | grep -w "nltk"`
komandoa5=`pip3 show argparse | grep -w "argparse"`
mezua2=`echo $komandoa3$komandoa4$komandoa5`

if [ -n  "$mezua2" ];
then
	echo "numpy, nltk eta argparse jada instalatuta daude"
else
	pip3 install numpy
	pip3 install nltk
	pip3 install argparse
	
fi
deactivate
