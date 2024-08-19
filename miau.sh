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
    # Obtener la lista de discos disponibles
    discosdisponibles=$(echo "print devices" | parted | grep /dev/ | awk '{if (NR!=1) {print}}' | sed '/sr/d')

    # Crear un array para almacenar los discos
    discos=()
    while IFS= read -r linea; do
        discos+=("$linea")
    done <<< "$discosdisponibles"

    # Mostrar el menú y permitir seleccionar una opción
    echo "Selecciona un disco:"
    PS3="Introduce el número de la opción: "
    select disco in "${discos[@]}"; do
        if [[ -n "$disco" ]]; then
            echo "Has seleccionado el disco: $disco"
            # Almacenar la ruta del disco seleccionado en una variable
            disco_seleccionado="$disco"
            break
        else
            echo "Opción no válida. Por favor, selecciona un número válido."
        fi
    done

# Imprimir o utilizar la ruta del disco seleccionado
echo "Ruta del disco seleccionado: $disco_seleccionado"

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