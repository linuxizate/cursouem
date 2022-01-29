#!/bin/bash
echo "Instalacion de servidor web"
if [[ $UID = 0 ]]
then
        while true;
        do
                echo "Escoja una opcion"
                echo "1.- Instalar apache"
                echo "2.- Instalar nginx"
                echo "3.- Instalar nodejs"
                echo "4.- Salir"
                echo ""
                echo -n "Seleccione una opcion 1-4"
                echo ""
                read opcion
                case $opcion in
                1) echo "Instalando Apache";
                apt-get update && apt-get install -y apache2;;
                2) echo "Instalando Nginx";
                apt-get update && apt-get install -y nginx;;
                3) echo "Instalar nodejs";
                apt-get update && apt-get install -y nodejs;;
                4) echo "Script terminado con exito, Gracias!";
                exit 1;;
                *) echo "$opc es una opcion invalida. Es tan dificil?";
                echo "Presiona una tecla para continuar...";
                read foo;;
        esac
        done
else
        echo "Necesitas ser root para poder instalar"
fi
