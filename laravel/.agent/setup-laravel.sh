#!/bin/bash

# ============================================
# Laravel Docker Setup Script
# ============================================
# Usage: bash setup-laravel.sh [project-directory]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-.}"

# Validate inputs
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}Error: Project directory does not exist: $PROJECT_DIR${NC}"
    exit 1
fi

PROJECT_NAME=$(basename "$PROJECT_DIR")
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]//g')

# Functions
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo -e "${CYAN}→ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# ============================================
# Main Setup
# ============================================

print_header "Laravel Docker Setup"
echo "Project Directory: $PROJECT_DIR"
echo "Project Name: $PROJECT_NAME"
echo ""

# Step 1: Copy template files
print_section "Step 1: Copying Docker files..."

cd "$PROJECT_DIR"

# Copy docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    print_info "docker-compose.yml already exists, skipping..."
else
    cp "$TEMPLATE_DIR/docker-compose.base.yml" "docker-compose.yml"
    print_success "Copied docker-compose.yml"
fi

# Copy .env
if [ -f ".env" ]; then
    print_info ".env already exists, skipping..."
else
    cp "$TEMPLATE_DIR/.env.template" ".env"
    print_success "Copied .env"
fi

# Copy Dockerfile
if [ -f "Dockerfile" ]; then
    print_info "Dockerfile already exists, skipping..."
else
    cp "$TEMPLATE_DIR/../Dockerfile" "Dockerfile"
    print_success "Copied Dockerfile"
fi

# Step 2: Create Docker config directories
print_section "Step 2: Creating Docker config directories..."

mkdir -p ".docker/mysql"
mkdir -p ".docker/mysql/init"
print_success "Created .docker directories"

# Step 3: Update .env
print_section "Step 3: Updating environment variables..."

if [ -f ".env.backup" ]; then
    print_info ".env.backup already exists"
else
    cp .env .env.backup
    print_success "Created .env.backup"
fi

# Update .env values
update_env() {
    local key=$1
    local value=$2
    if grep -q "^$key=" .env; then
        sed -i "s|^$key=.*|$key=$value|" .env
    else
        echo "$key=$value" >> .env
    fi
}

update_env "PROJECT_NAME" "$PROJECT_NAME"
update_env "APP_NAME" "$(echo $PROJECT_NAME | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g')"

print_success "Updated PROJECT_NAME to: $PROJECT_NAME"

# Step 4: Create .gitignore entries
print_section "Step 4: Updating .gitignore..."

if [ -f ".gitignore" ]; then
    for entry in ".env" ".env.*.local" ".docker/*/data"; do
        if ! grep -q "^$entry$" .gitignore; then
            echo "$entry" >> .gitignore
            print_success "Added $entry to .gitignore"
        fi
    done
else
    cat > ".gitignore" << 'EOF'
# Environment
.env
.env.local
.env.*.local
.env.backup

# Docker
.docker/*/data
.docker/*/logs
docker-compose.override.yml

# Laravel
/vendor/
node_modules/
npm-debug.log
yarn-error.log
.DS_Store
.env.*.php
.idea/
.vscode/
*.swp
*.swo
EOF
    print_success "Created .gitignore"
fi

# Step 5: Create docker-compose.override.yml
print_section "Step 5: Creating docker-compose.override.yml..."

if [ ! -f "docker-compose.override.yml" ]; then
    cat > docker-compose.override.yml << 'EOF'
# Local development overrides
version: "3.9"

services:
  app:
    # Uncomment for debugging
    # environment:
    #   - APP_DEBUG=true
    #   - LOG_LEVEL=debug
EOF
    print_success "Created docker-compose.override.yml"
fi

# Step 6: Summary
print_header "Setup Complete! ✓"

echo "Project Details:"
echo "  Name: $PROJECT_NAME"
echo "  Directory: $PROJECT_DIR"
echo ""
echo "Next Steps:"
echo "  1. Edit .env with your settings"
echo "  2. Run: docker compose up -d"
echo "  3. Run: docker compose exec app composer install"
echo "  4. Run: docker compose exec app php artisan key:generate"
echo "  5. Run: docker compose exec app php artisan migrate"
echo ""
echo "Access:"
echo "  App: http://localhost:8000"
echo "  Database (Adminer): http://localhost:8888"
echo "  Mail (Mailhog): http://localhost:8025"
echo ""

read -p "Start Docker containers now? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_section "Building and starting containers..."
    docker compose up -d
    echo ""
    docker compose ps
    echo ""
    print_success "Containers started!"
    echo ""
    echo "Initialize Laravel:"
    echo "  docker compose exec app composer install"
    echo "  docker compose exec app php artisan key:generate"
    echo "  docker compose exec app php artisan migrate"
fi

print_success "Setup complete!"
