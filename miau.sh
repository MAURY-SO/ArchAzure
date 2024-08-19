#! /bin/bash
: '

Installer Arch User

'

#STYLE

# Definir códigos de color
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'
BOLD='\033[1m'

#--->Banner
    clear               
    cat banner.txt        
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _

#Disco      
    #Usar parted para listar discos bajo parametros 
    discosdisponibles=$(echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}' | sed '/sr/d')
    echo -e "${BOLD}AVAILABLE DEVICES${RESET}"
    echo ""
    echo $discosdisponibles
    echo ""
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo ""
    read -p "disk (device path) -> " disk 
    echo ""
    echo -e "Your device select -> ${BOLD}$disk${RESET}" 

#Usuario

    echo ""
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo -e "${BOLD}USER CONFIGURATION${RESET}"      
    echo ""          
    read -p "username-> " user_aux
    echo ""
    user=${user_aux,,}
    echo -e "Your username --> ${BOLD}$user${RESET}"
    echo ""
    echo "Enter the root - $user password (your password is hide)"
    loop=true
    while $loop;
    do
        read -sp "password-> " passwd
        echo ""
        read -sp "retype your password-> " passwd_aux
        echo ""
        
        if [ "$passwd" = "$passwd_aux" ]; then
            echo ""
            echo -e "${GREEN}${BOLD}Password pased!!!${RESET}"
            loop=false
        else
            echo ""
            echo -e "${RED}${BOLD}Password incorrect!!!${RESET}"
            echo ""
        fi

    done       
    echo ""                    

#Idioma del sistema
    idioma=$(curl https://ipapi.co/languages)".UTF8"
    #echo $idioma

#--->Proceso de instalacion

#UEFI-BIOS
    if test -d "/sys/firmware/efi"; then
        echo "El sistema es UEFI"
    else
        echo "El sistema es BIOS"
    fi

#Particionado

    #UEFI


#Instalar paquetes post-instalacion
    #sudo pacman -S --needed -< packages.txt