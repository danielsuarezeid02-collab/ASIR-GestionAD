#!/bin/bash

ADMIN_DN="cn=admin,dc=daniel2026,dc=ldap"
BASE_DN="dc=daniel2026,dc=ldap"

opcion=0
while [ "$opcion" -ne 4 ]; do
    clear
    echo "MENU AUTOMATIZACION LDAP"
    echo "1. Eliminar correo de un usuario"
    echo "2. Modificar correo de un usuario"
    echo "3. Realizar busquedas"
    echo "4. salir"
    read -p "Elige una opcion (1-4):" opcion

    case $opcion in
        1)
            read -p "Introduce el usuario (cn):" usuario
            read -p "Introduce la OU (Alumnado/Profesorado): " ou

            echo "dn: cn=$usuario,ou=$ou,$BASE_DN" > temp.ldif
            echo "changetype: modify" >> temp.ldif
            echo "delete: mail" >> temp.ldif

            ldapmodify -x -D "$ADMIN_DN" -W -f temp.ldif
            rm -f temp.ldif
            read -p "Pulse enter para continuar..."
            ;;
        2)
            read -p "Introduce el usuario (cn): " usuario
            read -p "Introduce la OU (Alumnado/Profesorado): " ou
            read -p "Introduce el nuevo correo: " correo

            echo "dn: cn=$usuario,ou=$ou,$BASE_DN" > temp.ldif
            echo "changetype: modify" >> temp.ldif
            echo "replace: mail" >> temp.ldif
            echo "mail: $correo" >> temp.ldif

            ldapmodify -x -D "$ADMIN_DN" -W -f temp.ldif
            rm -f temp.ldif
            read -p "Pulsa enter para continuar..."
            ;;
        3)
            echo "a. Consultar usuario concreto"
            echo "b. listar todos (nombre y correo)"
            read -p "Elige (a/b): " subopcion

            if [ "$subopcion" == "a" ]; then
                read -p "Introduce usuario (cn): " usuario
                ldapsearch -x -b "$BASE_DN" "(cn=$usuario)" cn mail
            elif [ "$subopcion" == "b" ]; then
                ldapsearch -x -b "$BASE_DN" "(objectClass=inetOrgPerson)" cn mail
            fi
            read -p "Pulsa enter para continuar..."
            ;;
        4)
            echo "saliendo del script..."
            ;;
    esac
done
