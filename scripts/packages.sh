#!/bin/bash

# Install additional personal packages
# Requires Chaotic AUR for -bin packages

set -e

PACKAGES=(
    "mullvad-browser-bin"
    "brave-bin"
    "vim"
)

echo -e "${YELLOW}Installing personal packages...${NC}"

# Check for Chaotic AUR (required for -bin packages)
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf 2>/dev/null; then
    echo -e "${RED}Error: Chaotic AUR not configured. Run chaotic-aur.sh first${NC}"
    exit 1
fi

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo -e "${GREEN}Personal packages installed${NC}"
