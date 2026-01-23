#!/bin/bash

# Setup xprofile for VM display resolution
# Configures xrandr to run at login via ~/.xprofile

set -e

XPROFILE="$HOME/.xprofile"
MARKER="# dwm-zythros VM display"

echo -e "${YELLOW}Setting up VM display resolution...${NC}"

# Check if already configured
if [ -f "$XPROFILE" ] && grep -q "$MARKER" "$XPROFILE"; then
    echo -e "${GREEN}xprofile already configured, skipping${NC}"
    exit 0
fi

cat >> "$XPROFILE" << 'EOF'

# dwm-zythros VM display
# Comment out these lines if not running in a VM
xrandr --output Virtual-1 --primary --mode 2560x1080 --pos 0x0 --rotate normal
# end dwm-zythros VM display
EOF

chmod +x "$XPROFILE"
echo -e "${GREEN}xprofile configured${NC}"
