#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ASCII Art
echo -e "${GREEN}"
cat << "EOF"

 ░░░░░░       ░░ ░░     ░░░░░░░  ░░░░░░  ░░░░░░  ░░░    ░░░ 
▒▒    ▒▒      ▒▒ ▒▒     ▒▒      ▒▒    ▒▒ ▒▒   ▒▒ ▒▒▒▒  ▒▒▒▒ 
▒▒    ▒▒      ▒▒ ▒▒     ▒▒▒▒▒   ▒▒    ▒▒ ▒▒▒▒▒▒  ▒▒ ▒▒▒▒ ▒▒ 
▓▓    ▓▓ ▓▓   ▓▓ ▓▓     ▓▓      ▓▓    ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓ 
 ██████   █████  ██     ██       ██████  ██   ██ ██      ██ 

EOF
echo -e "${NC}"

# Default values
DEV_MODE=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --dev) DEV_MODE=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

cd "$PROJECT_ROOT"

echo -e "${BLUE}Starting Oji Forms Docker setup...${NC}"

# Run the environment setup script with --docker flag
echo -e "${GREEN}Setting up environment files...${NC}"
bash "$SCRIPT_DIR/setup-env.sh" --docker

# Determine which compose file to use
if [ "$DEV_MODE" = true ]; then
    echo -e "${YELLOW}Development mode enabled - using minimal setup with docker-compose.dev.yml${NC}"
    COMPOSE_FILE="docker-compose.dev.yml"
else
    echo -e "${YELLOW}Production mode - using docker-compose.yml${NC}"
    COMPOSE_FILE="docker-compose.yml"
    
    # Build custom API image
    echo -e "${GREEN}Building custom API image...${NC}"
    docker build -t oji-forms-api:custom -f docker/Dockerfile.api .
    echo -e "${GREEN}✓ Custom API image built successfully${NC}"
    
    # Build custom frontend image
    echo -e "${GREEN}Building custom frontend image...${NC}"
    docker build -t oji-forms-client:custom -f docker/Dockerfile.client .
    echo -e "${GREEN}✓ Custom frontend image built successfully${NC}"
fi

# Start Docker containers
echo -e "${GREEN}Starting Docker containers...${NC}"
docker compose -f $COMPOSE_FILE up -d

# Display access instructions
if [ "$DEV_MODE" = true ]; then
    echo -e "${BLUE}Development environment setup complete!${NC}"
    echo -e "${YELLOW}Please wait for the frontend to finish building (this may take a few minutes)${NC}"
    echo -e "${GREEN}Then visit: http://localhost:3000${NC}"
else
    echo -e "${BLUE}Oji Forms production environment setup complete!${NC}"
    echo -e "${GREEN}✓ Using custom API image with your backend customizations${NC}"
    echo -e "${GREEN}✓ Using custom frontend image with your UI customizations${NC}"
    echo -e "${YELLOW}Please wait a moment for all services to start${NC}"
    echo -e "${GREEN}Then visit: http://localhost${NC}"
fi

echo -e "${BLUE}Default admin credentials:${NC}"
echo -e "${GREEN}Email: admin@opnform.com${NC}"
echo -e "${GREEN}Password: password${NC}" 
