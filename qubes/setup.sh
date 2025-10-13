#!/usr/bin/env bash
# @file Qubes Cluster Kickstart Script
# @description This script sets up the initial environment for the Qubes OS cluster by installing Node.js, TypeScript, and the core TypeScript-based cluster management application.

set -euo pipefail

### Configuration Variables ###
NODE_VERSION="18.x"  # Node.js version to install
INSTALL_DIR="/opt/qubes-cluster"  # Directory where the TypeScript application will be installed
GIT_REPO="https://github.com/your-repo/qubes-cluster.git"  # Repository containing the TypeScript application
LOG_FILE="/var/log/qubes-cluster-setup.log"  # Log file for setup process

### Function: logMessage ###
# @description Logs messages to both console and a log file.
logMessage() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

### Function: errorHandler ###
# @description Handles errors and logs them.
errorHandler() {
    logMessage "❌ Error encountered during execution. Check $LOG_FILE for details."
    exit 1
}
trap errorHandler ERR

### Function: installDependencies ###
# @description Installs Node.js and TypeScript globally.
installDependencies() {
    logMessage "Installing Node.js and TypeScript..."
    curl -fsSL https://rpm.nodesource.com/setup_$NODE_VERSION | sudo bash -
    sudo dnf install -y nodejs
    sudo npm install -g typescript pm2
    logMessage "✅ Node.js and TypeScript installed!"
}

### Function: cloneRepository ###
# @description Clones the Qubes Cluster TypeScript repository.
cloneRepository() {
    logMessage "Cloning the Qubes Cluster repository..."
    sudo mkdir -p "$INSTALL_DIR"
    if [ -d "$INSTALL_DIR/.git" ]; then
        logMessage "Repository already exists. Pulling latest changes..."
        cd "$INSTALL_DIR" && sudo git pull
    else
        sudo git clone "$GIT_REPO" "$INSTALL_DIR"
    fi
    logMessage "✅ Repository ready!"
}

### Function: installNodeModules ###
# @description Installs necessary npm dependencies for the TypeScript application.
installNodeModules() {
    logMessage "Installing Node.js dependencies..."
    cd "$INSTALL_DIR"
    npm install --silent
    logMessage "✅ Dependencies installed!"
}

### Function: buildApplication ###
# @description Compiles the TypeScript application.
buildApplication() {
    logMessage "Building the TypeScript application..."
    cd "$INSTALL_DIR"
    npm run build --silent
    logMessage "✅ Application built!"
}

### Function: configureSystemService ###
# @description Sets up a systemd service to run the TypeScript-based cluster management application.
configureSystemService() {
    logMessage "Configuring systemd service for Qubes Cluster..."
    cat <<EOF | sudo tee /etc/systemd/system/qubes-cluster.service > /dev/null
[Unit]
Description=Qubes Cluster Management Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node "$INSTALL_DIR/dist/main.js"
Restart=always
User=root
StandardOutput=append:/var/log/qubes-cluster-service.log
StandardError=append:/var/log/qubes-cluster-service-error.log

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl enable qubes-cluster.service
    sudo systemctl start qubes-cluster.service
    logMessage "✅ Qubes Cluster service configured and started!"
}

### Function: validateInstallation ###
# @description Checks if all components were installed correctly.
validateInstallation() {
    logMessage "Validating installation..."
    node -v | tee -a "$LOG_FILE"
    npm -v | tee -a "$LOG_FILE"
    systemctl status qubes-cluster.service --no-pager | tee -a "$LOG_FILE"
    logMessage "✅ Installation validation complete."
}

### Main Execution ###
logMessage "🚀 Starting Qubes Cluster setup..."
installDependencies
cloneRepository
installNodeModules
buildApplication
configureSystemService
validateInstallation
logMessage "🚀 Qubes Cluster setup complete! The TypeScript-based cluster manager is now running."
