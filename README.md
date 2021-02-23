# dvwa
scripts to demo DVWA attacks

You can use 2 different containers, one with no protection and the other protected by WAAS, e.g.:

docker run -d --name waas-dvwa -p 8081:80 vulnerables/web-dvwa <br>
docker run -d --name dvwa --rm -it -p 80:80 vulnerables/web-dvwa <br>

And then create hosts entries for simplicity, e.g.:<br>
dvwa.com	192.168.1.2<br>
waas.dvwa.com	192.168.1.2<br>

Where 192.168.1.2 is your host IP address

Additional example of attacks available here:
https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/waas/waas_app_firewall.html
