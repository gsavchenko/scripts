#!/bin/bash

if [ -f ~/.oh-my-zsh/custom/themes/powerlevel10k.zsh-theme ]; then
  echo "Oh My Zsh and Powerlevel10k already installed. Skipping installation."
  exit 0
fi

if [ ! -f ~/.first_run ]; then
  echo "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
 
   # Install curl
  echo "Installing curl..."
  sudo apt install -y curl

  # Install Git
  echo "Installing Git..."
  sudo apt install -y git-all

  git config --global user.email "george.savchenko@gmail.com"
  git config --global user.name "George Savchenko"

  # First run: Install Zsh, set it as the default shell, and prompt to log out
  echo "Installing Zsh..."
  sudo apt install -y zsh

  echo "Setting Zsh as the default shell..."
  chsh -s $(which zsh)

  echo "Please log out and log back in to continue with the installation."
  touch ~/.first_run
  exit 0
fi

if [ ! -d ~/.nvm ]; then
  # Install nvm and use it to install Node.js LTS
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

  echo "Sourcing nvm..."
  source ~/.nvm/nvm.sh

  echo "Installing Node.js LTS..."
  nvm install --lts
fi

# SSH Key Generation
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "george.savchenko@gmail.com"
  echo "SSH key generated. Please add the following public key to your GitHub account:"
  cat ~/.ssh/id_rsa.pub
  echo "Press Enter to continue after adding the public key to your GitHub account"
  read -r
fi

# Clone repository
echo "Cloning repository..."
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/gsavchenko/george-webapp

# Install zsh plugins
if [ -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
  if ! grep -q "zsh-history-substring-search" ~/.zshrc ; then
    echo "Installing zsh-history-substring-search plugin..."
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
  fi

  if ! grep -q "zsh-autosuggestions" ~/.zshrc ; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  fi

  if ! grep -q "zsh-syntax-highlighting" ~/.zshrc ; then
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  fi
fi

if [ -f ~/.second_run ]; then
  # Second run: Continue with the remaining steps
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  echo "Updating Zsh theme..."
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

  echo "Please install the required fonts manually. Refer to the Powerlevel10k documentation for instructions."

  echo "Restart your terminal to apply the changes."

  rm -f ~/.first_run
fi

