#!/bin/bash

# Install Chaotic AUR repository
# https://aur.chaotic.cx/
#
# Provides pre-built AUR packages, reducing compile times

set -e

echo -e "${YELLOW}Setting up Chaotic AUR...${NC}"

# Check if already configured
if grep -q "\[chaotic-aur\]" /etc/pacman.conf 2>/dev/null; then
    echo -e "${GREEN}Chaotic AUR already configured, skipping${NC}"
    exit 0
fi

# Import keys
echo -e "${YELLOW}Importing Chaotic AUR keys...${NC}"
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# Install keyring and mirrorlist
echo -e "${YELLOW}Installing keyring and mirrorlist...${NC}"
sudo pacman -U --noconfirm \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Add repo to pacman.conf
echo -e "${YELLOW}Adding Chaotic AUR to pacman.conf...${NC}"
sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

# Chaotic AUR - added by dwm-zythros installer
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF

# Sync package database
echo -e "${YELLOW}Syncing package database...${NC}"
sudo pacman -Sy

echo -e "${GREEN}Chaotic AUR configured successfully${NC}"
