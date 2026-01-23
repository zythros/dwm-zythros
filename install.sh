#!/bin/bash

# dwm-zythros install script
# Installs to ~/.config/dwm

set -e

# Colors (exported for sub-scripts)
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export NC='\033[0m' # No Color

export INSTALL_DIR="$HOME/.config/dwm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DESKTOP_FILE="/usr/share/xsessions/dwm.desktop"

echo -e "${GREEN}dwm-zythros installer${NC}\n"

# Check if running on Arch
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Error: This script is designed for Arch Linux${NC}"
    exit 1
fi

# Build dependencies
BUILD_DEPS=(
    "base-devel"
    "libx11"
    "libxft"
    "libxinerama"
    "freetype2"
)

# Runtime dependencies
RUNTIME_DEPS=(
    "alacritty"
    "rofi"
    "thunar"
    "xorg-xrandr"
)

# Check and install dependencies
install_deps() {
    local missing=()

    echo -e "${YELLOW}Checking build dependencies...${NC}"
    for dep in "${BUILD_DEPS[@]}"; do
        if ! pacman -Qi "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done

    echo -e "${YELLOW}Checking runtime dependencies...${NC}"
    for dep in "${RUNTIME_DEPS[@]}"; do
        if ! pacman -Qi "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing missing packages: ${missing[*]}${NC}"
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    else
        echo -e "${GREEN}All dependencies satisfied${NC}"
    fi
}

# Backup existing dwm
backup_existing() {
    if [ -d "$INSTALL_DIR" ]; then
        BACKUP_DIR="$HOME/.config/dwm.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Backing up existing dwm to $BACKUP_DIR${NC}"
        mv "$INSTALL_DIR" "$BACKUP_DIR"
    fi

    if [ -f "$DESKTOP_FILE" ]; then
        echo -e "${YELLOW}Backing up existing desktop file${NC}"
        sudo cp "$DESKTOP_FILE" "${DESKTOP_FILE}.backup"
    fi
}

# Install dwm
install_dwm() {
    echo -e "${YELLOW}Installing dwm to $INSTALL_DIR${NC}"

    mkdir -p "$INSTALL_DIR"

    # Copy source files (exclude installer and sub-scripts)
    cp -r "$SCRIPT_DIR"/* "$INSTALL_DIR/"
    rm -f "$INSTALL_DIR/install.sh"
    rm -rf "$INSTALL_DIR/scripts"

    # Build
    cd "$INSTALL_DIR"
    make clean
    make

    echo -e "${GREEN}Build complete${NC}"
}

# Create desktop entry for display manager
create_desktop_entry() {
    echo -e "${YELLOW}Creating desktop entry...${NC}"

    sudo tee "$DESKTOP_FILE" > /dev/null << EOF
[Desktop Entry]
Name=dwm
Comment=Dynamic Window Manager
Exec=$INSTALL_DIR/dwm
Type=Application
EOF

    echo -e "${GREEN}Desktop entry created at $DESKTOP_FILE${NC}"
}

# Main
install_deps
backup_existing
install_dwm
create_desktop_entry

# Optional sub-scripts (comment out to skip)
"$SCRIPT_DIR"/scripts/chaotic-aur.sh
"$SCRIPT_DIR"/scripts/packages.sh
"$SCRIPT_DIR"/scripts/xprofile.sh

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "Select 'dwm' from your display manager to start"
echo -e "Config location: $INSTALL_DIR/config.h"
echo -e "VM display config: ~/.xprofile (comment out if not in VM)"
echo -e "\nTo rebuild after config changes:"
echo -e "  cd $INSTALL_DIR && make clean && make"
