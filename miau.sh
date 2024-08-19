#! /bin/bash
: '

Installer Arch User

'
#--->Banner
    clear               
    cat banner.txt        

#Disco      
    discosdisponibles=$(echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}' | sed '/sr/d')
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo ""
    echo "Rutas de Disco disponible: "
    echo ""
    echo $discosdisponibles
    echo ""
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _

#Usuario                
    echo ""
    read -p "Disk: " disk       
    read -p "Username: " user
    read -p "Password $user-root: " passwd
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