#!/bin/bash -x

SERVER="api.example.local"
PORT=6443

output=$(echo "" | openssl s_client -servername $SERVER -verify_hostname $SERVER -connect $SERVER:$PORT 2>/dev/null)
expire_date=$( echo "$output" | openssl x509 -noout -dates | grep '^notAfter' | cut -d'=' -f2 )
expire_date_epoch=$(date -d "$expire_date" +%s)
current_date_epoch=$(date +%s)
days_left=$(( (expire_date_epoch - current_date_epoch)/(3600*24) ))
echo "$days_left"

openssl req -x509 -nodes -days ${dayscert} -newkey rsa:${bit} -keyout ${dircrt}/${domain}-${year}.key -out ${dirkey}/${domain}-${year}.crt
