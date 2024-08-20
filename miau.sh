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
    echo ""


#Idioma del sistema
    idioma=$(curl https://ipapi.co/languages)".UTF8"
    #echo $idioma
    
#--->Proceso de instalacion

#UEFI-BIOS
    ue=false
    if test -d "/sys/firmware/efi"; then
        echo "El sistema es UEFI"
        ue=true
    else                    
        echo "El sistema es BIOS"
        ue=false
    fi

#Particionado

    if [ $ue == true ]
    then
        clear
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
        echo ""
        echo -e "Your system is ${BOLD}UEFI${RESET}"
        echo ""
        date "+%F %H:%M"
        sleep 3

        swapsize=$(free --giga | awk '/^Mem:/{print $2}')
        #dd if=/dev/zero of="${disco}" bs=4M conv=fsync oflag=direct status=progress
        (echo Ignore) | sgdisk --zap-all ${disk}
        #parted ${disco} mklabel gpt
        (echo 2; echo w; echo Y) | gdisk ${disk}
        sgdisk ${disk} -n=1:0:+100M -t=1:ef00
        sgdisk ${disk} -n=2:0:+${swapsize}G -t=2:8200
        sgdisk ${disk} -n=3:0:0
        fdisk -l ${disk} > /tmp/partition
        echo ""
        cat /tmp/partition
        sleep 3

        partition="$(cat /tmp/partition | grep /dev/ | awk '{if (NR!=1) {print}}' | sed 's/*//g' | awk -F ' ' '{print $1}')"

        echo $partition | awk -F ' ' '{print $1}' >  boot-efi
        echo $partition | awk -F ' ' '{print $2}' >  swap-efi
        echo $partition | awk -F ' ' '{print $3}' >  root-efi

        clear
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
        echo ""
        echo -e "${BOLD}Your UEFI partition is:${RESET}" 
        cat boot-efi
        echo ""
        echo -e "${BOLD}Your SWAP partition is:${RESET}"
        cat swap-efi
        echo ""
        echo -e "${BOLD}Your ROOT partition is:${RESET}"
        cat root-efi
        sleep 3

        clear
        echo ""
        echo "Formatting Partitions"
        echo ""
        mkfs.ext4 $(cat root-efi) 
        mount $(cat root-efi) /mnt 

        mkdir -p /mnt/efi 
        mkfs.fat -F 32 $(cat boot-efi) 
        mount $(cat boot-efi) /mnt/efi 

        mkswap $(cat swap-efi) 
        swapon $(cat swap-efi)

        rm boot-efi
        rm swap-efi
        rm root-efi

        clear
        echo ""
        echo -e "${BOLD}Check the mount point at MOUNTPOINT - PRESS ENTER${RESET}"
        echo ""
        lsblk -l
        read line


    else
        clear
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
        echo ""
        echo -e "Your system is ${BOLD}BIOS${RESET}"
        echo ""
        date "+%F %H:%M"
        sleep 3

        swapsize=$(free --giga | awk '/^Mem:/{print $2}')
        #dd if=/dev/zero of="${disco}" bs=100M count=10 status=progress
        sgdisk --zap-all ${disco}
        (echo o; echo n; echo p; echo 1; echo ""; echo +100M; echo n; echo p; echo 2; echo ""; echo +${swapsize}G; echo n; echo p; echo 3; echo ""; echo ""; echo t; echo 2; echo 82; echo a; echo 1; echo w; echo q) | fdisk ${disco}
        fdisk -l ${disco} > /tmp/partition 
        cat /tmp/partition
        sleep 3

        partition="$(cat /tmp/partition | grep /dev/ | awk '{if (NR!=1) {print}}' | sed 's/*//g' | awk -F ' ' '{print $1}')"

        echo $partition | awk -F ' ' '{print $1}' >  boot-bios
        echo $partition | awk -F ' ' '{print $2}' >  swap-bios
        echo $partition | awk -F ' ' '{print $3}' >  root-bios

        clear
        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
        echo ""
        echo -e "${BOLD}Your BOOT partition is:${RESET}" 
        cat boot-bios
        echo ""
        echo -e "${BOLD}Your SWAP partition is:${RESET}" 
        cat swap-bios
        echo ""
        echo -e "${BOLD}Your ROOT partition is:${RESET}" 
        cat root-bios
        sleep 3

        clear
        echo ""
        echo "Formatting Partitions"
        echo ""
        mkfs.ext4 $(cat root-bios) 
        mount $(cat root-bios) /mnt 

        mkdir -p /mnt/boot
        mkfs.ext4 $(cat boot-bios) 
        mount $(cat boot-bios) /mnt/boot

        mkswap $(cat swap-bios) 
        swapon $(cat swap-bios)

        clear
        echo ""
        echo -e "${BOLD}Check the mount point at MOUNTPOINT - PRESS ENTER${RESET}"
        echo ""
        lsblk -l
        sleep 4
        clear
        
    fi


#Instalar paquetes post-instalacion
    #sudo pacman -S --needed -< packages.txt