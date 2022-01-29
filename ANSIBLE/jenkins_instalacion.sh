#!/bin/bash
echo "instalacion de jenkins"
echo ···········································
echo .............................................................
sudo apt install ca-certificates
wget -qO - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update && sudo apt-get install -y openjdk-11-jdk jenkins && sudo systemctl start jenkins
if [[ $? = 0 ]] 
then
	ip=$(ip a |grep "eth1" |grep inet |cut -d"/" -f1|cut -d"t" -f2|awk '{print $1}')
	echo "Termina de configurar Jenkins entrando desde tu navegador en http://$ip:8080"
else	
	echo "Algo salio mal, recuerde mirar los logs"
fi
