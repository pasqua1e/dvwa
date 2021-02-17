xff="$((RANDOM % 256))"."$((RANDOM % 256))"."$((RANDOM % 256))"."$((RANDOM % 256))"
ab -c2 -n1000 -H "X-Forwarded-For: $xff" http://secure.dvwa.com:8081/login.php
