# Ubuntu Server Setup Script

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=gnu-bash&logoColor=white)

A comprehensive setup script for Ubuntu servers that automates the installation and configuration of essential software, security tools, and development environments.

## 🚀 Features

This script automates the installation and configuration of:

### 🖥️ Terminal Environment
- Zsh shell (installed first)
- Oh My Zsh with useful plugins
- Helpful shell aliases for improved productivity

### 🔒 System & Security
- System updates and upgrades
- SSH server with secure configuration
- UFW (Uncomplicated Firewall) with SSH protection
- Fail2Ban for brute force attack prevention

### 🌐 Web Server
- Nginx web server with a custom welcome page
- HTTP/HTTPS firewall configuration

### 💻 Development Tools
- Vim text editor
- Rust via rustup
  - bat (a better cat replacement)
  - lsd (a modern ls alternative)
- Python, pip, and virtual environments
- uv - the fast Python package installer
- Node.js and NPM
- PM2 process manager (configured to start on boot)
- pnpm package manager
- Tailwind CSS (global installation)
- shadcn/ui CLI (global installation)

## 📋 Prerequisites

- A fresh Ubuntu server installation
- Root or sudo privileges

## 🔧 Usage

### Option 1: Download and Run

```bash
# Download the script
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/ubuntu-server-setup/main/ubuntu_update.sh

# Make it executable
chmod +x ubuntu_update.sh

# Run the script
sudo ./ubuntu_update.sh
```

### Option 2: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ubuntu-server-setup.git

# Navigate to the directory
cd ubuntu-server-setup

# Make the script executable
chmod +x ubuntu_update.sh

# Run the script
sudo ./ubuntu_update.sh
```

## ⚠️ Important Notes

1. **Zsh Setup**: The script installs Zsh and Oh My Zsh first, making it the default shell. All configurations are added to `.zshrc` only.

2. **SSH Security**: The script configures UFW to allow SSH connections before enabling the firewall to prevent lockout.

3. **Fail2Ban Configuration**: A custom Fail2Ban configuration is created to protect against brute force attacks on SSH and Nginx.

4. **Shell Change**: You'll need to log out and log back in for the shell change to Zsh to take effect.

5. **Development Tools**: Tailwind CSS and shadcn/ui CLI are installed globally, so you can use them in any project with the `tailwindcss` and `shadcn-ui` commands.

6. **Rust Tools**: The script installs `bat` (a better `cat` replacement) and `lsd` (a modern `ls` alternative) with convenient aliases configured in Zsh.

## 🔍 What the Script Does

1. **Installs Zsh & Oh My Zsh**: Sets up the Zsh shell environment first

2. **Updates System**: Runs `apt update` and `apt upgrade`

3. **Configures SSH**: Installs and secures the SSH server

4. **Sets Up Firewall**: Configures UFW with SSH protection

5. **Installs Nginx**: Sets up a web server with a custom welcome page

6. **Configures Fail2Ban**: Protects against brute force attacks

7. **Installs Rust and Tools**: Sets up Rust via rustup and installs bat and lsd

8. **Installs Python Tools**: Sets up Python, pip, and uv package installer

9. **Installs Node.js Tools**: Sets up Node.js, PM2, pnpm, and global frontend tools

## 🛠️ Customization

You can customize the script by editing it before running:

```bash
# Open the script in Vim
vim ubuntu_update.sh

# Or with nano
nano ubuntu_update.sh
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Created with ❤️ for Ubuntu server administrators and developers.
