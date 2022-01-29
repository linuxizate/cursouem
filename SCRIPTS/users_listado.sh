#!/bin/bash
PASS=123456
if [[ $UID != 0 ]]
then
        echo "Tienes que ser root para poder crear usuarios"
else
        if [[ -f listado.txt ]]
        then
                for USER in $(cat listado.txt)
                do
                        echo "Creando usuarios segun listado"
                        useradd -m -s /bin/bash -p $(openssl passwd -1 $PASS) $USER
                        chage -d 0 $USER
                done
        else
                echo "Debes de pasar un listado listado.txt"
                exit 1
        fi
fi
echo "los usuarios deberan de cambiar la passwd en su primer logeo."
