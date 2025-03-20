#!/bin/bash

# ubuntu_update.sh
# Script to update Ubuntu server packages and install essential tools
# Created: 2025-03-20

echo "Starting Ubuntu server update process..."

# Update package lists
echo "Updating package lists..."
sudo apt update

# Upgrade packages
echo "Upgrading packages..."
sudo apt upgrade -y

# Install Zsh and Oh My Zsh first
echo "Installing Zsh and dependencies..."
sudo apt install -y zsh curl git

# Set up Oh My Zsh
echo "Setting up Oh My Zsh..."
# Check if Oh My Zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # Install Oh My Zsh
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed"
else
    echo "Oh My Zsh is already installed"
fi

# Change default shell to Zsh for the current user
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

# Set up some useful plugins (optional)
if [ -f "$HOME/.zshrc" ]; then
    # Backup original .zshrc
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    
    # Update plugins line to include useful plugins
    sed -i 's/plugins=(git)/plugins=(git sudo history dirhistory command-not-found colored-man-pages)/' "$HOME/.zshrc"
    
    echo "Zsh configured with useful plugins"
fi

echo "Zsh and Oh My Zsh setup completed. Note that shell change will take effect after logging out and back in."

# Install and configure SSH server
echo "Installing and configuring SSH server..."
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
echo "SSH server installed and started"

# Install and configure UFW (Uncomplicated Firewall)
echo "Installing and configuring UFW..."
sudo apt install -y ufw

# IMPORTANT: Allow SSH before enabling the firewall to prevent lockout
echo "Configuring UFW to allow SSH connections before enabling..."
sudo ufw allow ssh

# Limit SSH connection attempts to protect against brute force attacks
echo "Limiting SSH connection attempts to protect against brute force attacks..."
sudo ufw limit ssh

# Install and configure Nginx
echo "Installing Nginx web server..."
sudo apt install -y nginx

# Enable and start Nginx
echo "Enabling and starting Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

# Allow HTTP and HTTPS through firewall
echo "Configuring firewall to allow HTTP and HTTPS traffic..."
sudo ufw allow 'Nginx Full'

# Create a basic index.html file
echo "Creating a basic index.html file..."
cat << 'EOF' | sudo tee /var/www/html/index.html > /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx on Ubuntu!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            color: #0088cc;
        }
        .success {
            color: #4CAF50;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <h1>Welcome to Nginx on Ubuntu!</h1>
    <p class="success">u2705 Nginx has been successfully installed and configured.</p>
    <p>If you can see this page, your Nginx web server is working properly.</p>
    <p>This is a placeholder page. Replace this with your own content.</p>
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.</p>
    <p>Server setup completed on: $(date)</p>
</body>
</html>
EOF

echo "Nginx installed and configured"

# Install and configure Fail2Ban
echo "Installing Fail2Ban..."
sudo apt install -y fail2ban

# Create custom Fail2Ban configuration (best practice to avoid overwriting during updates)
echo "Configuring Fail2Ban..."
if [ ! -f /etc/fail2ban/jail.local ]; then
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    echo "Created jail.local from jail.conf"
fi

# Configure Fail2Ban with stronger settings
cat << 'EOF' | sudo tee /etc/fail2ban/jail.local > /dev/null
[DEFAULT]
# Ban hosts for one hour
bantime = 3600

# Find failures within a 10-minute window
findtime = 600

# Allow 3 retries before banning
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
port = http,https
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 6
EOF

# Restart Fail2Ban to apply changes
echo "Restarting Fail2Ban service..."
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban
echo "Fail2Ban installed and configured"

# Verify SSH rule was added successfully
if sudo ufw status | grep -q "22/tcp.*ALLOW"; then
    echo "SSH access confirmed. It is safe to enable the firewall."
    # Enable UFW
    echo "Enabling UFW firewall..."
    sudo ufw --force enable
    echo "UFW installed and configured with SSH access allowed and rate limiting enabled"
else
    echo "WARNING: Could not confirm SSH access rule. Firewall NOT enabled to prevent lockout."
    echo "Please manually configure UFW with: sudo ufw allow ssh && sudo ufw limit ssh && sudo ufw enable"
fi

# Install Vim
echo "Installing Vim..."
sudo apt install -y vim
echo "Vim installed"

# Install Rust via rustup
echo "Installing Rust via rustup..."

# Install dependencies
sudo apt install -y build-essential curl

# Install rustup and Rust with default settings (non-interactive)
echo "Installing rustup and Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add Rust to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Add Rust to PATH permanently (only in zshrc since we're using zsh)
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc

# Install bat (a better cat replacement)
echo "Installing bat (a better cat replacement)..."
cargo install bat

# Install lsd (a modern ls alternative)
echo "Installing lsd (a modern ls alternative)..."
cargo install lsd

# Create aliases for bat and lsd (only in zshrc)
echo "Creating aliases for bat and lsd..."

cat << 'EOF' >> ~/.zshrc

# Rust tool aliases
alias cat='bat --paging=never'
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -la'
alias lt='lsd --tree'
EOF

echo "Rust, bat, and lsd installed and configured"

# Install Python and pip
echo "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Install uv - the fast Python package installer
echo "Installing uv Python package installer..."
curl -sSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Add uv to PATH permanently (only in zshrc)
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc

echo "uv installed and configured"

# Install Node.js and NPM
echo "Installing Node.js and NPM..."
sudo apt install -y nodejs npm

# Check if Node.js is installed correctly
node_version=$(node -v)
if [ $? -eq 0 ]; then
    echo "Node.js $node_version installed successfully"
    
    # Install PM2 globally
    echo "Installing PM2 process manager..."
    sudo npm install -g pm2
    
    # Configure PM2 to start on boot
    echo "Configuring PM2 to start on system boot..."
    pm2 startup | grep "sudo" | bash
    
    echo "PM2 installed and configured to start on boot"
    
    # Install pnpm
    echo "Installing pnpm package manager..."
    sudo npm install -g pnpm
    
    # Set up pnpm global directory
    echo "Setting up pnpm global directory..."
    pnpm setup
    
    # Add pnpm to PATH (for current session)
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    
    # Add pnpm to PATH permanently (only in zshrc)
    echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.zshrc
    echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.zshrc
    
    echo "pnpm installed and configured"
    
    # Install Tailwind CSS and shadcn/ui CLI globally
    echo "Installing Tailwind CSS and shadcn/ui CLI globally..."
    
    # Install Tailwind CSS globally
    echo "Installing Tailwind CSS globally..."
    sudo npm install -g tailwindcss
    
    # Install shadcn/ui CLI globally
    echo "Installing shadcn/ui CLI globally..."
    sudo npm install -g shadcn-ui
    
    echo "Tailwind CSS and shadcn/ui CLI installed globally"
    echo "You can now use these tools in any project with 'tailwindcss' and 'shadcn-ui' commands"
else
    echo "WARNING: Node.js installation failed. PM2, pnpm, Tailwind CSS and shadcn/ui installation skipped."
fi

# Clean up unnecessary packages
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y
sudo apt autoclean

echo "Ubuntu server update and configuration completed successfully!"
echo "NOTE: Please log out and log back in for the shell change to Zsh to take effect."
