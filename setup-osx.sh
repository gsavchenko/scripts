#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Note:
# - Run these two commands in your terminal to add Homebrew to your PATH:
#     (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/george/.zprofile
#     eval "$(/opt/homebrew/bin/brew shellenv)"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# modify .zshrc theme
ZSHRC="$HOME/.zshrc"

# Check if the ZSH_THEME line exists
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
    # If it exists, modify it
    sed -i.bak 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
else
    # If it doesn't exist, append it
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

echo "ZSH_THEME updated successfully!"
