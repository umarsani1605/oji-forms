#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_API=true
BUILD_CLIENT=true

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --api-only) BUILD_CLIENT=false ;;
        --client-only) BUILD_API=false ;;
        --help) 
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --api-only      Build only API image"
            echo "  --client-only   Build only Client image"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *) echo -e "${RED}Unknown parameter: $1${NC}"; exit 1 ;;
    esac
    shift
done

cd "$PROJECT_ROOT"

echo -e "${BLUE}Building Oji Forms custom Docker images...${NC}"

# Check if Dockerfiles exist
if [ "$BUILD_API" = true ] && [ ! -f "docker/Dockerfile.api" ]; then
    echo -e "${RED}Error: docker/Dockerfile.api not found!${NC}"
    exit 1
fi

if [ "$BUILD_CLIENT" = true ] && [ ! -f "docker/Dockerfile.client" ]; then
    echo -e "${RED}Error: docker/Dockerfile.client not found!${NC}"
    exit 1
fi

# Setup environment files if they don't exist
if [ ! -f "api/.env" ] || [ ! -f "client/.env" ]; then
    echo -e "${GREEN}Setting up environment files...${NC}"
    if [ -f "$SCRIPT_DIR/setup-env.sh" ]; then
        bash "$SCRIPT_DIR/setup-env.sh" --docker
    else
        echo -e "${YELLOW}Warning: setup-env.sh not found. Make sure environment files exist.${NC}"
    fi
fi

# Build API image
if [ "$BUILD_API" = true ]; then
    echo -e "${GREEN}Building API image...${NC}"
    docker build -t oji-forms-api:latest -f docker/Dockerfile.api . || {
        echo -e "${RED}Failed to build API image!${NC}"
        exit 1
    }
    echo -e "${GREEN}✓ API image built successfully${NC}"
fi

# Build Client image  
if [ "$BUILD_CLIENT" = true ]; then
    echo -e "${GREEN}Building Client image...${NC}"
    docker build -t oji-forms-client:latest -f docker/Dockerfile.client . || {
        echo -e "${RED}Failed to build Client image!${NC}"
        exit 1
    }
    echo -e "${GREEN}✓ Client image built successfully${NC}"
fi

echo -e "${BLUE}Custom images built successfully!${NC}"

# Display built images
echo -e "${YELLOW}Built images:${NC}"
if [ "$BUILD_API" = true ]; then
    echo -e "${GREEN}  - oji-forms-api:latest${NC}"
fi
if [ "$BUILD_CLIENT" = true ]; then
    echo -e "${GREEN}  - oji-forms-client:latest${NC}"
fi

# Display next steps
echo -e "${BLUE}Next Steps:${NC}"
echo -e "${YELLOW}1. Stop development containers (if running):${NC}"
echo -e "   docker compose -f docker-compose.dev.yml down"
echo -e "${YELLOW}2. Deploy production with custom images:${NC}"
echo -e "   docker compose up -d"
echo -e "${YELLOW}3. Access your application at:${NC}"
echo -e "   ${GREEN}http://localhost${NC}"

# Display admin credentials
echo -e "${BLUE}Default admin credentials:${NC}"
echo -e "${GREEN}Email: admin@opnform.com${NC}"
echo -e "${GREEN}Password: password${NC}"

echo -e "${YELLOW}⚠️  Remember to change default credentials after first login!${NC}" 