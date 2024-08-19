#! /bin/bash
: '

Installer Arch User

'
#--->Banner
    clear               
    cat banner.txt        

#Usuario                
    # echo ""
    # read -p "Introduce tu disco a instalar Arch: " disco
    echo ""
    read -p "Introduce Nombre usuario Nuevo: " user
    echo ""
    read -p "Introduce la clave de $user / root: " passwd
    echo ""

#Idioma del sistema
    idioma=$(curl https://ipapi.co/languages)".UTF8"
    #echo $idioma

#Instalar paquetes post-instalacion
    #sudo pacman -S --needed -< packages.txt