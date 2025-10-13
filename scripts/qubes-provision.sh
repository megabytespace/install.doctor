#!/usr/bin/env bash
#!/usr/bin/env bash
# @file Provision Qubes
# @brief Provisions Qubes
# @description
#     Provisions Qubes.

set -euo pipefail

PROJECT_HOME="$HOME/qubes-cluster"
LOG_FILE="/var/log/qubes-cluster-install.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "🚀 Starting Qubes Cluster installation..."

# Install system dependencies
log_message "Installing system dependencies..."
sudo dnf install -y nodejs npm glusterfs-server pulumi

# Clone repository
if [ ! -d "$PROJECT_HOME" ]; then
    log_message "Cloning repository..."
    git clone https://github.com/your-repo/qubes-cluster.git "$PROJECT_HOME"
fi

# Install Node.js dependencies
log_message "Installing Node.js dependencies..."
cd "$PROJECT_HOME/ts-services/nestjs-app"
npm install

cd "$PROJECT_HOME/ts-services/electron-app"
npm install

cd "$PROJECT_HOME/ts-services/angular-ui"
npm install

# Build applications
log_message "Building applications..."
cd "$PROJECT_HOME/ts-services/nestjs-app"
npm run build

cd "$PROJECT_HOME/ts-services/electron-app"
npm run build

cd "$PROJECT_HOME/ts-services/angular-ui"
npm run build

# Deploy infrastructure with Pulumi
log_message "Deploying Qubes infrastructure with Pulumi..."
cd "$PROJECT_HOME/ts-services/pulumi-config"
pulumi up --yes

# Start system services
log_message "Starting system services..."
systemctl enable --now qubes-cluster.service

log_message "✅ Qubes Cluster installation completed successfully!"
