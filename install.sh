# File: install.sh
#!/bin/bash
set -e

if [ -f /etc/debian_version ]; then
  echo "Installing APT packages..."
  xargs sudo apt-get install -y < packages/apt.txt
elif command -v pacman &> /dev/null; then
  echo "Installing Pacman packages..."
  sudo pacman -S --needed --noconfirm $(< packages/pacman.txt)
elif command -v brew &> /dev/null; then
  echo "Installing Homebrew packages..."
  xargs brew install < packages/brew.txt
else
  echo "Unsupported OS. Exiting."
  exit 1
fi