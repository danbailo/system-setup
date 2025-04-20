# File: bootstrap.sh
#!/bin/bash
set -e

./install.sh
./scripts/symlink_dotfiles.sh
./scripts/post_install.sh

# Directory: packages/
# Files:
# - apt.txt
# - pacman.txt
# - brew.txt
# Add your packages line-by-line in each file

# Directory: dotfiles/
# Files:
# - .bashrc
# - .zshrc
# - nvim/init.lua (or other editor configs)

# Directory: system/
# Files:
# - dconf-settings.ini
# - gnome-keybindings.conf
# Include optional desktop environment or system-level configs

# Optional: .gitignore
# Ignore system-specific files and sensitive data
*.swp
*.swo
*.bak
.cache
ssh_keys/

# Optional: .gitattributes
# Use to protect or encode specific files if using git-crypt or similar
