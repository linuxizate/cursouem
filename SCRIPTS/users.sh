#!/bin/bash
#Gestion de password segun la distribucion.
#Para CentOS
#echo "$new_password" | passwd --stdin "$new_username"
#Para Debian / Ubuntu
#echo "$new_username:$new_password" | chpasswd
#Para OpenSUSE
#echo -e "$new_password\n$new_password" | passwd "$new_username"

echo "Introduce un nombre:"
read USER
PASS=123456
if [[ $UID != 0 ]]
then
        echo "Necesitas ser root para poder crear usuarios"

else
        useradd -m  -s /bin/bash -p $(openssl passwd -1 $PASS) $USER && echo "Usuario creado"
	chage -d 0 $USER && echo "El usuario debe de cambiar la contraseña al iniciar sesión"

fi

