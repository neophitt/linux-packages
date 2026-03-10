#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Options de sélection (1 = coché, 0 = décoché)
SELECTED=(1 0 0 0)
CURRENT=0
OPTIONS=("pip" "pipx" "virtualenv" "poetry")

print_menu() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ██████╗ ██╗   ██╗████████╗██╗  ██╗ ██████╗ ███╗   ██╗"
    echo "  ██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║  ██║██╔═══██╗████╗  ██║"
    echo "  ██████╔╝ ╚████╔╝    ██║   ███████║██║   ██║██╔██╗ ██║"
    echo "  ██╔═══╝   ╚██╔╝     ██║   ██╔══██║██║   ██║██║╚██╗██║"
    echo "  ██║        ██║      ██║   ██║  ██║╚██████╔╝██║ ╚████║"
    echo "  ╚═╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
    echo -e "${RESET}"
    echo -e "${BOLD}  Installation de Python${RESET}"
    echo -e "  ${YELLOW}by neophit ${RESET}${BLUE}• https://github.com/neophitt${RESET}"
    echo ""
    echo -e "  ${BLUE}[Espace] Sélectionner  |  [Entrée] Confirmer  |  [↑↓] Naviguer${RESET}"
    echo ""

    for i in "${!OPTIONS[@]}"; do
        local checkbox
        if [ "${SELECTED[$i]}" -eq 1 ]; then
            checkbox="${GREEN}[✔]${RESET}"
        else
            checkbox="${RED}[ ]${RESET}"
        fi

        if [ "$i" -eq "$CURRENT" ]; then
            echo -e "  ${YELLOW}▶ $checkbox ${BOLD}${OPTIONS[$i]}${RESET}"
        else
            echo -e "    $checkbox ${OPTIONS[$i]}"
        fi
    done

    echo ""
}

# Sélection interactive
while true; do
    print_menu

    IFS= read -r -s -n1 key
    if [[ $key == $'\x1b' ]]; then
        read -r -s -n2 key
        case $key in
            '[A') ((CURRENT--)); [ $CURRENT -lt 0 ] && CURRENT=$(( ${#OPTIONS[@]} - 1 )) ;;
            '[B') ((CURRENT++)); [ $CURRENT -ge ${#OPTIONS[@]} ] && CURRENT=0 ;;
        esac
    elif [[ $key == ' ' ]]; then
        if [ "${SELECTED[$CURRENT]}" -eq 1 ]; then
            SELECTED[$CURRENT]=0
        else
            SELECTED[$CURRENT]=1
        fi
    elif [[ $key == '' ]]; then
        break
    fi
done

clear
echo -e "${CYAN}${BOLD}Installation de Python...${RESET}"
echo ""

# Installation de Python
echo -e "${BLUE}▶ Installation de Python3...${RESET}"
sudo apt update -qq
sudo apt install -y python3 python3-dev build-essential
echo -e "${GREEN}✔ Python $(python3 --version) installé${RESET}"
echo ""

# pip
if [ "${SELECTED[0]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de pip...${RESET}"
    sudo apt install -y python3-pip
    echo -e "${GREEN}✔ pip $(pip3 --version | awk '{print $2}') installé${RESET}"
fi

# pipx
if [ "${SELECTED[1]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de pipx...${RESET}"
    sudo apt install -y pipx
    pipx ensurepath
    echo -e "${GREEN}✔ pipx installé${RESET}"
fi

# virtualenv
if [ "${SELECTED[2]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de virtualenv...${RESET}"
    pip3 install virtualenv --break-system-packages
    echo -e "${GREEN}✔ virtualenv $(virtualenv --version) installé${RESET}"
fi

# poetry
if [ "${SELECTED[3]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de poetry...${RESET}"
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
    echo -e "${GREEN}✔ poetry $(poetry --version) installé${RESET}"
fi

echo ""
echo -e "${GREEN}${BOLD}✔ Installation terminée !${RESET}"
echo ""
echo -e "${YELLOW}⚠ Redémarre ton terminal ou exécute :${RESET}"
echo -e "  ${CYAN}source ~/.bashrc${RESET}"
echo ""