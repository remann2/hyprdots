#!/bin/bash

# This script restores dotfiles and configs from a backup directory

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Set backup and restore directories
backup_dir=~/Hyprdots/Configs/.config/hypr
restore_dir=~/.config/hypr

# Check if backup directory exists
# if [ ! -d "$backup_dir" ]; then
#     echo -e "${RED}Error: Backup directory $backup_dir not found.${NC}"
#     exit 1
# fi

# Prompt user for confirmation
echo -e "${GREEN}This script will overwrite the contents of $restore_dir with files from $backup_dir.${NC}"
read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Script cancelled by user."
    exit 1
fi

# Create backup of current restore directory
# echo "Creating backup of current $restore_dir..."
# cp -r "$restore_dir" "${restore_dir}_bak_$(date +%Y%m%d_%H%M%S)"

# Restore files from backup
echo "Restoring files from $backup_dir to $restore_dir..."
cp "$backup_dir"/*.conf "$restore_dir"/

echo -e "${GREEN}Restore completed successfully.${NC}"