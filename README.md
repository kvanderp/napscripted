# napscripted

simple bash script to automate NAP setup

Replace crt and key with working ones

Don't forget to update nginx.conf with correct syslog server and upstream server info

docker build -f Dockerfile-sig-dos -t app-protect-dos .

docker run --name my-app-protect-dos -p 80:80 -d app-protect-dos
