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
    banner(){

        cat banner.txt  
        echo -e "power by ${BOLD}MAURY${RESET}"     
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _

    }

    banner

#Disco      
    #Usar parted para listar discos bajo parametros 
    
    discosdisponibles=$(echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}' | sed '/sr/d')
    echo -e "${BOLD}AVAILABLE DEVICES${RESET}"
    echo ""
    echo $discosdisponibles
    echo ""
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo ""
    echo -e "${RED}${BOLD}IMPORTANT, SELECT CORRECTLY${RESET}"
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
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo ""
    echo -e "${BOLD}Enter the root - $user password ${RESET}(your password is hide)"
    loop=true
    while $loop;
    do
        read -sp "password-> " passwd_aux1
        echo ""
        read -sp "retype your password-> " passwd_aux2
        echo ""
        
        if [ "$passwd_aux1" = "$passwd_aux2" ]; then
            echo ""
            echo -e "${GREEN}${BOLD}Password pased!!!${RESET}"
            passwd=${passwd_aux1}
            loop=false
        else
            echo ""
            echo -e "${RED}${BOLD}Passwords don't match!!!${RESET}"
            echo ""
        fi

    done       
    echo ""                    

#Escritorios

    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo -e "${BOLD}SELECT YOUR PROFILE: (1 - 2 - 3 - 4)${RESET}"
    
    #Funcion
    loop=true
    desks=("MINIMAL" "KDE" "XFCE" "GNOME")
    while $loop; do
        echo ""
        echo "1. ${desks[0]}"
        echo "2. ${desks[1]}"
        echo "3. ${desks[2]}"
        echo "4. ${desks[3]}"
        echo ""
        read -p "Select your profile -> " desktop        
        echo ""

        if [ "$desktop" -ge 1 ] && [ "$desktop" -le 4 ]; then
            loop=false
        else
            echo -e "${RED}Please select an option!!!${RESET}"
        fi

    done
    desktop=$((desktop -1))
    echo -e "Your profile -> ${BOLD}${desks[$desktop]}${RESET}" 
    echo ""

#Install
    clear
    banner
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
    echo -e "${BOLD}INSTALL OPTIONS AND ARCH INSTALLATION${RESET}"
    echo ""
    echo -e "disk -> ${BOLD}$disk${RESET}"
    echo ""
    echo -e "username -> ${BOLD}$user${RESET}"
    echo ""
    echo -e "password -> ${BOLD}$passwd${RESET}"
    echo ""
    echo -e "profile -> ${BOLD}${desks[$desktop]}${RESET}"
    echo ""
    echo "Press ENTER to continue or CTRL + C to exit"
    read line
    echo ""
    sleep 3
    echo -e "${GREEN}DONE!!!${RESET}"


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