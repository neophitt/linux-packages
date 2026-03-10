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
INSTALL_NPM=1
INSTALL_PNPM=0
INSTALL_YARN=0

CURRENT=0
OPTIONS=("npm" "pnpm" "yarn")
SELECTED=($INSTALL_NPM $INSTALL_PNPM $INSTALL_YARN)

print_menu() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "  ███╗   ██╗ ██████╗ ██████╗ ███████╗"
    echo "  ████╗  ██║██╔═══██╗██╔══██╗██╔════╝"
    echo "  ██╔██╗ ██║██║   ██║██║  ██║█████╗  "
    echo "  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  "
    echo "  ██║ ╚████║╚██████╔╝██████╔╝███████╗"
    echo "  ╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝"
    echo -e "${RESET}"
    echo -e "${BOLD}  Installation de Node.js via NVM${RESET}"
    echo -e "  ${YELLOW}by neophit ${RESET}${BLUE}• https://github.com/neophitt${RESET}"
    echo -e "  ${YELLOW}Sélectionne les package managers à installer${RESET}"
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
echo -e "${CYAN}${BOLD}Installation de NVM et Node.js...${RESET}"
echo ""

# Installation de NVM
echo -e "${BLUE}▶ Installation de NVM...${RESET}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Charger NVM dans la session courante
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo -e "${GREEN}✔ NVM installé${RESET}"
echo ""

# Installation de la dernière version LTS de Node.js
echo -e "${BLUE}▶ Installation de Node.js LTS...${RESET}"
nvm install --lts
nvm use --lts
nvm alias default node
echo -e "${GREEN}✔ Node.js $(node -v) installé${RESET}"
echo ""

# Installation des package managers sélectionnés
if [ "${SELECTED[0]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de npm...${RESET}"
    npm install -g npm@latest
    echo -e "${GREEN}✔ npm $(npm -v) installé${RESET}"
fi

if [ "${SELECTED[1]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de pnpm...${RESET}"
    npm install -g pnpm
    echo -e "${GREEN}✔ pnpm $(pnpm -v) installé${RESET}"
fi

if [ "${SELECTED[2]}" -eq 1 ]; then
    echo -e "${BLUE}▶ Installation de yarn...${RESET}"
    npm install -g yarn
    echo -e "${GREEN}✔ yarn $(yarn -v) installé${RESET}"
fi

echo ""
echo -e "${GREEN}${BOLD}✔ Installation terminée !${RESET}"
echo ""
echo -e "${YELLOW}⚠ Redémarre ton terminal ou exécute :${RESET}"
echo -e "  ${CYAN}source ~/.bashrc${RESET}"
echo ""