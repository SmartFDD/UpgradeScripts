#!/bin/bash

# Check if nvm (Node Version Manager) is installed
if ! command -v nvm &> /dev/null; then
    echo "nvm is not installed. Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Function to get latest LTS version
get_latest_lts() {
    nvm ls-remote --lts | grep Latest | tail -n1 | awk '{print $1}'
}

# Get current version
current_version=$(node -v 2>/dev/null)

echo "Current Node.js version: $current_version"
echo "Fetching latest LTS version..."

# Get the latest LTS version
latest_version=$(get_latest_lts)

if [ -z "$latest_version" ]; then
    echo "Error: Could not fetch latest Node.js version"
    exit 1
fi

echo "Latest LTS version available: $latest_version"

# Install and use the latest version
echo "Installing latest Node.js version..."
nvm install "$latest_version"
nvm use "$latest_version"
nvm alias default "$latest_version"

# Verify the installation
new_version=$(node -v)
echo "Successfully upgraded Node.js from $current_version to $new_version"

# Update npm to latest version
echo "Updating npm to latest version..."
npm install -g npm@latest

echo "Node.js upgrade complete!"
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"
