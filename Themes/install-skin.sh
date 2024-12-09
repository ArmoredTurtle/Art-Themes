#!/usr/bin/env bash
# Multi-Skin Theme Installer for Mainsail and Fluidd Dashboards
#
# Armored Turtle - Skins Installer
#
# This file may be distributed under the terms of the GNU GPLv3 license.

# Colors
GREEN='\033[1;32m'
GOLD='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[1;31m'
RESET='\033[0m'

# Colored message function
print_msg() {
  local color="$1"
  shift
  echo -e "${color}$*${RESET}"
}

# Default Parameters
KLIPPER_TARGET_DIR="$(realpath ${HOME}/printer_data/config)"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Debug messages for paths
print_msg "$CYAN" "Debug: KLIPPER_TARGET_DIR=${KLIPPER_TARGET_DIR}"
print_msg "$CYAN" "Debug: REPO_DIR=${REPO_DIR}"

# Function to select the dashboard type
function choose_dashboard {
    print_msg "$GOLD" "Choose your dashboard type:"
    print_msg "$CYAN" "1. Mainsail"
    print_msg "$CYAN" "2. Fluidd"
    read -p "Enter the number of your choice: " dashboard_choice

    case "$dashboard_choice" in
        1)
            DASHBOARD="Mainsail"
            THEME_EXTENSION=".theme"
            ;;
        2)
            DASHBOARD="Fluidd"
            THEME_EXTENSION=".fluidd-theme"
            ;;
        *)
            print_msg "$RED" "Invalid selection. Exiting."
            exit 1
            ;;
    esac
}

# Function to list available skins for the chosen dashboard
function list_skins {
    if [[ ! -d "${REPO_DIR}/${DASHBOARD}" ]]; then
        print_msg "$RED" "Error: No skins found for $DASHBOARD in ${REPO_DIR}/${DASHBOARD}!"
        exit 1
    fi

    skins=($(ls -d ${REPO_DIR}/${DASHBOARD}/*/ 2>/dev/null))
    if [[ "${#skins[@]}" -eq 0 ]]; then
        print_msg "$RED" "Error: No skins available for $DASHBOARD."
        exit 1
    fi

    print_msg "$GREEN" "Available skins for $DASHBOARD:"
    for i in "${!skins[@]}"; do
        skin_name=$(basename "${skins[$i]}")
        print_msg "$CYAN" "$((i+1)). $skin_name"
    done
}

# Function to prompt user for skin selection
function choose_skin {
    list_skins
    print_msg "$GOLD" "Enter the number of the skin you want to install:"
    read -p "> " choice

    if [[ "$choice" -ge 1 && "$choice" -le "${#skins[@]}" ]]; then
        selected_skin=$(basename "${skins[$((choice-1))]}")
        SRCDIR="${REPO_DIR}/${DASHBOARD}/${selected_skin}/${THEME_EXTENSION}"
        print_msg "$GREEN" "You selected: $selected_skin"
    else
        print_msg "$RED" "Invalid selection. Exiting."
        exit 1
    fi
}

# Function to install the selected theme
function install_theme {
    if [[ ! -d "${SRCDIR}" ]]; then
        print_msg "$RED" "Error: Theme directory ${SRCDIR} not found!"
        exit 1
    fi

    THEME_FILES="${KLIPPER_TARGET_DIR}/${THEME_EXTENSION}"

    if [[ -e "$THEME_FILES" ]]; then
        print_msg "$GOLD" "A theme is already installed for $DASHBOARD."
        print_msg "$GOLD" "Do you want to replace it with the new skin ($selected_skin)? (y/n):"
        read -p "> " overwrite
        if [[ "$overwrite" != "y" && "$overwrite" != "Y" ]]; then
            print_msg "$RED" "Installation canceled."
            exit 0
        fi
        print_msg "$GREEN" "Replacing existing theme..."
        rm -rf "$THEME_FILES"
    fi

    print_msg "$GREEN" "Installing theme: $selected_skin for $DASHBOARD..."
    ln -sf "${SRCDIR}" "${THEME_FILES}"
    print_msg "$GREEN" "Theme $selected_skin has been installed for $DASHBOARD. Enjoy!"
    print_msg "$CYAN" "Refresh browser for changes to take effect."
}

# Function to uninstall the theme
function uninstall_theme {
    THEME_FILES="${KLIPPER_TARGET_DIR}/${THEME_EXTENSION}"

    if [[ -L "$THEME_FILES" ]]; then
        rm "$THEME_FILES"
        print_msg "$GREEN" "Theme uninstalled successfully for $DASHBOARD."
    else
        print_msg "$RED" "No theme installation found to remove for $DASHBOARD."
    fi
}

# Main script logic
case "$1" in
    -u)
        clear
        choose_dashboard
        uninstall_theme
        ;;
    "")
        clear
        choose_dashboard
        choose_skin
        install_theme
        ;;
    *)
        print_msg "$RED" "Invalid argument: $1"
        exit 1
        ;;
esac

# Exit with success status
exit 0
