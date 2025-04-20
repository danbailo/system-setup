# File: scripts/post_install.sh
#!/bin/bash
set -e

echo "Setting up Git configuration..."
git config --global user.name "Daniel Bailo"
git config --global user.email "danbailoufms@gmail.com"

# Add any other post-install steps below
# e.g., setting up SSH keys, fonts, editor plugins, etc.

#!/bin/bash

set -e

echo "==> Upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "==> Installing essentials packages..."
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  unzip \
  htop \
  ca-certificates \
  software-properties-common \
  apt-transport-https \
  gnupg \
  lsb-release \
  jq \
  fzf \
  tmux \
  zsh \
  fonts-firacode

echo "==> Installing Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] \
  http://dl.google.com/linux/chrome/deb/ stable main" | \
  sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
sudo apt update
sudo apt install -y google-chrome-stable

echo "==> Installing Terminator..."
sudo apt install -y terminator

echo "==> Installing Docker and Docker Compose..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"

echo "==> Installing Node.js LTS (utils to CLI, tools like eslint, etc)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "==> Installing SDKs e ferramentas dev..."
sudo apt install -y \
  python3-pip \
  python3-venv \
  default-jdk

sudo apt install -y apt-transport-https ca-certificates gnupg curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo apt-key add -

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
  http://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

echo "==> Installing Vscode..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] \
  https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code -y

echo "==> Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  chsh -s $(which zsh)
fi

echo "==> Settings themes and ZSH plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

sed -i 's/plugins=(git)/plugins=(git docker fzf zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"

echo "==> Enabling CPU performance (Intel)..."
sudo apt install -y intel-microcode
sudo apt install -y powertop
sudo powertop --auto-tune

echo "==> Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/spotify.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/spotify.gpg] \
  http://repository.spotify.com stable non-free" | \
  sudo tee /etc/apt/sources.list.d/spotify.list > /dev/null
sudo apt update
sudo apt install -y spotify-client

echo "==> Installing Slack..."
wget -O slack.deb "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-desktop-4.43.51-amd64.deb"
sudo dpkg -i slack.deb
sudo apt install -f -y


sudo apt autoremove -y
sudo apt clean
sudo apt autoclean
echo "==> Cleaning up..."

echo "==> Installation ended! Rebooting system in 5 seconds."
sleep 5
sudo reboot

