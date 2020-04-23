#!/bin/bash
DIRVIRTPYTHON='python3envmetrix'
source /var/www/html/erraztest/$DIRVIRTPYTHON/bin/activate
echo "`id`"
python3 ./complejidadtextual.py $1
deactivate


