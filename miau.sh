#! /bin/bash
: '

Installer Arch User

'
#--->Banner
    clear               
    cat banner.txt        

#Disco
    discosdisponibles=$(echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}' | sed '/sr/d')
    clear
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo ""
    echo "Rutas de Disco disponible: "
    echo ""
    echo $discosdisponibles
    echo ""
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _

#Usuario                
    # echo ""
    # read -p "Introduce tu disco a instalar Arch: " disco
    echo ""
    read -p "Username: " user
    echo ""
    read -p "Password        $user / root: " passwd
    echo ""

#Idioma del sistema
    idioma=$(curl https://ipapi.co/languages)".UTF8"
    #echo $idioma

#Instalar paquetes post-instalacion
    #sudo pacman -S --needed -< packages.txt