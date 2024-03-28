#!/bin/bash

# This script restores dotfiles and configs from a backup directory

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color



# Set backup and restore directories
backup_dir=~/Hyprdots/Configs/.config/hypr
restore_dir=~/.config/hypr

# Restore files from backup
echo "Restoring specified files from $backup_dir to $restore_dir..."
cp "$backup_dir"/plugins.conf "$restore_dir"/
cp "$backup_dir"/startups.conf "$restore_dir"/
cp "$backup_dir"/monitors.conf "$restore_dir"/
cp "$backup_dir"/keybindings.conf "$restore_dir"/
cp "$backup_dir"/windowrules.conf "$restore_dir"/