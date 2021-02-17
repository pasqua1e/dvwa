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

xff="$((RANDOM % 256))"."$((RANDOM % 256))"."$((RANDOM % 256))"."$((RANDOM % 256))"
ab -c2 -n1000 -H "X-Forwarded-For: $xff" http://secure.dvwa.com:8081/login.php
